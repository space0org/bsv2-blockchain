#!/bin/bash

echo "Testing YUL blockchain monitoring..."

# Check if nodes are running
if ! docker ps | grep -q yul-node1; then
    echo "Starting YUL blockchain nodes..."
    docker-compose up -d
    sleep 30
fi

# Test dashboard connectivity
echo "Testing dashboard connectivity..."
curl -s http://localhost:3010 > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Dashboard is not accessible"
    exit 1
fi

# Verify monitoring endpoints
echo "Verifying monitoring endpoints..."

# Test node metrics
echo "Testing node metrics..."
NODE_INFO=$(curl -s http://localhost:3010/api/node/info)
if [ -z "$NODE_INFO" ]; then
    echo "❌ Node metrics not available"
    exit 1
fi

# Test mempool monitoring
echo "Testing mempool monitoring..."
MEMPOOL_INFO=$(curl -s http://localhost:3010/api/mempool/info)
if [ -z "$MEMPOOL_INFO" ]; then
    echo "❌ Mempool monitoring not available"
    exit 1
fi

# Test block monitoring
echo "Testing block monitoring..."
BLOCK_INFO=$(curl -s http://localhost:3010/api/blocks/info)
if [ -z "$BLOCK_INFO" ]; then
    echo "❌ Block monitoring not available"
    exit 1
fi

# Verify refresh interval
echo "Verifying refresh interval..."
CONFIG_FILE="config/dashboard/config.json"
REFRESH_INTERVAL=$(grep "interval" "$CONFIG_FILE" | cut -d':' -f2 | tr -d ' ,')
if [ "$REFRESH_INTERVAL" != "10000" ]; then
    echo "❌ Incorrect refresh interval"
    exit 1
fi

echo "✅ Monitoring test completed successfully"
echo "- Dashboard accessible on port 3010"
echo "- Node metrics available"
echo "- Mempool monitoring active"
echo "- Block monitoring active"
echo "- Refresh interval correct"
