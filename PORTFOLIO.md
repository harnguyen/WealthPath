# 💰 WealthPath

## Personal Finance Management Platform

<p align="center">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-brightgreen" alt="Status" />
  <img src="https://img.shields.io/badge/Go-1.24-00ADD8?logo=go" alt="Go" />
  <img src="https://img.shields.io/badge/Next.js-14-black?logo=next.js" alt="Next.js" />
  <img src="https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker" alt="Docker" />
</p>

---

## 🎯 Project Summary

**WealthPath** is a full-stack personal finance management application that helps users take control of their financial health. Built with modern technologies and best practices, it demonstrates proficiency in full-stack development, clean architecture, and DevOps practices.

| | |
|---|---|
| **Project Type** | Full-Stack Web Application |
| **Role** | Full-Stack Developer |
| **Duration** | Ongoing Development |
| **Team Size** | Solo / Small Team |
| **Status** | Production Ready |

---

## 🌟 Key Highlights

### 🏗️ Clean Architecture
- Implemented layered architecture (Handlers → Services → Repositories)
- Dependency injection for testability
- Interface-driven design patterns
- Clear separation of concerns

### 🔐 Security First
- JWT-based authentication with refresh tokens
- OAuth 2.0 integration (Google Sign-In)
- Password hashing with bcrypt
- CORS configuration for secure API access

### 💼 Production-Grade Infrastructure
- Docker containerization for all services
- Infrastructure as Code with Terraform (AWS)
- Server automation with Ansible
- Multiple deployment options (Railway, Render, Fly.io, DigitalOcean)

### 🧪 Comprehensive Testing
- Unit tests with table-driven patterns
- Integration tests with testcontainers
- End-to-end tests with Playwright
- 80%+ code coverage

---

## ✨ Features Showcase

### 📊 Financial Dashboard
> Real-time overview of financial health with interactive charts

- Monthly income vs. expenses visualization
- Budget progress tracking
- Recent transactions feed
- Upcoming bills widget
- Net cash flow calculation

### 💳 Transaction Management
> Complete income and expense tracking system

- Categorized transactions (15+ expense categories, 8+ income categories)
- Date-range filtering and search
- Bulk operations support
- Transaction history with pagination

### 📈 Budget Management
> Set and track spending limits by category

- Monthly/weekly/yearly budget periods
- Real-time spent vs. budget progress bars
- Overspending alerts
- Category-wise breakdown

### 🎯 Savings Goals
> Visual goal tracking with contribution history

- Custom goal creation with icons and colors
- Progress visualization
- Target date tracking
- Contribution history

### 💰 Debt Management
> Comprehensive debt tracking with payoff planning

- Support for mortgages, auto loans, credit cards, student loans
- Interest rate tracking
- Amortization schedule generation
- Payment history with principal/interest breakdown
- Payoff date projections

### 🔄 Recurring Transactions
> Automate regular income and expenses

- Multiple frequencies (daily, weekly, biweekly, monthly, yearly)
- Automatic transaction generation
- Pause/resume functionality
- Upcoming bills preview

### 🤖 AI Financial Assistant
> OpenAI-powered chat for financial guidance

- Natural language financial queries
- Context-aware responses
- Budget recommendations
- Spending insights

### 🌐 Internationalization
> Multi-language support for global users

- Dynamic language switching
- Localized date and currency formatting
- Translation-ready architecture

---

## 🛠️ Technical Stack

### Backend

```
┌─────────────────────────────────────────────────┐
│  Go 1.24 + Chi Router                           │
│  ├── JWT Authentication                         │
│  ├── OAuth 2.0 (Google)                         │
│  ├── RESTful API Design                         │
│  ├── Swagger/OpenAPI Documentation              │
│  └── Structured Logging                         │
├─────────────────────────────────────────────────┤
│  PostgreSQL 16 + sqlx                           │
│  ├── Flyway Migrations                          │
│  ├── Decimal precision for financials           │
│  └── Connection pooling                         │
└─────────────────────────────────────────────────┘
```

### Frontend

```
┌─────────────────────────────────────────────────┐
│  Next.js 14 (App Router)                        │
│  ├── TypeScript                                 │
│  ├── React Server Components                    │
│  └── Static/Dynamic Rendering                   │
├─────────────────────────────────────────────────┤
│  UI/UX                                          │
│  ├── Tailwind CSS                               │
│  ├── shadcn/ui + Radix Primitives               │
│  ├── Recharts for data visualization            │
│  └── Lucide React icons                         │
├─────────────────────────────────────────────────┤
│  State Management                               │
│  ├── TanStack Query (server state)              │
│  ├── Zustand (client state)                     │
│  └── React Hook Form + Zod (forms)              │
└─────────────────────────────────────────────────┘
```

### DevOps & Infrastructure

```
┌─────────────────────────────────────────────────┐
│  Containerization                               │
│  ├── Docker multi-stage builds                  │
│  ├── Docker Compose (dev & prod)                │
│  └── Optimized image sizes                      │
├─────────────────────────────────────────────────┤
│  Infrastructure as Code                         │
│  ├── Terraform (AWS: EC2, RDS, VPC)             │
│  ├── Ansible (server provisioning)              │
│  └── Caddy/Nginx reverse proxy                  │
├─────────────────────────────────────────────────┤
│  CI/CD                                          │
│  ├── GitHub Actions                             │
│  ├── Automated testing                          │
│  └── Database backup scripts                    │
└─────────────────────────────────────────────────┘
```

---

## 🏛️ Architecture

```
                    ┌──────────────────────────────────┐
                    │           Load Balancer          │
                    │         (Caddy / Nginx)          │
                    └──────────────┬───────────────────┘
                                   │
            ┌──────────────────────┼──────────────────────┐
            │                      │                      │
            ▼                      ▼                      ▼
┌───────────────────┐  ┌───────────────────┐  ┌───────────────────┐
│    Frontend       │  │     Backend       │  │      Admin        │
│   (Next.js 14)    │  │      (Go)         │  │  (Spring Boot)    │
│                   │  │                   │  │                   │
│  • React 18       │  │  • Chi Router     │  │  • Thymeleaf      │
│  • TypeScript     │  │  • JWT Auth       │  │  • Chart.js       │
│  • Tailwind       │  │  • OAuth 2.0      │  │  • User Mgmt      │
│  • TanStack Query │  │  • OpenAI API     │  │                   │
│                   │  │                   │  │                   │
│  Port: 3000       │  │  Port: 8080       │  │  Port: 8081       │
└─────────┬─────────┘  └─────────┬─────────┘  └─────────┬─────────┘
          │                      │                      │
          │                      ▼                      │
          │            ┌───────────────────┐            │
          └───────────►│   PostgreSQL 16   │◄───────────┘
                       │                   │
                       │  • Flyway         │
                       │  • Financial Data │
                       │  • User Accounts  │
                       │                   │
                       │  Port: 5432       │
                       └───────────────────┘
```

---

## 📊 Code Metrics

| Metric | Value |
|--------|-------|
| **Backend Lines of Code** | ~5,000+ |
| **Frontend Lines of Code** | ~8,000+ |
| **API Endpoints** | 30+ |
| **Database Tables** | 8+ |
| **Test Files** | 25+ |
| **Languages** | Go, TypeScript, Java, SQL |

---

## 🎓 Skills Demonstrated

### Backend Development
- ✅ RESTful API design and implementation
- ✅ Authentication & Authorization (JWT, OAuth)
- ✅ Database design and optimization
- ✅ Clean Architecture principles
- ✅ Error handling and logging
- ✅ API documentation (Swagger/OpenAPI)

### Frontend Development
- ✅ Modern React with hooks and context
- ✅ TypeScript for type safety
- ✅ Responsive UI design
- ✅ State management patterns
- ✅ Form handling and validation
- ✅ Data visualization with charts

### DevOps & Infrastructure
- ✅ Docker containerization
- ✅ Infrastructure as Code (Terraform)
- ✅ Configuration management (Ansible)
- ✅ CI/CD pipeline setup
- ✅ Database migrations
- ✅ Multiple cloud deployment strategies

### Software Engineering
- ✅ Test-Driven Development
- ✅ Clean Code practices
- ✅ Git version control
- ✅ Documentation
- ✅ Agile methodologies

---

## 🚀 Getting Started

### Quick Start (Docker)

```bash
# Clone the repository
git clone https://github.com/your-username/WealthPath.git
cd WealthPath

# Start all services
docker-compose up -d

# Access the application
# Frontend: http://localhost:3000
# Backend API: http://localhost:8080
# API Docs: http://localhost:8080/swagger/
```

### Development Setup

```bash
# Backend
cd backend
go mod tidy
go run cmd/api/main.go

# Frontend
cd frontend
npm install
npm run dev
```

---

## 📸 Screenshots

> *Add screenshots of your application here*

| Dashboard | Transactions |
|-----------|--------------|
| ![Dashboard](screenshots/dashboard.png) | ![Transactions](screenshots/transactions.png) |

| Budgets | Savings Goals |
|---------|---------------|
| ![Budgets](screenshots/budgets.png) | ![Savings](screenshots/savings.png) |

| Debt Management | Calculators |
|-----------------|-------------|
| ![Debts](screenshots/debts.png) | ![Calculator](screenshots/calculator.png) |

---

## 🔗 Links

| Resource | Link |
|----------|------|
| **Live Demo** | [Coming Soon] |
| **GitHub Repository** | [github.com/your-username/WealthPath](https://github.com/your-username/WealthPath) |
| **API Documentation** | [Swagger UI](http://localhost:8080/swagger/) |
| **Detailed README** | [README.md](README.md) |
| **Deployment Guide** | [DEPLOYMENT.md](DEPLOYMENT.md) |

---

## 📧 Contact

**Your Name**  
Full-Stack Developer

- 📧 Email: your.email@example.com
- 💼 LinkedIn: [linkedin.com/in/yourprofile](https://linkedin.com/in/yourprofile)
- 🐙 GitHub: [github.com/your-username](https://github.com/your-username)
- 🌐 Portfolio: [yourportfolio.com](https://yourportfolio.com)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <strong>Built with ❤️ using Go, Next.js, and PostgreSQL</strong>
</p>

