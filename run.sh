#!/bin/bash
docker pull fullnodes/monero:latest
docker stop monerod
docker rm monerod
docker volume create monero
docker run -dit --name monerod --restart=always -v monero:/root/.bitmonero fullnodes/monero:latest
