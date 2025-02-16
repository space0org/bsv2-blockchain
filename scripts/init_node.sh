#!/bin/bash

# YUL Blockchain Node Initialization Script
# Based on Bitcoin SV v1.1.0

NODE_DIR="/data"
CONFIG_FILE="/data/bitcoin.conf"

# Verify directory structure
if [ ! -d "$NODE_DIR" ]; then
    echo "Creating node directory at $NODE_DIR"
    mkdir -p "$NODE_DIR"
fi

# Verify configuration file
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# Start Bitcoin daemon with BSV v1.1.0 parameters
echo "Starting YUL blockchain node..."
exec bitcoind \
    -datadir="$NODE_DIR" \
    -conf="$CONFIG_FILE" \
    -printtoconsole

