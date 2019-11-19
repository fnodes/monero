#!/bin/bash

set -euo pipefail

if [ $# -eq 0 ]; then
  exec monerod --p2p-bind-ip=0.0.0.0 --p2p-bind-port=18080 --rpc-bind-ip=0.0.0.0 --rpc-bind-port=18081 --non-interactive --confirm-external-bind
else
  exec "$@"
fi
