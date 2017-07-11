#!/bin/bash
set -e

PYTHON=$(which python)

# Clean up
rm -rf matrix_io

FILES=$(find ../ -name "*.proto")
# Generate protos
# make sure you did pip install grpcio grpcio-tools
$PYTHON -m grpc.tools.protoc -I ../ --python_out ./  --grpc_python_out ./ $FILES

# Adjust proto path namespaces
mkdir -p _proto
cp -r matrix_io/* _proto
sed -i 's@matrix_io/malos@matrix_io/proto/malos@g' _proto/malos/v1/*.py
sed -i 's@matrix_io/recognition@matrix_io/proto/recognition@g' _proto/recognition/v1/*.py
sed -i 's@matrix_io/vision@matrix_io/proto/vision@g' _proto/vision/v1/*.py

# Adjust python imports
sed -i 's@from matrix_io.malos@from matrix_io.proto.malos@g' _proto/malos/v1/*.py
sed -i 's@from matrix_io.recognition@from matrix_io.proto.recognition@g' _proto/recognition/v1/*.py
sed -i 's@from matrix_io.vision@from matrix_io.proto.vision@g' _proto/vision/v1/*.py


# add __init__.py namespace files
echo "__import__('pkg_resources').declare_namespace(__name__)" > matrix_io/__init__.py
echo "__import__('pkg_resources').declare_namespace(__name__)" > _proto/__init__.py

# add normal __init__.py 
touch _proto/malos/__init__.py
touch _proto/malos/v1/__init__.py
touch _proto/recognition/__init__.py
touch _proto/recognition/v1/__init__.py
touch _proto/vision/__init__.py
touch _proto/vision/v1/__init__.py

mv _proto matrix_io/proto

$PYTHON setup.py sdist

