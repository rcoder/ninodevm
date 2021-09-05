#!/bin/sh

set -euxo pipefail
pushd "`dirname $0`/.."

SOCK_PATH="${SOCK_PATH:-./firecracker.socket}"

sudo curl --unix-socket "$SOCK_PATH" -i \
     -X PUT "http://localhost/actions" \
     -H  "accept: application/json" \
     -H  "Content-Type: application/json" \
     -d '{ "action_type": "SendCtrlAltDel" }'

