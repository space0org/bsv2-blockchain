#!/bin/bash

echo "Testing YUL blockchain parameters against BSV v1.1.0..."

# Required BSV v1.1.0 parameters
declare -A BSV_PARAMS=(
    ["port"]="8333"
    ["rpcport"]="8332"
    ["dbcache"]="16384"
    ["maxmempool"]="2000"
    ["maxsigcachesize"]="260"
    ["maxscriptcachesize"]="260"
    ["excessiveblocksize"]="2000000000"
    ["maxstackmemoryusageconsensus"]="200000000"
    ["minminingtxfee"]="0.00000050"
    ["blockmaxsize"]="512000000"
    ["maxconnections"]="125"
    ["banscore"]="100"
    ["bantime"]="86400"
    ["rpcthreads"]="24"
    ["rpcworkqueue"]="600"
)

CONFIG_FILE="config/bitcoin.conf"
ERRORS=0

echo "Verifying parameters in $CONFIG_FILE..."
for param in "${!BSV_PARAMS[@]}"; do
    value=$(grep "^$param=" "$CONFIG_FILE" | cut -d'=' -f2)
    if [ "$value" != "${BSV_PARAMS[$param]}" ]; then
        echo "❌ ERROR: Parameter $param mismatch"
        echo "   Expected: ${BSV_PARAMS[$param]}"
        echo "   Found: $value"
        ERRORS=$((ERRORS + 1))
    else
        echo "✓ $param = $value (matches BSV v1.1.0)"
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "✅ All parameters match BSV v1.1.0 exactly"
    exit 0
else
    echo "❌ Found $ERRORS parameter mismatches"
    exit 1
fi
