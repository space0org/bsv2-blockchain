FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    libssl-dev \
    libevent-dev \
    bsdmainutils \
    python3 \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-chrono-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libminiupnpc-dev \
    libzmq3-dev \
    libqt5gui5 \
    libqt5core5a \
    libqt5dbus5 \
    qttools5-dev \
    qttools5-dev-tools \
    libprotobuf-dev \
    protobuf-compiler \
    libqrencode-dev

# Copy BSV2 source code
COPY . /bsv2

# Build BSV2
WORKDIR /bsv2/src
RUN ./autogen.sh && \
    ./configure && \
    make -j$(nproc)

# Create data directory
RUN mkdir -p /data/bsv2

EXPOSE 8443 18443 18543

CMD ["/bin/bash"]
