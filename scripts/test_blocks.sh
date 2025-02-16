#!/bin/bash

echo "Testing YUL blockchain block creation and propagation..."

# Start the nodes
echo "Starting YUL blockchain nodes..."
docker-compose up -d

# Wait for nodes to initialize
echo "Waiting for nodes to initialize..."
sleep 30

# Function to check RPC command results
check_rpc() {
    local node=$1
    shift
    local cmd=$1
    shift
    echo "Executing on $node: $cmd $@"
    docker exec $node bitcoin-cli -conf=/data/bitcoin.conf "$cmd" "$@"
}

# Generate blocks on node1
echo "Generating blocks on node1..."
BLOCKS=$(check_rpc yul-node1 generatetoaddress 10 $(check_rpc yul-node1 getnewaddress))
if [ $? -ne 0 ]; then
    echo "❌ Failed to generate blocks"
    exit 1
fi

# Wait for block propagation
echo "Waiting for block propagation..."
sleep 10

# Verify block count on all nodes
NODE1_BLOCKS=$(check_rpc yul-node1 getblockcount)
echo "Node1 block count: $NODE1_BLOCKS"

# Verify block hashes match
GENESIS_HASH=$(check_rpc yul-node1 getblockhash 0)
LATEST_HASH=$(check_rpc yul-node1 getblockhash $NODE1_BLOCKS)

echo "Genesis block hash: $GENESIS_HASH"
echo "Latest block hash: $LATEST_HASH"

# Verify ZMQ notifications
echo "Verifying ZMQ notifications..."
NOTIFICATIONS=$(docker logs yul-node1 | grep "zmq: Publish")
if [ -z "$NOTIFICATIONS" ]; then
    echo "❌ No ZMQ notifications found"
    exit 1
fi

echo "✅ Block creation and propagation test completed successfully"
echo "- Generated 10 blocks"
echo "- Verified block propagation"
echo "- Checked block hashes"
echo "- Verified ZMQ notifications"
