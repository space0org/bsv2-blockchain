#!/bin/bash

echo "YUL Blockchain Deployment"
echo "========================"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker is not running"
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose >/dev/null 2>&1; then
    echo "ERROR: docker-compose is not installed"
    exit 1
fi

# Check configuration files
if [ ! -f "config/bitcoin.conf" ]; then
    echo "Creating bitcoin.conf from template..."
    cp config/templates/bitcoin.conf.template config/bitcoin.conf
fi

if [ ! -f ".env" ]; then
    echo "Creating .env from template..."
    cp .env.template .env
    echo "Please edit .env file with your settings"
    exit 1
fi

echo "Starting YUL blockchain nodes..."
docker-compose up -d

echo "Waiting for nodes to initialize..."
sleep 30

echo "Verifying node parameters..."
docker exec yul-node1 /bin/bash /scripts/verify_params.sh
if [ $? -ne 0 ]; then
    echo "ERROR: Node verification failed"
    echo "Check logs with: docker logs yul-node1"
    exit 1
fi

echo "========================"
echo "✓ YUL blockchain deployed successfully"
echo "✓ Dashboard: http://localhost:3010"
echo "✓ MAPI: http://localhost:9014"
echo "✓ RPC: http://localhost:8332"
