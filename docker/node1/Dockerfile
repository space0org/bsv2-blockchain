FROM bitcoinsv/bitcoin-sv:1.1.0

COPY ./config/bitcoin.conf /data/bitcoin.conf
VOLUME /data

EXPOSE 8333 8332 28332

ENTRYPOINT ["bitcoind"]
CMD ["-conf=/data/bitcoin.conf", "-printtoconsole"]
