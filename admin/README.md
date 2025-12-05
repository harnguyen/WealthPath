# WealthPath Admin Service

Spring Boot 3.x admin dashboard for WealthPath.

## Features

- 📊 Dashboard with user/transaction statistics
- 👥 User management (list, search, view, delete)
- 🔐 Static credentials authentication
- 📈 Charts for expenses by category and users by currency

## Quick Start

### Prerequisites
- Java 17+
- Gradle 8.x
- PostgreSQL (same database as Go backend)

### Run Locally

```bash
# Set environment variables
export DATABASE_URL=jdbc:postgresql://localhost:5432/wealthpath
export DB_USER=postgres
export DB_PASSWORD=postgres
export ADMIN_USERNAME=admin
export ADMIN_PASSWORD=admin123

# Run with Gradle
./gradlew bootRun

# Or build and run JAR
./gradlew bootJar
java -jar build/libs/admin.jar
```

### Run with Docker

```bash
docker build -t wealthpath-admin .
docker run -p 8081:8081 \
  -e DATABASE_URL=jdbc:postgresql://host.docker.internal:5432/wealthpath \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  -e ADMIN_USERNAME=admin \
  -e ADMIN_PASSWORD=secret \
  wealthpath-admin
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 8081 | Server port |
| `DATABASE_URL` | jdbc:postgresql://localhost:5432/wealthpath | PostgreSQL JDBC URL |
| `DB_USER` | postgres | Database username |
| `DB_PASSWORD` | postgres | Database password |
| `ADMIN_USERNAME` | admin | Admin login username |
| `ADMIN_PASSWORD` | admin123 | Admin login password |

## Endpoints

- `/login` - Admin login page
- `/dashboard` - Statistics dashboard
- `/users` - User management
- `/users/{id}` - User details
- `/actuator/health` - Health check (no auth required)

## Tech Stack

- **Framework**: Spring Boot 3.2
- **Security**: Spring Security
- **Database**: Spring Data JPA + PostgreSQL
- **Templates**: Thymeleaf + Tailwind CSS
- **Charts**: Chart.js

