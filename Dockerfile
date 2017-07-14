FROM debian:jessie

RUN apt-get update && apt-get install -y \
  build-essential autoconf libtool \
  cmake \
  curl \
  git \
  pkg-config \
  unzip \
  && apt-get clean

ENV GRPC_RELEASE_TAG v1.2.0

# Install gRPC and friends
RUN git clone -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /grpc \
    && cd /grpc \
    && git submodule update --init \
    # Install protobuf
    && cd third_party/protobuf \
    && ./autogen.sh && ./configure && make && make install && ldconfig \
    # Install gRPC
    && cd ../../ && make && make install && make clean \
    && rm -r /grpc
