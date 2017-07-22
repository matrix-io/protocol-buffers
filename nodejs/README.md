# MATRIX Ecosystem protocol buffers for NodeJS
Package contains a static build of MATRIX protocol buffers via [protobufjs 6.x](https://www.npmjs.com/package/protobufjs).

## Installation
```bash
$ npm install matrix-protos
```

## Features
  - Removes the need of passing proto paths inside applications
  - Improved message API thanks to [protobufjs 6.x](https://www.npmjs.com/package/protobufjs)

## Docs & Community

  * [MATRIX documentation / Quickstart](https://creator.matrix.one/#!/develop/start)
  * [Community](http://community.matrix.one/)
  * [Github repo](https://github.com/matrix-io)
  * [Examples](https://creator.matrix.one/#!/examples)
  * [MOS - A NodeJS framework for MATRIX Creator](https://github.com/matrix-io/matrix-os)
  * [MATRIX-CLI - MOS Command line](https://github.com/matrix-io/matrix-cli)

## Quick Start

NodeJS proto message usage is provided via [protobufjs 6.x](https://www.npmjs.com/package/protobufjs) library, so make sure you check out the documentation.

You can find the code of the following examples in the [MATRIX MALOS repo](https://github.com/matrix-io/matrix-creator-malos/tree/master/src/js_test)

[MATRIX MALOS protocol](https://github.com/matrix-io/matrix-creator-malos) is an abstraction layer built on top of [ZeroMQ](http://zeromq.org/) that uses [protocol buffers](https://developers.google.com/protocol-buffers/docs/proto3) as the data exchange format. In a nutshell, MALOS exposes 4 ports for every service: **base or driver port**, **error port**, **keep alive port** and **data update port**. In the following examples, we will show how to send a config to the **driver port** and how to obtain data updates on the **data update port**.

Please refer to the [examples](https://github.com/matrix-io/matrix-creator-malos/tree/master/src/js_test) for a complete implementation.

### Importing ZMQ and matrix-proto modules
```js
var zmq = require('zmq')

// Import MATRIX Proto messages
var matrix_io = require('matrix-protos').matrix_io
```

### Getting data about the available drivers and ports

Go to the [full code][1]

```js
var requestSocket = zmq.socket('req')

var creator_ip = process.env.CREATOR_IP || '127.0.0.1';
var creator_info_base_port = 20012

requestSocket.on('message', (buffer) => {
    var msg_inst = matrix_io.malos.v1.driver.MalosDriverInfo.decode(buffer)
    console.log(msg_inst)
    process.exit(0)
});

requestSocket.connect('tcp://' + creator_ip + ':' + creator_info_base_port)
requestSocket.send('');
```

The output should more or less look like this:

```bash
$ node test_driver_info.js
MalosDriverInfo {
  info:
   [ DriverInfo {
       driverName: 'IMU',
       basePort: 20013,
       providesUpdates: true,
       delayBetweenUpdates: 2000,
       needsPings: true,
       timeoutAfterLastPing: 6000,
       notesForHuman: 'Provides yaw/pitch/roll. Check Imu message (protocol buffer)' },
     DriverInfo {
       driverName: 'Humidity',
       basePort: 20017,
       providesUpdates: true,
       delayBetweenUpdates: 2000,
       needsPings: true,
       timeoutAfterLastPing: 6000,
       notesForHuman: 'Provides humidity and temperature. Check Humidity message (protocol buffer)' },
     DriverInfo {
       driverName: 'Everloop',
       basePort: 20021,
       delayBetweenUpdates: 1000,
       timeoutAfterLastPing: 5000,
       notesForHuman: 'Write-only. There are 35 leds. Values range from 0 to 255. Check message EverloopImage (protocol buffer)' },
     DriverInfo {
       driverName: 'Pressure',
       basePort: 20025,
       providesUpdates: true,
       delayBetweenUpdates: 2000,
       needsPings: true,
       timeoutAfterLastPing: 6000,
       notesForHuman: 'Provides barometer/altimeter and temperature. Check Pressure message (protocol buffer)' },
     DriverInfo {
       driverName: 'UV',
       basePort: 20029,
       providesUpdates: true,
       delayBetweenUpdates: 2000,
       needsPings: true,
       timeoutAfterLastPing: 6000,
       notesForHuman: 'Provides UV index. Check UV index message (protocol buffer). Also provides a string with the UV risk according to the OMS. See: https://www.epa.gov/sunsafety/uv-index-scale-0' },
     DriverInfo {
       driverName: 'MicArray_Alsa',
       basePort: 20037,
       delayBetweenUpdates: 1000,
       timeoutAfterLastPing: 6000,
       notesForHuman: 'Simple ALSA Driver for MATRIX Creator Microphone Array' },
     DriverInfo {
       driverName: 'Lirc',
       basePort: 20041,
       delayBetweenUpdates: 1000,
       timeoutAfterLastPing: 5000,
       notesForHuman: 'Write-read. Get list remotes and send commands via IR. In development' },
     DriverInfo {
       driverName: 'Servo',
       basePort: 20045,
       delayBetweenUpdates: 1000,
       timeoutAfterLastPing: 5000,
       notesForHuman: 'Write-read. Servo handler. In development' },
     DriverInfo {
       driverName: 'Gpio',
       basePort: 20049,
       delayBetweenUpdates: 250,
       timeoutAfterLastPing: 2000,
       notesForHuman: 'Write-read. Gpio handler. In development' } ] }

```


You can then use the `basePort` in the examples below.

### Configuring and reading the pressure sensor

Go to the [full code][2]

```js
# Configure the driver (base port) socket
var configSocket = zmq.socket('push')
configSocket.connect('tcp://' + creator_ip + ':' + creator_pressure_base_port)

// Now prepare valid configuration and send it.
var config = matrix_io.malos.v1.driver.DriverConfig.create({
  delayBetweenUpdates: 2.0,  // 2 seconds between updates.
  timeoutAfterLastPing: 6.0, // Stop sending updates 6 seconds after pings.
})

configSocket.send(matrix_io.malos.v1.driver.DriverConfig.encode(config).finish())

# Configure the data update port socket
var updateSocket = zmq.socket('sub')
updateSocket.connect('tcp://' + creator_ip + ':' + (creator_pressure_base_port + 3))
updateSocket.subscribe('')

updateSocket.on('message', (buffer) => {
  var data = matrix_io.malos.v1.sense.Pressure.decode(buffer)
  console.log(data)
});
```

### Configuring and reading the humidity sensor

Go to the [full code][3]

```js
# Configure the driver (base port) socket
var configSocket = zmq.socket('push')
configSocket.connect('tcp://' + creator_ip + ':' + creator_humidity_base_port)

// Now prepare valid configuration and send it.
var config = matrix_io.malos.v1.driver.DriverConfig.create({
  delayBetweenUpdates: 2.0,  // 2 seconds between updates
  timeoutAfterLastPing: 6.0, // Stop sending updates 6 seconds after pings.
  humidity: matrix_io.malos.v1.sense.HumidityParams.create({
    currentTemperature: 23   // Real current temperature [Celsius] for calibration
  })
})

configSocket.send(matrix_io.malos.v1.driver.DriverConfig.encode(config).finish())

# Configure the data update port socket
var updateSocket = zmq.socket('sub')
updateSocket.connect('tcp://' + creator_ip + ':' + (creator_humidity_base_port + 3))
updateSocket.subscribe('')

updateSocket.on('message', (buffer) => {
  var data = matrix_io.malos.v1.sense.Humidity.decode(buffer)
  console.log(data)
});
```

### Configuring and reading the IMU (Inertial Measurement Unit)

Go to the [full code][4]

```js
# Configure the driver (base port) socket
var configSocket = zmq.socket('push')
configSocket.connect('tcp://' + creator_ip + ':' + creator_imu_base_port)

// Now prepare valid configuration and send it.
var config = matrix_io.malos.v1.driver.DriverConfig.create({
  delayBetweenUpdates: 2.0,  // 2 seconds between updates
  timeoutAfterLastPing: 6.0  // Stop sending updates 6 seconds after pings.
})

configSocket.send(matrix_io.malos.v1.driver.DriverConfig.encode(config).finish())

# Configure the data update port socket
var updateSocket = zmq.socket('sub')
updateSocket.connect('tcp://' + creator_ip + ':' + (creator_imu_base_port + 3))
updateSocket.subscribe('')

updateSocket.on('message', (imu_buffer) => {
  var imuData = matrix_io.malos.v1.sense.Imu.decode(imu_buffer)
  console.log(imuData)
});
```

### Setting the Everloop LED intensity

Go to the [full code][5]

```js
# Configure the driver (base port) socket
var configSocket = zmq.socket('push')
configSocket.connect('tcp://' + creator_ip + ':' + creator_everloop_base_port /* config */)

var max_intensity = 50
var intensity_value = max_intensity

function setEverloop(ledValues) {
    var image = matrix_io.malos.v1.io.EverloopImage.create()
    for (var j = 0; j < 35; ++j) {
      var ledValue = matrix_io.malos.v1.io.LedValue.create(ledValues);
      image.led.push(ledValue)
    }
    var config = matrix_io.malos.v1.driver.DriverConfig.create({
      image: image
    })
    configSocket.send(matrix_io.malos.v1.driver.DriverConfig.encode(config).finish());
}

setInterval(() => {
  intensity_value -= 1
  if (intensity_value < 0)
    intensity_value = max_intensity
  setEverloop({
    red: 0,
    green: intensity_value,
    blue: 0,
    white: 0
  })
}, 50);
```

### Using the GPIO

Go to the [full code][6]

```js
# Configure the driver (base port) socket
var configSocket = zmq.socket('push')
configSocket.connect('tcp://' + creator_ip + ':' + creator_gpio_base_port /* config */)

// Set GPIO 0 to output mode
var gpio_cfg_cmd = matrix_io.malos.v1.io.GpioParams.create({
  pin: 0,
  mode: matrix_io.malos.v1.io.GpioParams.EnumMode.OUTPUT
})

// For demo: toggle function for output value
process.nextTick(() => { toggle =! toggle });
console.log('==> pin 0 set to:', toggle)
if (toggle) gpio_cfg_cmd.value = 1;
else gpio_cfg_cmd.value = 0;

// build and sending proto
var config = matrix_io.malos.v1.driver.DriverConfig.create({
  gpio: gpio_cfg_cmd
})
configSocket.send(matrix_io.malos.v1.driver.DriverConfig.encode(config).finish())


// Set GPIO 1 to input mode
var config = matrix_io.malos.v1.driver.DriverConfig.create({
  delayBetweenUpdates: 0.250, // 250 miliseconds between updates.
  timeoutAfterLastPing: 2.0,  // Stop sending updates 2 seconds after pings.
  gpio: matrix_io.malos.v1.io.GpioParams.create({
    pin: 1, // GPIO params: set pin 1 to input mode
    mode: matrix_io.malos.v1.io.GpioParams.EnumMode.INPUT
  })
})
configSocket.send(matrix_io.malos.v1.driver.DriverConfig.encode(config).finish())

# Configure the data update port socket
var updateSocket = zmq.socket('sub')
updateSocket.connect('tcp://' + creator_ip + ':' + (creator_gpio_base_port + 3))
updateSocket.subscribe('')

updateSocket.on('message', (gpio_buffer) => {
  var gpioData = matrix_io.malos.v1.io.GpioParams.decode(gpio_buffer)
  // output in binary format all 15 pins of GPIO
  console.log('<== GPIO pins register: ', dec2bin(gpioData.values))
});
```

[1]: https://github.com/matrix-io/matrix-creator-malos/blob/master/src/js_test/test_driver_info.js
[2]: https://github.com/matrix-io/matrix-creator-malos/blob/master/src/js_test/test_pressure.js
[3]: https://github.com/matrix-io/matrix-creator-malos/blob/master/src/js_test/test_humidity.js
[4]: https://github.com/matrix-io/matrix-creator-malos/blob/master/src/js_test/test_imu.js
[5]: https://github.com/matrix-io/matrix-creator-malos/blob/master/src/js_test/test_everloop.js
[6]: https://github.com/matrix-io/matrix-creator-malos/blob/master/src/js_test/test_gpio.js
