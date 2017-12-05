# Protocol Buffers

[![Build Status][travis-badge]][travis-link]

This repo contains the message structures (as protocol buffers) currently defined for inter application communication. Applications using protocol buffers should `git submodule` this repo. 

## Building the protos
You will need [gRPC](http://www.grpc.io/) and [cmake](https://cmake.org/) installed on your 
system :
```
$ mkdir build
$ cd build 
$ cmake -DCMAKE_CXX_FLAGS="-std=c++11" ..
$ make
```

Alternatively you can use the [docker](https://www.docker.com/) and conveniently build
with a single [docker-compose](https://docs.docker.com/compose/) command:
```
$ docker-compose run c-build
```

## Proto messages for other languages
You can find packaged proto messages for NodeJS in the [npm](https://www.npmjs.com/package/matrix-proto) and [Pypi](https://pypi.python.org/pypi/matrix-io-proto/0.0.12) repos.

## Contributing
As a general guideline, protocol buffers should be backwards compatible, so make sure any changes you do, are in fact backwards compatible. 

Changes done to messages will impact many applications, so make sure you create a documented **pull request** with your changes and you reference all relevant reviewers (MALOS, MatrixOS, Vision Services) teams.   

You should always keep your application compatible with the latest version of the protocol buffers, so make sure you run `git submodule update --remote` the protocol buffer submodule, or `git pull origin master` inside the submodule.  

## License

* See [LICENSE](./LICENSE)


[travis-badge]: https://travis-ci.org/matrix-io/protocol-buffers.svg?branch=master
[travis-link]: https://travis-ci.org/matrix-io/protocol-buffers
