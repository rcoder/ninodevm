!#/bin/env bash

set -eoux pipefail

GH_SPEC_URL="https://raw.githubusercontent.com/hashicorp/nomad-openapi/03600347fe4914314e0239916fb3b041fb025e3e/v1/openapi.yaml"

TMP_DIR=`mktemp -d`

BASE_DIR=`dirname $0`

mkdir -p "$TMP_DIR/ts-client"
curl -L $GH_SPEC_URL -o $TMP_DIR/openapi.yaml

docker run --rm \
	--volume "$TMP_DIR:/local" \
	openapitools/openapi-generator-cli:v5.2.1 generate \
	-i $GH_SPEC_URL \
	-g typescript \
	-o /local/ts-client \
	--additional-properties=platform=deno

sudo chown -R `whoami` $TMP_DIR
rsync -a $TMP_DIR/ts-client/ ./ts-client/
rm -rf $TMP_DIR
