# Development Guide

This document explains how to set up your local development environment for gh-ost.

## Prerequisites

- **Go 1.23+** – [Install Go](https://golang.org/doc/install)
- **MySQL 5.7+ or 8.0+** – for integration tests
- **Docker & Docker Compose** – for running replica-based tests
- **golangci-lint** – for linting (optional, also runs in CI)

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/scutuatua-crypto/gh-ost.git
cd gh-ost
```

### 2. Install dependencies

```bash
go mod download
```

### 3. Build the binary

```bash
make build
# Binary is placed in ./bin/gh-ost
```

### 4. Run unit tests

```bash
make test
```

### 5. Run linting

Install golangci-lint:

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

Then run:

```bash
make lint
```

## Using the Makefile

The repository ships with a `Makefile` for common tasks:

| Target         | Description                                  |
|----------------|----------------------------------------------|
| `make build`   | Compile the gh-ost binary into `./bin/`      |
| `make test`    | Run unit tests with coverage                 |
| `make lint`    | Run golangci-lint static analysis            |
| `make fmt`     | Format all Go source files with `gofmt -s`   |
| `make vet`     | Run `go vet` on all packages                 |
| `make clean`   | Remove build artifacts                       |
| `make deps`    | Download and tidy Go modules                 |
| `make cibuild` | Full CI build (format, build, test)          |

## Running Replica Integration Tests

Integration tests spin up a MySQL primary + replica using Docker Compose.

### Using Docker Compose directly

```bash
# Start the test environment
docker compose up -d

# Run the tests
bash test.sh

# Tear down
docker compose down
```

### Using the helper script

```bash
script/docker-gh-ost-replica-tests
```

## Code Structure

```
.
├── go/
│   ├── base/        – Core types, context, configuration
│   ├── binlog/      – Binlog reader / DML event handling
│   ├── cmd/         – Main entry point
│   ├── logic/       – Migration orchestration (migrator, applier, inspector, throttler…)
│   ├── mysql/       – MySQL binlog utilities and instance inspection
│   └── sql/         – SQL parsing and query building
├── localtests/      – Shell-based local integration tests
├── resources/       – Packaging resources (systemd units, etc.)
├── script/          – CI and development helper scripts
└── vendor/          – Vendored Go dependencies
```

## Code Style

- Follow the official [Effective Go](https://golang.org/doc/effective_go) guidelines.
- Run `make fmt` before committing to ensure consistent formatting.
- All new code must pass `go vet` and `golangci-lint`.

## Pre-commit Hooks (optional)

Install [pre-commit](https://pre-commit.com/) and set up the hooks:

```bash
pip install pre-commit
pre-commit install
```

The hooks will automatically check formatting and run `go vet` on every commit.

## Submitting Changes

Please read [CONTRIBUTING.md](.github/CONTRIBUTING.md) before opening a pull request.
