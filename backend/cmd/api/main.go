package main

import (
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"

	"github.com/wealthpath/backend/internal/handler"
	"github.com/wealthpath/backend/internal/repository"
	"github.com/wealthpath/backend/internal/service"
)

func main() {
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		dbURL = "postgres://localhost:5432/wealthpath?sslmode=disable"
	}

	db, err := sqlx.Connect("postgres", dbURL)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	// Run migrations
	if err := runMigrations(db); err != nil {
		log.Printf("Warning: migration error: %v", err)
	}

	// Initialize repositories
	userRepo := repository.NewUserRepository(db)
	transactionRepo := repository.NewTransactionRepository(db)
	budgetRepo := repository.NewBudgetRepository(db)
	savingsRepo := repository.NewSavingsGoalRepository(db)
	debtRepo := repository.NewDebtRepository(db)

	// Initialize services
	userService := service.NewUserService(userRepo)
	transactionService := service.NewTransactionService(transactionRepo)
	budgetService := service.NewBudgetService(budgetRepo)
	savingsService := service.NewSavingsGoalService(savingsRepo)
	debtService := service.NewDebtService(debtRepo)
	dashboardService := service.NewDashboardService(transactionRepo, budgetRepo, savingsRepo, debtRepo)

	// Initialize handlers
	authHandler := handler.NewAuthHandler(userService)
	transactionHandler := handler.NewTransactionHandler(transactionService)
	budgetHandler := handler.NewBudgetHandler(budgetService)
	savingsHandler := handler.NewSavingsGoalHandler(savingsService)
	debtHandler := handler.NewDebtHandler(debtService)
	dashboardHandler := handler.NewDashboardHandler(dashboardService)

	r := chi.NewRouter()

	// Middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.RequestID)
	// CORS - allow frontend origin from env or default
	allowedOrigins := os.Getenv("ALLOWED_ORIGINS")
	if allowedOrigins == "" {
		allowedOrigins = "http://localhost:3000"
	}
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{allowedOrigins},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Health check
	r.Get("/api/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"status":"ok"}`))
	})

	// Public routes
	r.Post("/api/auth/register", authHandler.Register)
	r.Post("/api/auth/login", authHandler.Login)

	// Protected routes
	r.Group(func(r chi.Router) {
		r.Use(handler.AuthMiddleware)

		// Dashboard
		r.Get("/api/dashboard", dashboardHandler.GetDashboard)
		r.Get("/api/dashboard/monthly/{year}/{month}", dashboardHandler.GetMonthlyDashboard)

		// Transactions
		r.Get("/api/transactions", transactionHandler.List)
		r.Post("/api/transactions", transactionHandler.Create)
		r.Get("/api/transactions/{id}", transactionHandler.Get)
		r.Put("/api/transactions/{id}", transactionHandler.Update)
		r.Delete("/api/transactions/{id}", transactionHandler.Delete)

		// Budgets
		r.Get("/api/budgets", budgetHandler.List)
		r.Post("/api/budgets", budgetHandler.Create)
		r.Get("/api/budgets/{id}", budgetHandler.Get)
		r.Put("/api/budgets/{id}", budgetHandler.Update)
		r.Delete("/api/budgets/{id}", budgetHandler.Delete)

		// Savings Goals
		r.Get("/api/savings-goals", savingsHandler.List)
		r.Post("/api/savings-goals", savingsHandler.Create)
		r.Get("/api/savings-goals/{id}", savingsHandler.Get)
		r.Put("/api/savings-goals/{id}", savingsHandler.Update)
		r.Delete("/api/savings-goals/{id}", savingsHandler.Delete)
		r.Post("/api/savings-goals/{id}/contribute", savingsHandler.Contribute)

		// Debt Management
		r.Get("/api/debts", debtHandler.List)
		r.Post("/api/debts", debtHandler.Create)
		r.Get("/api/debts/{id}", debtHandler.Get)
		r.Put("/api/debts/{id}", debtHandler.Update)
		r.Delete("/api/debts/{id}", debtHandler.Delete)
		r.Post("/api/debts/{id}/payment", debtHandler.MakePayment)
		r.Get("/api/debts/{id}/payoff-plan", debtHandler.GetPayoffPlan)
		r.Get("/api/debts/calculator", debtHandler.InterestCalculator)
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server starting on port %s", port)
	if err := http.ListenAndServe(":"+port, r); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}

func runMigrations(db *sqlx.DB) error {
	schema := `
	CREATE TABLE IF NOT EXISTS users (
		id UUID PRIMARY KEY,
		email VARCHAR(255) UNIQUE NOT NULL,
		password_hash VARCHAR(255) NOT NULL,
		name VARCHAR(255) NOT NULL,
		currency VARCHAR(3) DEFAULT 'USD',
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	);
	CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

	CREATE TABLE IF NOT EXISTS transactions (
		id UUID PRIMARY KEY,
		user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
		type VARCHAR(20) NOT NULL CHECK (type IN ('income', 'expense')),
		amount DECIMAL(15, 2) NOT NULL,
		currency VARCHAR(3) DEFAULT 'USD',
		category VARCHAR(100) NOT NULL,
		description TEXT,
		date DATE NOT NULL,
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	);
	CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
	CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date);

	CREATE TABLE IF NOT EXISTS budgets (
		id UUID PRIMARY KEY,
		user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
		category VARCHAR(100) NOT NULL,
		amount DECIMAL(15, 2) NOT NULL,
		currency VARCHAR(3) DEFAULT 'USD',
		period VARCHAR(20) DEFAULT 'monthly' CHECK (period IN ('weekly', 'monthly', 'yearly')),
		start_date DATE NOT NULL,
		end_date DATE,
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	);
	CREATE INDEX IF NOT EXISTS idx_budgets_user_id ON budgets(user_id);

	CREATE TABLE IF NOT EXISTS savings_goals (
		id UUID PRIMARY KEY,
		user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
		name VARCHAR(255) NOT NULL,
		target_amount DECIMAL(15, 2) NOT NULL,
		current_amount DECIMAL(15, 2) DEFAULT 0,
		currency VARCHAR(3) DEFAULT 'USD',
		target_date DATE,
		color VARCHAR(7) DEFAULT '#3B82F6',
		icon VARCHAR(50) DEFAULT 'piggy-bank',
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	);
	CREATE INDEX IF NOT EXISTS idx_savings_goals_user_id ON savings_goals(user_id);

	CREATE TABLE IF NOT EXISTS debts (
		id UUID PRIMARY KEY,
		user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
		name VARCHAR(255) NOT NULL,
		type VARCHAR(50) NOT NULL CHECK (type IN ('mortgage', 'auto_loan', 'student_loan', 'credit_card', 'personal_loan', 'other')),
		original_amount DECIMAL(15, 2) NOT NULL,
		current_balance DECIMAL(15, 2) NOT NULL,
		interest_rate DECIMAL(5, 2) NOT NULL,
		minimum_payment DECIMAL(15, 2) NOT NULL,
		currency VARCHAR(3) DEFAULT 'USD',
		due_day INTEGER CHECK (due_day >= 1 AND due_day <= 31),
		start_date DATE NOT NULL,
		expected_payoff DATE,
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	);
	CREATE INDEX IF NOT EXISTS idx_debts_user_id ON debts(user_id);

	CREATE TABLE IF NOT EXISTS debt_payments (
		id UUID PRIMARY KEY,
		debt_id UUID NOT NULL REFERENCES debts(id) ON DELETE CASCADE,
		amount DECIMAL(15, 2) NOT NULL,
		principal DECIMAL(15, 2) NOT NULL,
		interest DECIMAL(15, 2) NOT NULL,
		date DATE NOT NULL,
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	);
	CREATE INDEX IF NOT EXISTS idx_debt_payments_debt_id ON debt_payments(debt_id);
	`

	_, err := db.Exec(schema)
	if err != nil {
		return err
	}
	log.Println("Database migrations completed")
	return nil
}

