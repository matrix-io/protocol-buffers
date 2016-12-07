# Protocol Buffers

[![Build Status][travis-badge]][travis-link]

This repo contains the message structures (as protocol buffers) currently defined for inter application communication. Applications using protocol buffers should `git submodule` this repo. 

## Contributing
As a general guideline, protocol buffers should be backwards compatible, so make sure any changes you do, are in fact backwards compatible. 

Changes done to messages will impact many applications, so make sure you create a documented **pull request** with your changes and you reference all relevant reviewers (MALOS, MatrixOS, Vision Services) teams.   

You should always keep your application compatible with the latest version of the protocol buffers, so make sure you run `git submodule update --remote` the protocol buffer submodule, or `git pull origin master` inside the submodule.  

## License

* See [LICENSE](./LICENSE)


[travis-badge]: https://travis-ci.org/matrix-io/protocol-buffers.svg?branch=master
[travis-link]: https://travis-ci.org/matrix-io/protocol-buffers
