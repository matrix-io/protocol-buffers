#!/bin/bash
# Generates NodeJS protocol buffers via protobufjs

#set -e

PBJS=$(which pbjs)
OUT_FILE=index.js
VERSION=$1

if [ "$PBJS" = '' ]; then
  echo "A pbjs executable is required to build nodejs protos"
  exit 1
fi

if [ "$VERSION" = '' ]; then
  echo "Please specify a version as the first positional argument. ie. 0.0.20"
  exit 1
fi

echo "Building nodejs proto package v${VERSION} ..."

# Generate protos
FILES=$(find .. -name "*.proto")
$PBJS -t static-module  -o $OUT_FILE $FILES

cat <<EOF > package.json
{
  "name": "matrix-protos",
  "version": "${VERSION}",
  "description": "MATRIX-IO Protocol Buffers",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": {
    "name": "MATRIX-IO Team",
    "email": "appdev@matrixlabs.ai",
    "url": "http://www.matrixlabs.ai/"
  },
  "bugs": {
    "url": "https://github.com/matrix-io/protocol-buffers/issues"
  },
  "license": "GPL-3.0",
  "dependencies": {
    "protobufjs": "^6.8.0"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/matrix-io/protocol-buffers.git"
  }
}
EOF
