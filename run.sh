#!/bin/bash
docker pull fullnodes/monero:latest
docker stop monerod
docker rm monerod
docker volume create monero
docker run -dit --name monerod --net=host --restart=always -v monero:/root/.bitmonero fullnodes/monero:latest
mkdir -p ~/.bin
cp $(pwd)/bin/monero* ~/.bin
