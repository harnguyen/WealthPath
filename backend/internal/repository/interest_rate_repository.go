package repository

import (
	"context"
	"fmt"

	"github.com/jmoiron/sqlx"
	"github.com/wealthpath/backend/internal/model"
)

// InterestRateRepository defines the interface for interest rate data access
type InterestRateRepository interface {
	List(ctx context.Context, productType string, termMonths *int, bankCode string) ([]model.InterestRate, error)
	GetBestRates(ctx context.Context, productType string, termMonths int, limit int) ([]model.InterestRate, error)
	Upsert(ctx context.Context, rate *model.InterestRate) error
	DeleteOldRates(ctx context.Context, daysOld int) error
}

type interestRateRepository struct {
	db *sqlx.DB
}

// NewInterestRateRepository creates a new interest rate repository
func NewInterestRateRepository(db *sqlx.DB) InterestRateRepository {
	return &interestRateRepository{db: db}
}

// List returns interest rates with optional filters
func (r *interestRateRepository) List(ctx context.Context, productType string, termMonths *int, bankCode string) ([]model.InterestRate, error) {
	query := `
		SELECT id, bank_code, bank_name, bank_logo, product_type, term_months, term_label, 
		       rate, min_amount, max_amount, currency, effective_date, scraped_at, created_at, updated_at
		FROM interest_rates
		WHERE 1=1
	`
	args := []interface{}{}
	argNum := 1

	if productType != "" {
		query += fmt.Sprintf(" AND product_type = $%d", argNum)
		args = append(args, productType)
		argNum++
	}

	if termMonths != nil {
		query += fmt.Sprintf(" AND term_months = $%d", argNum)
		args = append(args, *termMonths)
		argNum++
	}

	if bankCode != "" {
		query += fmt.Sprintf(" AND bank_code = $%d", argNum)
		args = append(args, bankCode)
		argNum++
	}

	query += " ORDER BY term_months ASC, rate DESC"

	var rates []model.InterestRate
	if err := r.db.SelectContext(ctx, &rates, query, args...); err != nil {
		return nil, fmt.Errorf("list interest rates: %w", err)
	}

	return rates, nil
}

// GetBestRates returns the top rates for a given product type and term
func (r *interestRateRepository) GetBestRates(ctx context.Context, productType string, termMonths int, limit int) ([]model.InterestRate, error) {
	query := `
		SELECT id, bank_code, bank_name, bank_logo, product_type, term_months, term_label,
		       rate, min_amount, max_amount, currency, effective_date, scraped_at, created_at, updated_at
		FROM interest_rates
		WHERE product_type = $1 AND term_months = $2
		ORDER BY rate DESC
		LIMIT $3
	`

	var rates []model.InterestRate
	if err := r.db.SelectContext(ctx, &rates, query, productType, termMonths, limit); err != nil {
		return nil, fmt.Errorf("get best rates: %w", err)
	}

	return rates, nil
}

// Upsert creates or updates an interest rate
func (r *interestRateRepository) Upsert(ctx context.Context, rate *model.InterestRate) error {
	query := `
		INSERT INTO interest_rates (
			bank_code, bank_name, bank_logo, product_type, term_months, term_label,
			rate, min_amount, max_amount, currency, effective_date, scraped_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
		ON CONFLICT (bank_code, product_type, term_months) 
		DO UPDATE SET
			bank_name = EXCLUDED.bank_name,
			bank_logo = EXCLUDED.bank_logo,
			term_label = EXCLUDED.term_label,
			rate = EXCLUDED.rate,
			min_amount = EXCLUDED.min_amount,
			max_amount = EXCLUDED.max_amount,
			effective_date = EXCLUDED.effective_date,
			scraped_at = EXCLUDED.scraped_at,
			updated_at = CURRENT_TIMESTAMP
		RETURNING id
	`

	return r.db.QueryRowContext(ctx, query,
		rate.BankCode, rate.BankName, rate.BankLogo, rate.ProductType, rate.TermMonths, rate.TermLabel,
		rate.Rate, rate.MinAmount, rate.MaxAmount, rate.Currency, rate.EffectiveDate, rate.ScrapedAt,
	).Scan(&rate.ID)
}

// DeleteOldRates removes rates older than specified days
func (r *interestRateRepository) DeleteOldRates(ctx context.Context, daysOld int) error {
	query := `DELETE FROM interest_rates WHERE scraped_at < NOW() - INTERVAL '%d days'`
	_, err := r.db.ExecContext(ctx, fmt.Sprintf(query, daysOld))
	if err != nil {
		return fmt.Errorf("delete old rates: %w", err)
	}
	return nil
}

