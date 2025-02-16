# YUL Blockchain Dashboard

## Overview
The YUL blockchain dashboard provides real-time monitoring of:
- Block creation and propagation
- Transaction processing
- Network peers
- Mempool status
- Mining operations

## Configuration
Dashboard settings are stored in `config/dashboard/config.json`:
- Port: 3010 (default)
- Node Connection:
  - Host: node1
  - Port: 8332
  - Authentication: Using YUL_RPC_USER and YUL_RPC_PASSWORD
- Refresh Interval: 10 seconds

## Access
The dashboard is available at `http://localhost:3010` after deployment.

## Features
- Real-time block monitoring
- Transaction tracking
- Peer network visualization
- Mempool statistics
- Mining controls
