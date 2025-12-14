# WealthPath - Project Overview

> A full-stack personal finance management application for tracking income, expenses, budgets, savings goals, and debt.

![WealthPath](https://img.shields.io/badge/WealthPath-Finance-8B5CF6)
![Go](https://img.shields.io/badge/Backend-Go%201.24-00ADD8)
![Next.js](https://img.shields.io/badge/Frontend-Next.js%2014-000000)
![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-336791)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Project Structure](#project-structure)
- [Data Models](#data-models)
- [API Endpoints](#api-endpoints)
- [Frontend Pages](#frontend-pages)
- [Infrastructure](#infrastructure)
- [Development Setup](#development-setup)
- [Testing](#testing)
- [Deployment](#deployment)
- [Roadmap](#roadmap)

---

## 🎯 Overview

**WealthPath** is a comprehensive personal finance tracker designed to help users:

- **Track** daily income and expenses with categorization
- **Budget** spending by category with real-time progress tracking
- **Save** towards financial goals with contribution tracking
- **Manage** debt with amortization schedules and payoff planning
- **Automate** recurring transactions (salary, bills, subscriptions)
- **Analyze** financial health through dashboards and visualizations

The application follows a modern microservices-ready architecture with a clear separation between frontend, backend, and admin services.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                           Client Layer                               │
├─────────────────────────────────────────────────────────────────────┤
│   Next.js 14 Frontend          │    Spring Boot Admin Dashboard     │
│   (React + TypeScript)         │    (Thymeleaf + Tailwind)          │
│   Port: 3000                   │    Port: 8081                      │
└────────────────┬───────────────┴────────────────┬────────────────────┘
                 │                                 │
                 ▼                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           API Layer                                  │
├─────────────────────────────────────────────────────────────────────┤
│                     Go Backend (Chi Router)                          │
│                     - REST API                                       │
│                     - JWT Authentication                             │
│                     - OAuth2 (Google)                                │
│                     - OpenAI Integration                             │
│                     Port: 8080                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         Data Layer                                   │
├─────────────────────────────────────────────────────────────────────┤
│                    PostgreSQL 16 Database                            │
│                    - Flyway Migrations                               │
│                    Port: 5432                                        │
└─────────────────────────────────────────────────────────────────────┘
```

### Design Principles

- **Clean Architecture**: Handlers → Services → Repositories → Models
- **Domain-Driven Design**: Clear separation of business logic
- **Interface-Driven Development**: Dependency injection for testability
- **API-First**: RESTful API with Swagger documentation

---

## 🛠️ Tech Stack

### Backend (Go)

| Component | Technology | Purpose |
|-----------|------------|---------|
| Language | Go 1.24 | High-performance backend |
| Router | Chi v5 | Lightweight HTTP routing |
| Database | PostgreSQL + sqlx | Reliable data persistence |
| Auth | JWT + OAuth2 | Secure authentication |
| Decimal | shopspring/decimal | Precise financial calculations |
| Docs | Swagger/OpenAPI | API documentation |
| Testing | testify + sqlmock + testcontainers | Comprehensive testing |

### Frontend (Next.js)

| Component | Technology | Purpose |
|-----------|------------|---------|
| Framework | Next.js 14 | React with App Router |
| Language | TypeScript | Type safety |
| Styling | Tailwind CSS | Utility-first styling |
| Components | shadcn/ui + Radix | Accessible UI components |
| Charts | Recharts | Data visualization |
| State | Zustand | Client state management |
| Data Fetching | TanStack Query | Server state management |
| Forms | React Hook Form + Zod | Form handling & validation |
| i18n | next-intl | Internationalization |
| Icons | Lucide React | Beautiful icons |

### Admin Dashboard (Spring Boot)

| Component | Technology | Purpose |
|-----------|------------|---------|
| Framework | Spring Boot 3.2 | Admin web application |
| Security | Spring Security | Authentication |
| ORM | Spring Data JPA | Database access |
| Templates | Thymeleaf | Server-side rendering |
| Charts | Chart.js | Dashboard visualizations |

### Infrastructure

| Component | Technology | Purpose |
|-----------|------------|---------|
| Containers | Docker & Docker Compose | Development & deployment |
| Migrations | Flyway | Database versioning |
| IaC | Terraform | AWS infrastructure |
| Config Mgmt | Ansible | Server provisioning |
| Reverse Proxy | Caddy / Nginx | SSL & routing |
| CI/CD | GitHub Actions | Automation |

---

## ✨ Features

### Core Financial Features

| Feature | Description | Status |
|---------|-------------|--------|
| **Transaction Tracking** | Log income/expenses with categories, descriptions, dates | ✅ Complete |
| **Budget Management** | Set spending limits by category with progress tracking | ✅ Complete |
| **Savings Goals** | Create goals, track contributions, visualize progress | ✅ Complete |
| **Dashboard** | Monthly overview with charts and insights | ✅ Complete |
| **Recurring Transactions** | Automated bills, salary, subscriptions | ✅ Complete |

### Debt Management

| Feature | Description | Status |
|---------|-------------|--------|
| **Debt Tracking** | Mortgages, auto loans, credit cards, student loans | ✅ Complete |
| **Interest Rates** | Track and display current interest rates | ✅ Complete |
| **Payoff Planning** | Amortization schedules and payoff projections | ✅ Complete |
| **Payment History** | Track payments with principal/interest breakdown | ✅ Complete |

### Calculators

| Feature | Description | Status |
|---------|-------------|--------|
| **Loan Calculator** | Calculate monthly payments & total interest | ✅ Complete |
| **Savings Calculator** | Project savings with compound interest | ✅ Complete |

### User Experience

| Feature | Description | Status |
|---------|-------------|--------|
| **Authentication** | Email/password + Google OAuth | ✅ Complete |
| **Internationalization** | Multi-language support (i18n) | ✅ Complete |
| **AI Assistant** | Financial chat powered by OpenAI | ✅ Complete |
| **Responsive Design** | Mobile-friendly interface | 🔄 Partial |
| **Dark Mode** | Theme toggle | 📋 Planned |

### Admin Features

| Feature | Description | Status |
|---------|-------------|--------|
| **User Management** | List, search, view, delete users | ✅ Complete |
| **Statistics Dashboard** | Platform analytics and charts | ✅ Complete |
| **Health Monitoring** | System health endpoints | ✅ Complete |

---

## 📁 Project Structure

```
WealthPath/
├── backend/                    # Go REST API
│   ├── cmd/api/               # Application entrypoint
│   │   └── main.go            # Main entry, server setup
│   ├── internal/              # Core application logic
│   │   ├── apperror/          # Custom error types
│   │   ├── config/            # Configuration loading
│   │   ├── handler/           # HTTP handlers (controllers)
│   │   ├── logger/            # Structured logging
│   │   ├── mocks/             # Test mocks
│   │   ├── model/             # Domain models
│   │   ├── repository/        # Database access layer
│   │   ├── scraper/           # Interest rate scraper
│   │   └── service/           # Business logic layer
│   ├── migrations/            # SQL migration files
│   ├── pkg/                   # Shared utilities
│   │   ├── currency/          # Currency formatting
│   │   └── datetime/          # Date utilities
│   ├── docs/                  # Swagger documentation
│   ├── test/integration/      # Integration tests
│   ├── Dockerfile             # Container build
│   ├── Makefile               # Build commands
│   └── go.mod                 # Go dependencies
│
├── frontend/                   # Next.js Web Application
│   ├── src/
│   │   ├── app/               # Next.js App Router
│   │   │   ├── (auth)/        # Auth pages (login, register)
│   │   │   ├── (dashboard)/   # Protected dashboard pages
│   │   │   └── [locale]/      # Internationalized routes
│   │   ├── components/        # React components
│   │   │   ├── chat/          # AI chat component
│   │   │   ├── layout/        # Layout components
│   │   │   ├── seo/           # SEO components
│   │   │   └── ui/            # shadcn/ui components
│   │   ├── hooks/             # Custom React hooks
│   │   ├── lib/               # Utilities & API client
│   │   ├── messages/          # i18n translation files
│   │   └── store/             # Zustand state stores
│   ├── e2e/                   # Playwright E2E tests
│   ├── public/                # Static assets
│   ├── Dockerfile             # Container build
│   └── package.json           # Node dependencies
│
├── admin/                      # Spring Boot Admin Dashboard
│   ├── src/main/
│   │   ├── java/              # Java source code
│   │   └── resources/         # Templates & config
│   ├── build.gradle.kts       # Gradle build config
│   └── Dockerfile             # Container build
│
├── migrations/                 # Flyway migrations
│   └── db/migration/          # Versioned SQL files
│
├── terraform/                  # Infrastructure as Code
│   ├── main.tf                # Main configuration
│   ├── aws.tf                 # AWS resources
│   └── outputs.tf             # Output variables
│
├── ansible/                    # Server Configuration
│   ├── playbook.yml           # Main playbook
│   ├── roles/                 # Reusable roles
│   └── inventory.yml          # Server inventory
│
├── scripts/                    # Utility scripts
│   ├── backup-db.sh           # Database backup
│   ├── deploy.sh              # Deployment script
│   └── k8s-setup.sh           # Kubernetes setup
│
├── docker-compose.yaml         # Development environment
├── docker-compose.prod.yaml    # Production deployment
├── Caddyfile                   # Caddy reverse proxy
└── README.md                   # Project documentation
```

---

## 📊 Data Models

### Core Entities

```
┌──────────────┐     ┌─────────────────┐     ┌──────────────────┐
│     User     │     │   Transaction   │     │      Budget      │
├──────────────┤     ├─────────────────┤     ├──────────────────┤
│ id           │◄────│ user_id         │     │ id               │
│ email        │     │ id              │     │ user_id          │
│ password_hash│     │ type            │     │ category         │
│ name         │     │ amount          │     │ amount           │
│ currency     │     │ currency        │     │ period           │
│ oauth_*      │     │ category        │     │ start_date       │
│ avatar_url   │     │ description     │     │ end_date         │
└──────────────┘     │ date            │     └──────────────────┘
       │             └─────────────────┘              │
       │                                               │
       ▼                                               ▼
┌──────────────────┐    ┌─────────────────┐    ┌──────────────────┐
│   SavingsGoal    │    │      Debt       │    │ RecurringTxn     │
├──────────────────┤    ├─────────────────┤    ├──────────────────┤
│ id               │    │ id              │    │ id               │
│ user_id          │    │ user_id         │    │ user_id          │
│ name             │    │ name            │    │ type             │
│ target_amount    │    │ type            │    │ amount           │
│ current_amount   │    │ original_amount │    │ category         │
│ target_date      │    │ current_balance │    │ frequency        │
│ color, icon      │    │ interest_rate   │    │ next_occurrence  │
└──────────────────┘    │ minimum_payment │    │ is_active        │
                        └─────────────────┘    └──────────────────┘
```

### Transaction Types
- `income` - Money received
- `expense` - Money spent

### Debt Types
- `mortgage`, `auto_loan`, `student_loan`, `credit_card`, `personal_loan`, `other`

### Recurring Frequencies
- `daily`, `weekly`, `biweekly`, `monthly`, `yearly`

### Expense Categories
Housing, Transportation, Food & Dining, Utilities, Healthcare, Insurance, Entertainment, Shopping, Personal Care, Education, Travel, Gifts & Donations, Investments, Debt Payments, Other

### Income Categories
Salary, Freelance, Business, Investments, Rental, Gifts, Refunds, Other

---

## 🔌 API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login with credentials |
| GET | `/api/auth/google` | Initiate Google OAuth |
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

### AI Chat
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/ai/chat` | Send message to AI assistant |

### Interest Rates
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/rates` | Get current interest rates |

---

## 📱 Frontend Pages

| Route | Page | Description |
|-------|------|-------------|
| `/` | Landing | Marketing page |
| `/login` | Login | User authentication |
| `/register` | Register | User registration |
| `/dashboard` | Dashboard | Monthly financial overview |
| `/transactions` | Transactions | Transaction list & management |
| `/budgets` | Budgets | Budget management |
| `/savings` | Savings | Savings goals |
| `/debts` | Debts | Debt management |
| `/recurring` | Recurring | Recurring transactions |
| `/calculator` | Calculator | Financial calculators |
| `/rates` | Rates | Interest rate display |
| `/settings` | Settings | User preferences |

---

## 🏗️ Infrastructure

### Docker Compose (Development)

```bash
# Start all services
docker-compose up -d

# Services started:
# - postgres:5432   - PostgreSQL database
# - flyway          - Database migrations
# - backend:8080    - Go API
# - frontend:3000   - Next.js app
```

### Deployment Options

| Platform | Complexity | Cost | Best For |
|----------|------------|------|----------|
| **Railway** | Easy | $5+/mo | Quick deployment |
| **Render** | Easy | $7+/mo | Simple hosting |
| **Fly.io** | Medium | $2+/mo | Edge deployment |
| **DigitalOcean** | Medium | $12+/mo | Full control |
| **AWS (Terraform)** | Complex | Variable | Enterprise scale |

### Terraform Resources (AWS)

- EC2 instances
- RDS PostgreSQL
- VPC networking
- Security groups
- IAM roles

### Ansible Roles

- Docker installation
- WealthPath deployment
- Database setup
- SSL/TLS configuration

---

## 🚀 Development Setup

### Prerequisites

- Go 1.22+
- Node.js 18+
- PostgreSQL 14+
- Docker & Docker Compose (optional)

### Quick Start with Docker

```bash
# Clone repository
git clone https://github.com/your-org/WealthPath.git
cd WealthPath

# Start all services
docker-compose up -d

# Access:
# - Frontend: http://localhost:3000
# - Backend API: http://localhost:8080
# - API Docs: http://localhost:8080/swagger/
```

### Manual Setup

```bash
# 1. Start PostgreSQL and create database
createdb wealthpath

# 2. Run migrations
cd migrations/db/migration
psql -d wealthpath -f V1__initial_schema.sql

# 3. Start backend
cd backend
export DATABASE_URL="postgres://localhost:5432/wealthpath?sslmode=disable"
export JWT_SECRET="your-secret-key"
go run cmd/api/main.go

# 4. Start frontend
cd frontend
npm install
npm run dev
```

---

## 🧪 Testing

### Backend Testing

```bash
cd backend

# Run all tests
make test

# Run with coverage
make coverage

# Run integration tests (requires Docker)
make test-integration
```

### Frontend Testing

```bash
cd frontend

# Unit tests
npm test

# With coverage
npm run test:coverage

# E2E tests (Playwright)
npm run test:e2e

# E2E with UI
npm run test:e2e:ui
```

### Test Coverage

- Unit tests for handlers, services, repositories
- Integration tests with testcontainers
- E2E tests for critical user flows
- Component tests for UI elements

---

## 📈 Roadmap

### Completed ✅

- [x] Core transaction tracking
- [x] Budget management
- [x] Savings goals
- [x] Debt management with amortization
- [x] Recurring transactions
- [x] OAuth authentication (Google)
- [x] Internationalization (i18n)
- [x] AI financial assistant
- [x] Admin dashboard

### In Progress 🔄

- [ ] Reports & Analytics (charts, spending analysis)
- [ ] Mobile responsive PWA
- [ ] Notification system

### Planned 📋

- [ ] Bank connection (Plaid integration)
- [ ] Multi-currency support
- [ ] Data import/export (CSV, PDF)
- [ ] Investment tracking
- [ ] Shared budgets (family accounts)
- [ ] Dark mode
- [ ] 2FA authentication
- [ ] Receipt scanning (OCR)

---

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📞 Support

- **Documentation**: [README.md](README.md)
- **Deployment Guide**: [DEPLOYMENT.md](DEPLOYMENT.md)
- **Feature Backlog**: [docs/features/BACKLOG.md](docs/features/BACKLOG.md)

