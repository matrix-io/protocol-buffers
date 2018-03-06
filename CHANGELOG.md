# Change Log

## [0.1.4] - 2018-03-05
###  Added
- Allows to set the color temperature (warm white <-> cold white) for non-color zigbee bulbs.
- Updates Python and NodeJS packages

## [0.1.3] - 2018-02-10
### Added
- Adds `uuid` to `RectangularDetection` 
- `timestamp` to `VisionEvent` 

## [0.1.2] - 2018-02-08
## Changed
- Introduces `matrix_io.malos`, `matrix_io.vision` namespaces for proto messages.

## Added
- Python packages are now [available](https://pypi.python.org/pypi/matrix-io-proto)
- NodeJS packages are now [available](https://www.npmjs.com/package/matrix-protos)

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
