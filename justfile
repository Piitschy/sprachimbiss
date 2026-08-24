# justfile for Sprachimbiss Docker operations

# Variables
IMAGE_NAME := "ghcr.io/piitschy/sprachimbiss"
TAG := env_var_or_default("TAG", "latest")
FULL_IMAGE_NAME := IMAGE_NAME + ":" + TAG

# Default target - show help
default:
    @echo 'Usage: just [command]'
    @echo ''
    @echo 'Available commands:'
    @echo '  build           Build the Docker image'
    @echo '  run             Run the container locally'
    @echo '  login           Login to GitHub Container Registry'
    @echo '  push            Build and push to GitHub Container Registry'
    @echo '  deploy          Alias for push command'
    @echo '  pull            Pull the latest image from GitHub Container Registry'
    @echo '  run-tagged TAG  Run with specific tag (use: just run-tagged v1.0.0)'
    @echo '  dev             Run development container with mounted volumes'
    @echo '  clean           Remove Docker images and containers'
    @echo '  stop-dev        Stop development container'
    @echo '  info            Show Docker image information'
    @echo '  install         Install dependencies with Bun'
    @echo '  build-local     Build project locally'
    @echo '  dev-local       Start development server locally'
    @echo '  version         Show current version'

# Docker build
build:
    @echo "Building Docker image {{FULL_IMAGE_NAME}}..."
    docker build -t {{FULL_IMAGE_NAME}} .
    @echo "Build completed: {{FULL_IMAGE_NAME}}"

# Docker run locally
run:
    @echo "Running {{FULL_IMAGE_NAME}} locally..."
    docker run -p 4321:4321 --rm {{FULL_IMAGE_NAME}}

# Login to GitHub Container Registry
login:
    #!/usr/bin/env bash
    echo "Logging in to GitHub Container Registry..."
    read -p "Enter GitHub username: " username
    read -s -p "Enter GitHub personal access token: " token
    echo $token | docker login ghcr.io -u $username --password-stdin

# Push to GitHub Container Registry
push: login build
    @echo "Pushing {{FULL_IMAGE_NAME}} to GitHub Container Registry..."
    docker push {{FULL_IMAGE_NAME}}
    @echo "Push completed: {{FULL_IMAGE_NAME}}"

# Build and push (shortcut)
deploy: push

# Pull latest image
pull:
    @echo "Pulling {{FULL_IMAGE_NAME}} from GitHub Container Registry..."
    docker pull {{FULL_IMAGE_NAME}}

# Run with custom tag
run-tagged tag:
    #!/usr/bin/env bash
    if [ -z "{{tag}}" ]; then
        echo "Please specify a tag: just run-tagged v1.0.0"
        exit 1
    fi
    TAG="{{tag}}" just build
    docker run -p 4321:4321 --rm {{IMAGE_NAME}}:{{tag}}

# Development build (with mounted volumes)
dev:
    @echo "Running development container with hot reload..."
    docker run -p 4321:4321 \
        -v {{justfile_directory()}}:/app \
        -v /app/node_modules \
        --rm \
        --name sprachimbiss-dev \
        oven/bun:1.1.30-alpine \
        sh -c "cd /app && bun install && bun run dev --host"

# Clean up
clean:
    @echo "Cleaning up Docker resources..."
    docker system prune -f
    docker rmi {{IMAGE_NAME}}:latest 2>/dev/null || true
    @echo "Cleanup completed"

# Stop development container
stop-dev:
    @echo "Stopping development container..."
    docker stop sprachimbiss-dev 2>/dev/null || true
    docker rm sprachimbiss-dev 2>/dev/null || true

# Show image info
info:
    #!/usr/bin/env bash
    echo "Image: {{IMAGE_NAME}}"
    echo "Tag: {{TAG}}"
    echo "Full name: {{FULL_IMAGE_NAME}}"
    if docker images {{IMAGE_NAME}}:{{TAG}} | grep -q {{TAG}}; then
        echo "Image exists locally"
        docker images {{IMAGE_NAME}}:{{TAG}}
    else
        echo "Image not found locally"
    fi

# Install dependencies locally with Bun
install:
    @echo "Installing dependencies with Bun..."
    bun install

# Build project locally
build-local:
    @echo "Building project locally..."
    bun run build

# Start development server locally
dev-local:
    @echo "Starting development server locally..."
    bun run dev

# Version management
version:
    @echo "Docker Image: {{IMAGE_NAME}}:{{TAG}}"
    @echo "Current working directory: {{justfile_directory()}}"
    @echo "Node version in container:"
    docker run --rm oven/bun:1.1.30-alpine bun --version
