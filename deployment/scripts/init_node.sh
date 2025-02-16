#!/bin/bash

NODE_NUMBER=$1
NODE_DIR="/data/bsv2/node${NODE_NUMBER}"

# Create node directory
mkdir -p ${NODE_DIR}

# Copy node configuration
cp /bsv2/config/nodes/node${NODE_NUMBER}.conf ${NODE_DIR}/bitcoin.conf

# Initialize node
/bsv2/src/bitcoind -datadir=${NODE_DIR} -daemon

# Wait for node to start
sleep 5

# Generate genesis block if this is node 1
if [ "${NODE_NUMBER}" == "1" ]; then
    # Create genesis block
    /bsv2/src/bitcoin-cli -datadir=${NODE_DIR} generatetoaddress 1 $(bitcoin-cli -datadir=${NODE_DIR} getnewaddress)
    
    # Get genesis block hash
    GENESIS_HASH=$(/bsv2/src/bitcoin-cli -datadir=${NODE_DIR} getblockhash 0)
    echo "Genesis block created with hash: ${GENESIS_HASH}"
fi
