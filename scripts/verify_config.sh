#!/bin/bash
echo "Verifying YUL blockchain configuration matches BSV v1.1.0..."

CONFIG_FILE="config/bitcoin.conf"

# Required parameters and their values
declare -A PARAMS=(
  ["dbcache"]="16384"
  ["maxmempool"]="2000"
  ["maxsigcachesize"]="260"
  ["maxscriptcachesize"]="260"
  ["excessiveblocksize"]="2000000000"
  ["maxstackmemoryusageconsensus"]="200000000"
  ["minminingtxfee"]="0.00000050"
  ["blockmaxsize"]="512000000"
)

for param in "${!PARAMS[@]}"; do
  value=$(grep "^$param=" "$CONFIG_FILE" | cut -d'=' -f2)
  if [ "$value" != "${PARAMS[$param]}" ]; then
    echo "ERROR: Parameter $param does not match BSV v1.1.0 value"
    echo "Expected: ${PARAMS[$param]}"
    echo "Found: $value"
    exit 1
  fi
done

echo "Configuration verification complete. All parameters match BSV v1.1.0"
