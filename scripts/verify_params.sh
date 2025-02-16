#!/bin/bash

echo "YUL Blockchain Parameter Verification"
echo "==================================="
echo "Verifying all parameters match BSV v1.1.0..."

# Function to check RPC command results
check_rpc() {
    local cmd=$1
    shift
    echo "Executing: $cmd $@"
    result=$(bitcoin-cli -conf=/data/bitcoin.conf "$cmd" "$@")
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to execute bitcoin-cli $cmd $@"
        exit 1
    fi
    echo "$result"
    echo "-----------------------------------"
}

# Function to verify config parameter
verify_param() {
    local param=$1
    local expected=$2
    local value=$(grep "^$param=" /data/bitcoin.conf | cut -d'=' -f2)
    
    if [ "$value" != "$expected" ]; then
        echo "ERROR: Parameter $param mismatch"
        echo "Expected: $expected"
        echo "Found: $value"
        return 1
    fi
    echo "✓ $param = $expected"
    return 0
}

echo "1. Checking Network Configuration..."
check_rpc getnetworkinfo
verify_param "port" "8333"
verify_param "rpcport" "8332"
verify_param "listen" "1"
verify_param "server" "1"

echo "2. Checking Mining Configuration..."
check_rpc getmininginfo
verify_param "minminingtxfee" "0.00000050"
verify_param "blockmaxsize" "512000000"

echo "3. Checking Blockchain Configuration..."
check_rpc getblockchaininfo
verify_param "excessiveblocksize" "2000000000"
verify_param "maxstackmemoryusageconsensus" "200000000"

echo "4. Checking Performance Settings..."
verify_param "dbcache" "16384"
verify_param "maxmempool" "2000"
verify_param "maxsigcachesize" "260"
verify_param "maxscriptcachesize" "260"

echo "5. Checking Security Settings..."
verify_param "rpcthreads" "24"
verify_param "rpcworkqueue" "600"
verify_param "maxconnections" "125"
verify_param "banscore" "100"
verify_param "bantime" "86400"

# Final verification message
if [ $? -eq 0 ]; then
    echo "==================================="
    echo "✓ All parameters verified successfully"
    echo "✓ Configuration matches BSV v1.1.0"
    exit 0
else
    echo "==================================="
    echo "✗ Parameter verification failed"
    echo "✗ See errors above"
    exit 1
fi
