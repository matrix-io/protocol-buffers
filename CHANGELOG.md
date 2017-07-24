# Change Log
## [Unreleased]
## [0.0.11] - 2017-07-14
### Added 
- AreaConfig, AreaZndZonde Config proto merge into namespaced version
- debian package configuration

## [0.0.10] - 2017-02-17
### Added
- Recognition service protos
- Vision service protos (demographics services)
- CMake now auto-discovers protos recursively


### Changed
- Malos protos are now split as follows:
  - comm.proto
  - driver.proto
  - io.proto
  - sense.proto
  - zwave\_commands.proto
- Fully qualified names, as suggested in [protobuf 3 documentation][1]
- Unifies package names `admobilize_vision` -> `matrix_vision`

[1]: https://developers.google.com/protocol-buffers/docs/proto3#importing-definitions
