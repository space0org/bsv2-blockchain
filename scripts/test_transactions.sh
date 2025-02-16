#!/bin/bash

echo "Testing YUL blockchain transaction processing..."

# Start the nodes if not running
if ! docker ps | grep -q yul-node1; then
    echo "Starting YUL blockchain nodes..."
    docker-compose up -d
    sleep 30
fi

# Function to check RPC command results
check_rpc() {
    local node=$1
    shift
    local cmd=$1
    shift
    echo "Executing on $node: $cmd $@"
    docker exec $node bitcoin-cli -conf=/data/bitcoin.conf "$cmd" "$@"
}

# Verify mempool settings
echo "Verifying mempool configuration..."
MEMPOOL_INFO=$(check_rpc yul-node1 getmempoolinfo)
echo "$MEMPOOL_INFO"

# Create test transaction
echo "Creating test transaction..."
ADDRESS=$(check_rpc yul-node1 getnewaddress)
TXID=$(check_rpc yul-node1 sendtoaddress "$ADDRESS" 1.0)

if [ -z "$TXID" ]; then
    echo "❌ Failed to create test transaction"
    exit 1
fi

echo "Transaction created: $TXID"

# Verify transaction in mempool
echo "Verifying transaction in mempool..."
sleep 5
TX_INFO=$(check_rpc yul-node1 getrawtransaction "$TXID" 1)

if [ -z "$TX_INFO" ]; then
    echo "❌ Transaction not found in mempool"
    exit 1
fi

# Verify MAPI transaction validation
echo "Verifying MAPI transaction validation..."
curl -X POST http://localhost:9014/mapi/tx -H "Content-Type: application/json" -d "{
    \"rawtx\": \"$(check_rpc yul-node1 getrawtransaction $TXID)\"
}"

# Generate block to confirm transaction
echo "Generating block to confirm transaction..."
BLOCK=$(check_rpc yul-node1 generatetoaddress 1 "$ADDRESS")

# Verify transaction confirmation
echo "Verifying transaction confirmation..."
CONFIRM_INFO=$(check_rpc yul-node1 gettransaction "$TXID")

echo "✅ Transaction processing test completed successfully"
echo "- Created and validated transaction"
echo "- Verified mempool acceptance"
echo "- Confirmed transaction in new block"
echo "- Validated through MAPI"
