#!/bin/bash
set -e

PYTHON=$(which python)

# Clean up
rm -rf matrix_io

OUT_PATH=matrix_io/proto

mkdir -p $OUT_PATH
cp -r ../matrix_io/* $OUT_PATH 

sed -i 's@matrix_io/malos@matrix_io/proto/malos@g' $OUT_PATH/malos/v1/*.proto
sed -i 's@matrix_io/recognition@matrix_io/proto/recognition@g' $OUT_PATH/recognition/v1/*.proto
sed -i 's@matrix_io/vision@matrix_io/proto/vision@g' $OUT_PATH/recognition/v1/*.proto
sed -i 's@matrix_io/vision@matrix_io/proto/vision@g' $OUT_PATH/vision/v1/*.proto

sed -i 's@matrix_io.malos@matrix_io.proto.malos@g' $OUT_PATH/malos/v1/*.proto
sed -i 's@matrix_io.recognition@matrix_io.proto.recognition@g' $OUT_PATH/recognition/v1/*.proto
sed -i 's@matrix_io.vision@matrix_io.proto.vision@g' $OUT_PATH/recognition/v1/*.proto
sed -i 's@matrix_io.vision@matrix_io.proto.vision@g' $OUT_PATH/vision/v1/*.proto

FILES=$(find ./ -name "*.proto")

# Generate protos
# make sure you did pip install grpcio grpcio-tools
$PYTHON -m grpc.tools.protoc -I ./ --python_out ./  --grpc_python_out ./ $FILES

# Adjust proto path namespaces
#mkdir -p _proto
#cp -r matrix_io/* _proto
#sed -i 's@matrix_io/malos@$OUT_PATH/malos@g' _proto/malos/v1/*.py
#sed -i 's@matrix_io/recognition@$OUT_PATH/recognition@g' _proto/recognition/v1/*.py
#sed -i 's@matrix_io/vision@$OUT_PATH/vision@g' _proto/vision/v1/*.py

# Adjust python imports
#sed -i 's@from matrix_io.malos@from matrix_io.proto.malos@g' _proto/malos/v1/*.py
#sed -i 's@from matrix_io.recognition@from matrix_io.proto.recognition@g' _proto/recognition/v1/*.py
#sed -i 's@from matrix_io.vision@from matrix_io.proto.vision@g' _proto/vision/v1/*.py


# add __init__.py namespace files
echo "__import__('pkg_resources').declare_namespace(__name__)" > matrix_io/__init__.py
echo "__import__('pkg_resources').declare_namespace(__name__)" > $OUT_PATH/__init__.py

# add normal __init__.py 
touch $OUT_PATH/malos/__init__.py
touch $OUT_PATH/malos/v1/__init__.py
touch $OUT_PATH/recognition/__init__.py
touch $OUT_PATH/recognition/v1/__init__.py
touch $OUT_PATH/vision/__init__.py
touch $OUT_PATH/vision/v1/__init__.py

rm -f $OUT_PATH/malos/v1/*.proto
rm -f $OUT_PATH/recognition/v1/*.proto
rm -f $OUT_PATH/vision/v1/*.proto

#mv _proto $OUT_PATH

$PYTHON setup.py sdist

