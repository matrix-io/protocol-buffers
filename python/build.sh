#!/bin/bash
# Generates Python protocol buffers and adjusts package namespaces
# to matrix_io.proto

set -e

PYTHON=$(which python)
PROTOC=protoc
VERSION=$1
OUT_PATH=./
GRPC_PLUGIN="protoc-gen-grpc_python=/usr/local/bin/grpc_python_plugin"

if [ "$PYTHON" = '' ]; then
  echo "A python executable is required to build python protos"
fi

if [ "$VERSION" = '' ]; then
  echo "Please specify a version as the first positional argument. ie. 0.0.20"
  exit 1
fi

echo "Building python proto package v${VERSION} ..."

# Clean up
rm -rf matrix_io

# Generate protos
# make sure you did pip install grpcio grpcio-tools
FILES=$(find .. -name "*.proto")
protoc -I .. \
  --plugin=$GRPC_PLUGIN \
  --python_out=$OUT_PATH \
  --grpc_python_out=$OUT_PATH \
  $FILES

# Add proto namespace
mkdir proto 
mv matrix_io/* proto
mv proto matrix_io

# Adjust python imports to namespaced package structure
GEN_FILES=$(find $OUT_PATH/matrix_io -name "*.py")
sed -i 's@from matrix_io\.malos@from matrix_io.proto.malos@g' $GEN_FILES
sed -i 's@from matrix_io\.recognition@from matrix_io.proto.recognition@g' $GEN_FILES
sed -i 's@from matrix_io\.vision@from matrix_io.proto.vision@g' $GEN_FILES

# add __init__.py namespace files
echo "__import__('pkg_resources').declare_namespace(__name__)" \
  > $OUT_PATH/matrix_io/__init__.py
echo "__version__ = '${VERSION}'" \
  > $OUT_PATH/matrix_io/proto/__init__.py
echo "__import__('pkg_resources').declare_namespace(__name__)" \
  >> $OUT_PATH/matrix_io/proto/__init__.py

# add normal __init__.py 
touch $OUT_PATH/matrix_io/proto/malos/__init__.py
touch $OUT_PATH/matrix_io/proto/malos/v1/__init__.py
touch $OUT_PATH/matrix_io/proto/recognition/__init__.py
touch $OUT_PATH/matrix_io/proto/recognition/v1/__init__.py
touch $OUT_PATH/matrix_io/proto/vision/__init__.py
touch $OUT_PATH/matrix_io/proto/vision/v1/__init__.py

$PYTHON setup.py sdist bdist_wheel
