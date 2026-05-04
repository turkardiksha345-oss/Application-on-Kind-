#!/bin/bash

# Student Registration App - One-Click Setup

echo "🚀 Student Registration Application - Setup Script"
echo "=================================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo "Please install Docker from https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "✅ Docker is installed"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed!"
    echo "Please install Docker Desktop which includes Docker Compose"
    exit 1
fi

echo "✅ Docker Compose is installed"

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "❌ Docker daemon is not running!"
    echo "Please start Docker Desktop"
    exit 1
fi

echo "✅ Docker daemon is running"
echo ""

# Build and start services
echo "📦 Building Docker images..."
docker-compose build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "🔄 Starting services..."
    docker-compose up -d
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Services started successfully!"
        echo ""
        echo "🎉 Application is running!"
        echo ""
        echo "📍 Access points:"
        echo "   Frontend:  http://localhost"
        echo "   Backend:   http://localhost:5000"
        echo "   Database:  localhost:3306"
        echo ""
        echo "📋 Useful commands:"
        echo "   View logs:      docker-compose logs -f"
        echo "   Stop services:  docker-compose down"
        echo "   Restart:        docker-compose restart"
        echo ""
        echo "📚 Documentation:"
        echo "   Quick start:  See QUICKSTART.md"
        echo "   Full guide:   See SETUP.md"
        echo "   API docs:     See README.md"
    else
        echo "❌ Failed to start services"
        exit 1
    fi
else
    echo "❌ Build failed"
    exit 1
fi
