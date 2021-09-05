#!/bin/sh

set -euxo pipefail

pushd "`dirname $0`/.."
ssh -F ./config/ssh/ssh_config -i ./config/ssh/guest_ssh_key nomad-op-1

