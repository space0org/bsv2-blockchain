#!/bin/bash

# Start all nodes
for i in {1..3}; do
    echo "Starting node $i..."
    bash /bsv2/deployment/scripts/init_node.sh $i
done

# Wait for nodes to start
sleep 10

# Get node addresses
for i in {1..3}; do
    NODE_DIR="/data/bsv2/node${i}"
    NODE_ADDR=$(/bsv2/src/bitcoin-cli -datadir=${NODE_DIR} getnetworkinfo | grep addr | head -n 1)
    echo "Node $i address: ${NODE_ADDR}"
done

# Connect nodes
for i in {2..3}; do
    NODE1_ADDR=$(/bsv2/src/bitcoin-cli -datadir=/data/bsv2/node1 getnetworkinfo | grep addr | head -n 1)
    /bsv2/src/bitcoin-cli -datadir=/data/bsv2/node${i} addnode ${NODE1_ADDR} add
done

echo "BSV2 network initialized and connected"
