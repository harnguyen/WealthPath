# WealthPath - Personal Finance Tracker

A comprehensive full-stack personal finance management application built with Go, Next.js, and Spring Boot.

![WealthPath](https://img.shields.io/badge/WealthPath-Finance-8B5CF6)
![Go](https://img.shields.io/badge/Backend-Go%201.24-00ADD8)
![Next.js](https://img.shields.io/badge/Frontend-Next.js%2014-000000)
![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-336791)

## ✨ Features

### Core Financial Features
- **Transaction Tracking** - Log income/expenses with categories, descriptions, and dates
- **Budget Management** - Set spending limits by category with real-time progress tracking
- **Savings Goals** - Create goals, track contributions, and visualize progress
- **Recurring Transactions** - Automated bills, salary, and subscription management
- **Monthly Dashboard** - Visual overview with charts and financial insights
- **Financial Calculators** - Loan payment and savings projection calculators

### Debt Management
- Track multiple debt types (mortgages, auto loans, credit cards, student loans)
- Interest rate tracking and monitoring
- Amortization schedules and payoff planning
- Payment history with principal/interest breakdown
- Debt payoff projections

### User Experience
- **Authentication** - Email/password + Google OAuth integration
- **Internationalization (i18n)** - Multi-language support
- **AI Financial Assistant** - Chat powered by OpenAI
- **Admin Dashboard** - Spring Boot-based admin panel for user management

## 🛠️ Tech Stack

### Backend (Go)
- **Go 1.24** - High-performance backend
- **Chi Router v5** - Lightweight HTTP routing
- **PostgreSQL 16 + sqlx** - Reliable data persistence
- **JWT + OAuth2** - Secure authentication (Google)
- **Swagger/OpenAPI** - API documentation
- **shopspring/decimal** - Precise financial calculations

### Frontend (Next.js)
- **Next.js 14** - React framework with App Router
- **TypeScript** - Type safety
- **Tailwind CSS** - Utility-first styling
- **shadcn/ui + Radix UI** - Accessible component library
- **Recharts** - Data visualization
- **TanStack Query** - Server state management
- **Zustand** - Client state management
- **next-intl** - Internationalization
- **React Hook Form + Zod** - Form handling & validation

### Admin Dashboard (Spring Boot)
- **Spring Boot 3.2** - Admin web application
- **Spring Security** - Authentication
- **Spring Data JPA** - Database access
- **Thymeleaf + Tailwind CSS** - Server-side rendering
- **Chart.js** - Dashboard visualizations

### Infrastructure
- **Docker & Docker Compose** - Containerization
- **Flyway** - Database migrations
- **Terraform** - Infrastructure as Code (DigitalOcean)
- **Ansible** - Server provisioning and configuration
- **Caddy** - Reverse proxy with automatic SSL

## 🚀 Quick Start

### Prerequisites
- **Go 1.24+**
- **Node.js 18+**
- **PostgreSQL 16+**
- **Docker & Docker Compose** (recommended)

### Option 1: Docker Compose (Recommended)

Start all services with a single command:

```bash
# Clone the repository
git clone <repository-url>
cd WealthPath

# Start all services (PostgreSQL, Flyway, Backend, Frontend)
docker-compose up -d

# Access the application
# - Frontend: http://localhost:3000
# - Backend API: http://localhost:8080
# - API Documentation: http://localhost:8080/swagger/
```

Services included:
- **PostgreSQL** (port 5432) - Database
- **Flyway** - Automatic database migrations
- **Go Backend** (port 8080) - REST API
- **Next.js Frontend** (port 3000) - Web application

### Option 2: Manual Setup

#### 1. Database Setup

```bash
# Create PostgreSQL database
createdb wealthpath

# Run Flyway migrations
cd migrations
docker build -t wealthpath-migrations .
docker run --rm \
  -e FLYWAY_URL=jdbc:postgresql://host.docker.internal:5432/wealthpath \
  -e FLYWAY_USER=postgres \
  -e FLYWAY_PASSWORD=postgres \
  wealthpath-migrations
```

#### 2. Backend Setup

```bash
cd backend

# Install dependencies
go mod download

# Set environment variables
export DATABASE_URL="postgres://postgres:postgres@localhost:5432/wealthpath?sslmode=disable"
export JWT_SECRET="your-secret-key-change-in-production"
export ALLOWED_ORIGINS="http://localhost:3000"
export FRONTEND_URL="http://localhost:3000"
export PORT="8080"

# Run the server
go run cmd/api/main.go

# Or build and run
make build
./bin/api
```

The API will be available at `http://localhost:8080`

#### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Set environment variables (create .env.local)
echo "NEXT_PUBLIC_API_URL=http://localhost:8080" > .env.local

# Run development server
npm run dev
```

The application will be available at `http://localhost:3000`

#### 4. Admin Dashboard (Optional)

```bash
cd admin

# Set environment variables
export DATABASE_URL=jdbc:postgresql://localhost:5432/wealthpath
export DB_USER=postgres
export DB_PASSWORD=postgres
export ADMIN_USERNAME=admin
export ADMIN_PASSWORD=admin123

# Run with Gradle
./gradlew bootRun
```

The admin dashboard will be available at `http://localhost:8081`

## 📁 Project Structure

```
WealthPath/
├── backend/                    # Go REST API
│   ├── cmd/api/               # Application entrypoint
│   ├── internal/              # Core application logic
│   │   ├── apperror/          # Custom error types
│   │   ├── config/            # Configuration management
│   │   ├── handler/           # HTTP handlers (API routes)
│   │   ├── logger/            # Structured logging
│   │   ├── model/             # Domain models
│   │   ├── repository/        # Database access layer
│   │   ├── scraper/           # Interest rate scraper
│   │   └── service/           # Business logic layer
│   ├── pkg/                   # Shared utilities
│   │   ├── currency/          # Currency formatting
│   │   └── datetime/          # Date utilities
│   ├── docs/                  # Swagger/OpenAPI documentation
│   ├── test/integration/      # Integration tests
│   ├── Dockerfile
│   ├── Makefile
│   └── go.mod
│
├── frontend/                   # Next.js Web Application
│   ├── src/
│   │   ├── app/               # Next.js App Router
│   │   │   ├── (auth)/        # Auth pages (login, register)
│   │   │   └── (dashboard)/   # Protected dashboard pages
│   │   ├── components/        # React components
│   │   │   ├── chat/          # AI chat component
│   │   │   ├── layout/        # Layout components
│   │   │   └── ui/            # shadcn/ui components
│   │   ├── hooks/             # Custom React hooks
│   │   ├── lib/               # Utilities & API client
│   │   ├── messages/          # i18n translation files
│   │   └── store/             # Zustand state stores
│   ├── e2e/                   # Playwright E2E tests
│   ├── public/                # Static assets
│   ├── Dockerfile
│   ├── package.json
│   └── playwright.config.ts
│
├── admin/                      # Spring Boot Admin Dashboard
│   ├── src/main/
│   │   ├── java/              # Java source code
│   │   └── resources/         # Templates & configuration
│   ├── build.gradle.kts       # Gradle build config
│   └── Dockerfile
│
├── migrations/                 # Flyway Database Migrations
│   ├── db/migration/          # Versioned SQL files
│   │   ├── V1__initial_schema.sql
│   │   ├── V2__oauth_support.sql
│   │   ├── V3__recurring_transactions.sql
│   │   ├── V7__create_interest_rates.sql
│   │   ├── V8__create_interest_rate_history.sql
│   │   └── V9__create_rate_subscriptions.sql
│   └── Dockerfile
│
├── terraform/                  # Infrastructure as Code
│   ├── main.tf                # Main Terraform configuration
│   ├── digitalocean.tf        # DigitalOcean resources
│   └── outputs.tf             # Output variables
│
├── ansible/                    # Configuration Management
│   ├── playbook.yml           # Main playbook
│   ├── roles/                 # Reusable roles
│   │   ├── docker/            # Docker installation
│   │   └── wealthpath/        # App deployment
│   ├── tasks/                 # Task definitions
│   └── inventory.yml          # Server inventory
│
├── scripts/                    # Utility Scripts
│   ├── backup-db.sh           # Database backup
│   ├── deploy.sh              # Deployment script
│   ├── k8s-setup.sh           # Kubernetes setup
│   └── pre-push.sh            # Git pre-push hook
│
├── docker-compose.yaml         # Development environment
├── docker-compose.prod.yaml    # Production deployment
├── Caddyfile                   # Caddy reverse proxy config
└── README.md
```

## 🔌 API Documentation

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login with email/password |
| GET | `/api/auth/google` | Initiate Google OAuth flow |
| GET | `/api/auth/google/callback` | Google OAuth callback |

### Dashboard
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/dashboard` | Current month overview |
| GET | `/api/dashboard/monthly/{year}/{month}` | Specific month data |

### Transactions
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/transactions` | List with filters & pagination |
| POST | `/api/transactions` | Create transaction |
| PUT | `/api/transactions/{id}` | Update transaction |
| DELETE | `/api/transactions/{id}` | Delete transaction |

### Budgets
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/budgets` | List budgets with spent amounts |
| POST | `/api/budgets` | Create budget |
| PUT | `/api/budgets/{id}` | Update budget |
| DELETE | `/api/budgets/{id}` | Delete budget |

### Savings Goals
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/savings-goals` | List all goals |
| POST | `/api/savings-goals` | Create goal |
| PUT | `/api/savings-goals/{id}` | Update goal |
| DELETE | `/api/savings-goals/{id}` | Delete goal |
| POST | `/api/savings-goals/{id}/contribute` | Add contribution |

### Debts
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/debts` | List all debts |
| POST | `/api/debts` | Create debt |
| PUT | `/api/debts/{id}` | Update debt |
| DELETE | `/api/debts/{id}` | Delete debt |
| POST | `/api/debts/{id}/payment` | Record payment |
| GET | `/api/debts/{id}/payoff-plan` | Get amortization schedule |
| GET | `/api/debts/calculator` | Interest calculator |

### Recurring Transactions
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/recurring` | List recurring transactions |
| POST | `/api/recurring` | Create recurring transaction |
| PUT | `/api/recurring/{id}` | Update recurring transaction |
| DELETE | `/api/recurring/{id}` | Delete recurring transaction |
| GET | `/api/recurring/upcoming` | Get upcoming bills |

### Interest Rates
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/rates` | Get current interest rates |

### AI Assistant
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/ai/chat` | Send message to AI financial assistant |

**Full API documentation available at:** `http://localhost:8080/swagger/` when running the backend.

## ⚙️ Environment Variables

### Backend (.env or environment)
| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `DATABASE_URL` | PostgreSQL connection string | `postgres://localhost:5432/wealthpath?sslmode=disable` | Yes |
| `JWT_SECRET` | Secret key for JWT signing | `dev-secret-change-in-production` | Yes |
| `PORT` | Backend server port | `8080` | No |
| `ALLOWED_ORIGINS` | CORS allowed origins | `http://localhost:3000` | Yes |
| `FRONTEND_URL` | Frontend URL for OAuth redirects | `http://localhost:3000` | Yes |
| `GOOGLE_CLIENT_ID` | Google OAuth client ID | - | For OAuth |
| `GOOGLE_CLIENT_SECRET` | Google OAuth client secret | - | For OAuth |
| `OPENAI_API_KEY` | OpenAI API key for AI assistant | - | For AI chat |

### Frontend (.env.local)
| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `NEXT_PUBLIC_API_URL` | Backend API URL | Uses Next.js proxy | No |

### Admin Dashboard (.env or environment)
| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `DATABASE_URL` | JDBC PostgreSQL connection string | `jdbc:postgresql://localhost:5432/wealthpath` | Yes |
| `DB_USER` | Database username | `postgres` | Yes |
| `DB_PASSWORD` | Database password | `postgres` | Yes |
| `ADMIN_USERNAME` | Admin login username | `admin` | Yes |
| `ADMIN_PASSWORD` | Admin login password | `admin123` | Yes |
| `PORT` | Admin server port | `8081` | No |

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all tests
make test

# Run with coverage
make coverage

# Run integration tests (requires Docker)
make test-integration

# Generate coverage report
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

### Frontend Tests

```bash
cd frontend

# Unit tests
npm test

# Watch mode
npm run test:watch

# Coverage report
npm run test:coverage

# E2E tests with Playwright
npm run test:e2e

# E2E with UI mode
npm run test:e2e:ui

# E2E headed mode (see browser)
npm run test:e2e:headed
```

Test coverage includes:
- ✅ Unit tests for handlers, services, repositories
- ✅ Integration tests with testcontainers
- ✅ E2E tests for critical user flows (auth, transactions, budgets, etc.)
- ✅ Component tests for UI elements

## 🚢 Deployment

### Production Deployment with Docker Compose

```bash
# Use production compose file
docker-compose -f docker-compose.prod.yaml up -d

# Or use the deployment script
./scripts/deploy.sh
```

### Infrastructure Deployment

#### Option 1: Terraform (DigitalOcean)

```bash
cd terraform

# Initialize Terraform
terraform init

# Review changes
terraform plan

# Deploy infrastructure
terraform apply

# Get outputs (server IP, etc.)
terraform output
```

#### Option 2: Ansible Configuration

```bash
cd ansible

# Configure server inventory
cp inventory.yml.example inventory.yml
# Edit inventory.yml with your server details

# Run full deployment playbook
ansible-playbook -i inventory.yml playbook.yml

# Run specific tasks
ansible-playbook -i inventory.yml tasks/deploy.yml
```

### Database Backup

```bash
# Backup database
./scripts/backup-db.sh

# Backups are saved with timestamp
# Example: wealthpath_backup_20251220_123456.sql.gz
```

## 📊 Data Models

### Core Entities

#### User
- `id` (UUID)
- `email`, `password_hash`, `name`
- `currency` - Default currency (USD, EUR, etc.)
- `oauth_provider`, `oauth_id` - For Google OAuth
- `avatar_url`
- Timestamps: `created_at`, `updated_at`

#### Transaction
- `id` (UUID)
- `user_id` (FK)
- `type` - `income` or `expense`
- `amount` (DECIMAL)
- `currency`
- `category` - Categorization
- `description`
- `date`
- Timestamps: `created_at`, `updated_at`

#### Budget
- `id` (UUID)
- `user_id` (FK)
- `category`
- `amount` (DECIMAL) - Spending limit
- `period` - `monthly`, `yearly`
- Date range: `start_date`, `end_date`
- Timestamps: `created_at`, `updated_at`

#### SavingsGoal
- `id` (UUID)
- `user_id` (FK)
- `name`, `description`
- `target_amount`, `current_amount` (DECIMAL)
- `target_date`
- `color`, `icon` - UI customization
- Timestamps: `created_at`, `updated_at`

#### Debt
- `id` (UUID)
- `user_id` (FK)
- `name`, `type` - mortgage, auto_loan, credit_card, student_loan, personal_loan, other
- `original_amount`, `current_balance` (DECIMAL)
- `interest_rate` (DECIMAL) - Annual percentage
- `minimum_payment` (DECIMAL)
- `payment_due_day` - Day of month
- Date: `start_date`
- Timestamps: `created_at`, `updated_at`

#### RecurringTransaction
- `id` (UUID)
- `user_id` (FK)
- `type` - `income` or `expense`
- `amount` (DECIMAL)
- `category`, `description`
- `frequency` - `daily`, `weekly`, `biweekly`, `monthly`, `yearly`
- `next_occurrence` - Next scheduled date
- `is_active` - Enable/disable
- Timestamps: `created_at`, `updated_at`

### Categories

**Income Categories:**
Salary, Freelance, Business, Investments, Rental, Gifts, Refunds, Other

**Expense Categories:**
Housing, Transportation, Food & Dining, Utilities, Healthcare, Insurance, Entertainment, Shopping, Personal Care, Education, Travel, Gifts & Donations, Investments, Debt Payments, Other

## 📈 Roadmap

### Completed ✅
- [x] Core transaction tracking
- [x] Budget management with progress
- [x] Savings goals with contributions
- [x] Debt management with amortization
- [x] Recurring transactions automation
- [x] Google OAuth authentication
- [x] Internationalization (i18n)
- [x] AI financial assistant (OpenAI)
- [x] Admin dashboard (Spring Boot)
- [x] Interest rate tracking
- [x] Financial calculators
- [x] Comprehensive testing (unit, integration, E2E)

### In Progress 🔄
- [ ] Reports & Analytics with charts
- [ ] Mobile responsive PWA
- [ ] Notification system (email/push)

### Planned 📋
- [ ] Data import/export (CSV, PDF)
- [ ] Bank connection (Plaid integration)
- [ ] Multi-currency support
- [ ] Investment tracking (stocks, crypto)
- [ ] Shared budgets (family accounts)
- [ ] Receipt scanning (OCR)
- [ ] Dark mode
- [ ] 2FA authentication

See [Feature Backlog](docs/features/BACKLOG.md) for detailed roadmap.

## 📝 License

MIT License - See LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📚 Documentation

- **API Documentation**: Available at `/swagger/` endpoint when running backend
- **Project Overview**: [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) - Comprehensive project documentation
- **Backend Guide**: [backend/README.md](backend/README.md) - Backend-specific documentation
- **Admin Guide**: [admin/README.md](admin/README.md) - Admin dashboard documentation
- **Feature Backlog**: [docs/features/BACKLOG.md](docs/features/BACKLOG.md) - Feature roadmap
- **Deployment Guide**: [terraform/README.md](terraform/README.md) - Infrastructure setup
- **Scripts Documentation**: [scripts/README.md](scripts/README.md) - Utility scripts guide

## 💡 Development Tips

### Backend Development
```bash
cd backend

# Format code
make fmt

# Run linter
make lint

# Generate Swagger docs
make swagger

# Build for CI/CD
make build-ci
```

### Frontend Development
```bash
cd frontend

# Generate API types from Swagger
npm run generate:api

# Lint code
npm run lint

# Build for production
npm run build
```

### Database Management
```bash
# Connect to PostgreSQL
psql -d wealthpath

# View migration status (when using Flyway container)
docker-compose run flyway info

# Apply migrations
docker-compose run flyway migrate
```

## 🆘 Support & Issues

If you encounter any issues or have questions:

1. Check the [documentation](#-documentation)
2. Review existing [issues](../../issues)
3. Create a new issue with detailed information

---

**Built with ❤️ for better financial management**




