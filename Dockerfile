FROM debian:jessie

RUN apt-get update && apt-get install -y \
  build-essential autoconf libtool \
  cmake \
  git \
  pkg-config \
  && apt-get clean

ENV GRPC_RELEASE_TAG v1.0.1

RUN git clone -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /var/local/git/grpc

# install grpc
RUN cd /var/local/git/grpc && \
    git submodule update --init && \
    make && \
    make install && make clean

#install protoc
RUN cd /var/local/git/grpc/third_party/protobuf && \
    make && make install && make clean
