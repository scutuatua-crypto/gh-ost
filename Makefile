.PHONY: all build test lint fmt vet clean deps help

BINARY_NAME=gh-ost
BUILD_DIR=bin
GO_FILES=$(shell find go -name '*.go' -not -path '*/vendor/*')
VERSION=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
COMMIT=$(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
LDFLAGS=-ldflags "-X main.AppVersion=$(VERSION) -X main.GitCommit=$(COMMIT)"

all: build

## build: Build the gh-ost binary
build:
	mkdir -p $(BUILD_DIR)
	go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) ./go/cmd/gh-ost/main.go

## test: Run unit tests
test:
	go test -v -covermode=atomic -coverprofile=coverage.out ./go/...

## test-cover: Run tests and open coverage report
test-cover: test
	go tool cover -html=coverage.out

## lint: Run golangci-lint
lint:
	golangci-lint run ./...

## fmt: Format code with gofmt
fmt:
	gofmt -s -w go/

## vet: Run go vet
vet:
	go vet ./go/...

## clean: Remove build artifacts
clean:
	rm -rf $(BUILD_DIR)/ .gopath/ coverage.out

## deps: Download dependencies
deps:
	go mod download
	go mod tidy

## vendor: Vendor dependencies
vendor:
	go mod vendor

## cibuild: Run the full CI build (format check, build, test)
cibuild:
	script/cibuild

## docker-test: Run replica tests in Docker
docker-test:
	script/docker-gh-ost-replica-tests

## help: Show this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@sed -n 's/^## //p' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/^/  /'
