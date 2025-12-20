# WealthPath Backend

Go-based backend service for the WealthPath personal finance management application.

## Development

### Prerequisites

- Go 1.24+
- PostgreSQL
- Make

### Quick Start

```bash
# Install dependencies
make deps

# Run tests
make test

# Build binary
make build

# Run locally
make run
```

## Build Issues in CI/CD Agents

### Problem

When building in CI/CD agents, you may encounter permission errors like:

```
go: github.com/wealthpath/backend/bin: open /Users/.../Library/Caches/go-build/...: operation not permitted
```

This occurs because Go tries to write to cache directories that aren't accessible in restricted agent environments.

### Solutions

#### Option 1: Use the build-ci Target (Recommended)

```bash
make build-ci
```

This target explicitly sets cache directories to writable locations (`/tmp`).

#### Option 2: Source the Environment Setup Script

```bash
source setup-build-env.sh
make build
```

#### Option 3: Set Environment Variables Manually

```bash
export GOCACHE=/tmp/go-cache
export GOMODCACHE=/tmp/go-mod
export GOTMPDIR=/tmp/go-build
make build
```

#### Option 4: Update Your CI/CD Pipeline

For GitHub Actions:

```yaml
- name: Setup Go Build Environment
  run: |
    mkdir -p /tmp/go-cache /tmp/go-mod
    echo "GOCACHE=/tmp/go-cache" >> $GITHUB_ENV
    echo "GOMODCACHE=/tmp/go-mod" >> $GITHUB_ENV
    echo "GOTMPDIR=/tmp/go-build" >> $GITHUB_ENV

- name: Build
  run: make build
```

For GitLab CI:

```yaml
variables:
  GOCACHE: /tmp/go-cache
  GOMODCACHE: /tmp/go-mod
  GOTMPDIR: /tmp/go-build

before_script:
  - mkdir -p /tmp/go-cache /tmp/go-mod /tmp/go-build
```

## Available Make Targets

- `make run` - Run the application in development mode
- `make build` - Build the production binary (with cache env vars)
- `make build-ci` - Build for CI/CD with explicit cache setup
- `make test` - Run all tests
- `make deps` - Download and tidy dependencies
- `make fmt` - Format code
- `make lint` - Run linter
- `make swagger` - Generate Swagger documentation

## Docker Build

The Dockerfile is configured to handle cache permissions automatically:

```bash
docker build -t wealthpath-backend .
```

## Project Structure

```
backend/
├── cmd/
│   └── api/           # Application entrypoint
├── internal/
│   ├── config/        # Configuration management
│   ├── handler/       # HTTP handlers
│   ├── model/         # Domain models
│   ├── repository/    # Data access layer
│   └── service/       # Business logic
├── pkg/               # Public utilities
└── test/
    └── integration/   # Integration tests
```

## Testing

```bash
# Run all tests
make test

# Run with coverage
go test -cover ./...

# Run integration tests
go test ./test/integration/...
```

## Environment Variables

See `.env.example` for required environment variables.

Key variables:
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - Secret for JWT token generation
- `PORT` - Server port (default: 8080)

