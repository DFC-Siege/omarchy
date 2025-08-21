#!/bin/bash

# SearXNG Installation Script for Arch Linux
# This script installs SearXNG with Docker and sets up auto-start

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
        echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
        echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
        echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
        echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
        command -v "$1" >/dev/null 2>&1
}

# Function to check if Docker is running
is_docker_running() {
        docker info >/dev/null 2>&1
}

# Function to install Docker on Arch
install_docker() {
        print_info "Installing Docker on Arch Linux..."

        # Update package database
        sudo pacman -Sy

        # Install Docker and Docker Compose
        sudo pacman -S --needed --noconfirm docker docker-compose

        # Start and enable Docker
        sudo systemctl start docker
        sudo systemctl enable docker

        # Add current user to docker group
        sudo usermod -aG docker $USER
        print_warning "You may need to log out and log back in for Docker group changes to take effect."
}

# Function to create Docker Compose file
create_docker_compose() {
        print_info "Creating Docker Compose configuration..."

        # Check if docker-compose.yml already exists
        if [ -f "docker-compose.yml" ]; then
                print_warning "Docker Compose file already exists. Skipping creation to preserve your configuration."
                return 0
        fi

        cat >docker-compose.yml <<'EOF'
version: '3.7'

services:
  searxng:
    container_name: searxng
    image: searxng/searxng:latest
    restart: unless-stopped
    ports:
      - "8888:8080"
    volumes:
      - ./searxng:/etc/searxng:rw
    environment:
      - SEARXNG_BASE_URL=http://localhost:8888/
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - SETGID
      - SETUID
    logging:
      driver: "json-file"
      options:
        max-size: "1m"
        max-file: "5"

  redis:
    container_name: redis
    image: "redis:alpine"
    command: redis-server --save "" --appendonly "no"
    restart: unless-stopped
    tmpfs:
      - /var/lib/redis
    cap_drop:
      - ALL
    cap_add:
      - SETGID
      - SETUID
      - DAC_OVERRIDE
EOF
        print_success "Created new Docker Compose configuration."
}

# Function to create SearXNG settings
create_searxng_settings() {
        print_info "Creating SearXNG settings..."

        # Create directory with proper permissions
        mkdir -p searxng
        sudo chown -R $USER:$USER searxng
        chmod -R 755 searxng

        # Check if settings file already exists
        if [ -f "searxng/settings.yml" ]; then
                print_warning "Settings file already exists. Skipping settings creation to preserve your configuration."
                return 0
        fi

        # Generate a random secret key
        SECRET_KEY=$(openssl rand -hex 32)

        cat >searxng/settings.yml <<EOF
use_default_settings: true
server:
  secret_key: "${SECRET_KEY}"
  limiter: true
  image_proxy: true
redis:
  url: redis://redis:6379/0
EOF

        # Ensure proper permissions for the settings file
        chmod 644 searxng/settings.yml
        print_success "Created new settings file with secret key."
}

# Function to create systemd service for auto-start
create_systemd_service() {
        print_info "Creating systemd service for auto-start..."

        sudo tee /etc/systemd/system/searxng.service >/dev/null <<EOF
[Unit]
Description=SearXNG
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$SEARXNG_DIR
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

        # Reload systemd and enable service
        sudo systemctl daemon-reload
        sudo systemctl enable searxng.service
}

# Main installation function
install_searxng() {
        print_info "Starting SearXNG installation..."

        # Check and install Docker if needed
        if ! command_exists docker; then
                install_docker
        else
                print_info "Docker is already installed."
        fi

        # Wait for Docker to be ready
        print_info "Waiting for Docker to be ready..."
        for i in {1..30}; do
                if is_docker_running; then
                        break
                fi
                if [ $i -eq 30 ]; then
                        print_error "Docker is not running. Please start Docker and try again."
                        exit 1
                fi
                sleep 2
        done

        # Create SearXNG directory
        SEARXNG_DIR="$HOME/searxng"
        print_info "Creating SearXNG directory at $SEARXNG_DIR..."
        mkdir -p "$SEARXNG_DIR"
        cd "$SEARXNG_DIR"

        # Create configuration files
        create_docker_compose
        create_searxng_settings

        # Pull and start SearXNG
        print_info "Pulling SearXNG Docker images..."
        docker-compose pull

        print_info "Starting SearXNG..."
        docker-compose up -d

        # Create systemd service
        create_systemd_service

        print_success "SearXNG installation completed!"
        print_info "SearXNG is now running at: http://localhost:8888"
        print_info "SearXNG will auto-start on system boot."
        print_info ""
        print_info "Useful commands:"
        print_info "  Start:   docker-compose -f $SEARXNG_DIR/docker-compose.yml up -d"
        print_info "  Stop:    docker-compose -f $SEARXNG_DIR/docker-compose.yml down"
        print_info "  Restart: docker-compose -f $SEARXNG_DIR/docker-compose.yml restart"
        print_info "  Logs:    docker-compose -f $SEARXNG_DIR/docker-compose.yml logs -f"
}

# Main script execution
main() {
        echo "========================================="
        echo "       SearXNG Installation Script      "
        echo "         for Arch Linux                 "
        echo "========================================="
        echo ""

        print_warning "This script will install SearXNG with Docker and set up auto-start."
        print_warning "SearXNG will be accessible at http://localhost:8888"
        echo ""

        read -p "Do you want to proceed with the installation? (y/N): " -n 1 -r
        echo ""

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled."
                exit 0
        fi

        install_searxng
}

# Run main function
main
