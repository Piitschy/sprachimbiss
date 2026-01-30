# Makefile for Sprachimbiss Docker operations

# Variables
IMAGE_NAME = ghcr.io/piitschy/sprachimbiss
TAG ?= latest
FULL_IMAGE_NAME = $(IMAGE_NAME):$(TAG)

# Default target
.PHONY: help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Docker build
.PHONY: build
build: ## Build the Docker image
	@echo "Building Docker image $(FULL_IMAGE_NAME)..."
	docker build -t $(FULL_IMAGE_NAME) .
	@echo "Build completed: $(FULL_IMAGE_NAME)"

# Docker run locally
.PHONY: run
run: ## Run the container locally
	@echo "Running $(FULL_IMAGE_NAME) locally..."
	docker run -p 4321:4321 --rm $(FULL_IMAGE_NAME)

# Login to GitHub Container Registry
.PHONY: login
login: ## Login to GitHub Container Registry
	@echo "Logging in to GitHub Container Registry..."
	@read -p "Enter GitHub username: " username && \
	read -s -p "Enter GitHub personal access token: " token && \
	echo $$token | docker login ghcr.io -u $$username --password-stdin

# Push to GitHub Container Registry
.PHONY: push
push: login build ## Build and push to GitHub Container Registry
	@echo "Pushing $(FULL_IMAGE_NAME) to GitHub Container Registry..."
	docker push $(FULL_IMAGE_NAME)
	@echo "Push completed: $(FULL_IMAGE_NAME)"

# Build and push (shortcut)
.PHONY: deploy
deploy: ## Alias for push target
	$(MAKE) push

# Pull latest image
.PHONY: pull
pull: ## Pull the latest image from GitHub Container Registry
	@echo "Pulling $(FULL_IMAGE_NAME) from GitHub Container Registry..."
	docker pull $(FULL_IMAGE_NAME)

# Run with custom tag
.PHONY: run-tagged
run-tagged: ## Run with specific tag (use: make run-tagged TAG=v1.0.0)
	@if [ -z "$(TAG)" ]; then \
		echo "Please specify a tag: make run-tagged TAG=v1.0.0"; \
		exit 1; \
	fi
	$(MAKE) build
	docker run -p 4321:4321 --rm $(FULL_IMAGE_NAME)

# Development build (with mounted volumes)
.PHONY: dev
dev: ## Run development container with mounted volumes
	@echo "Running development container with hot reload..."
	docker run -p 4321:4321 \
		-v $(PWD):/app \
		-v /app/node_modules \
		--rm \
		--name sprachimbiss-dev \
		oven/bun:1.1.30-alpine \
		sh -c "cd /app && bun install && bun run dev --host"

# Clean up
.PHONY: clean
clean: ## Remove Docker images and containers
	@echo "Cleaning up Docker resources..."
	docker system prune -f
	docker rmi $(IMAGE_NAME):latest 2>/dev/null || true
	@echo "Cleanup completed"

# Stop development container
.PHONY: stop-dev
stop-dev: ## Stop development container
	@echo "Stopping development container..."
	docker stop sprachimbiss-dev 2>/dev/null || true
	docker rm sprachimbiss-dev 2>/dev/null || true

# Show image info
.PHONY: info
info: ## Show Docker image information
	@echo "Image: $(IMAGE_NAME)"
	@echo "Tag: $(TAG)"
	@echo "Full name: $(FULL_IMAGE_NAME)"
	@if docker images $(IMAGE_NAME):$(TAG) | grep -q $(TAG); then \
		echo "Image exists locally"; \
		docker images $(IMAGE_NAME):$(TAG); \
	else \
		echo "Image not found locally"; \
	fi

# Install dependencies locally with Bun
.PHONY: install
install: ## Install dependencies with Bun
	@echo "Installing dependencies with Bun..."
	bun install

# Build project locally
.PHONY: build-local
build-local: ## Build project locally
	@echo "Building project locally..."
	bun run build

# Start development server locally
.PHONY: dev-local
dev-local: ## Start development server locally
	@echo "Starting development server locally..."
	bun run dev

# Version management
.PHONY: version
version: ## Show current version
	@echo "Docker Image: $(IMAGE_NAME):$(TAG)"
	@echo "Current working directory: $(PWD)"
	@echo "Node version in container:"
	@docker run --rm oven/bun:1.1.30-alpine bun --version