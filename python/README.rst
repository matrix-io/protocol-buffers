========================
MATRIX Ecosystem protos
========================

matrix-protos contains the python classes generated from the 
protocol buffers available in the matrixprotos_ repository.

Installation
------------

.. code:: bash

  $ pip install matrix_io-proto

Features
--------

* Cleaner imports of proto messages to python projects

Docs & Community 
----------------

* `MATRIX documentation / Quickstart`_
* `Community`_
* `Github repo`_
* `Examples`_

Quick Start
------------

Make sure you check the `Python generated code reference`_  to understand details and usage patterns of the proto classes.

You can find the code of the following examples in the `MATRIX MALOS repo`_. 

`MATRIX MALOS protocol`_ is an abstraction layer built on top of `ZeroMQ`_  that uses `protocol buffers`_ as the data exchange format. In a nutshell, MALOS exposes 4 ports for every service: **base or driver port**, **error port**, **keep alive port** and **data update port**. In the following examples, we will show how to send a config to the **driver port** and how to obtain data updates on the **data update port**. 

Please refer to the `MATRIX MALOS repo`_ code examples for a complete implementation.

Importing ZMQ and matrix_io.proto modules
+++++++++++++++++++++++++++++++++++++++++

.. code:: python

  import zmq
  from matrix_io.proto.malos.v1 import driver_pb2 as driver_proto


Getting data about the available drivers and ports
++++++++++++++++++++++++++++++++++++++++++++++++++

Go to the `full code <https://github.com/matrix-io/matrix-creator-malos/blob/master/src/python_test/test_driver_info.py>`_ :

.. code:: python

  # or local ip of MATRIX creator
  creator_ip = os.environ.get('CREATOR_IP', '127.0.0.1')
  creator_base_port = 20012

  # grab zmq context
  context = zmq.Context()

  # get a request socket from the context
  req_socket = context.socket(zmq.REQ)

  # connect to the socket using the cretor_ip and creator_base_port
  req_socket.connect('tcp://{0}:{1}'.format(creator_ip, creator_base_port))

  # send literally anything to get a response, this is a blocking operation
  req_socket.send_string('')

  # capture the message from the socket
  message = req_socket.recv()

  # parse data using the protocol buffers you compiled
  proto_data = driver_proto.MalosDriverInfo().FromString(message)

  # print the prased proto data to stdout
  print(proto_data)

The output should more or less look like this:

.. code:: bash

  $ python test_driver_info.py

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
        notesForHuman: 'Simple ALSA Driver for MATRIX Creators Microphone Array' },
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


You can then use the `basePort` in the examples below. 

Configuring and reading the pressure sensor
+++++++++++++++++++++++++++++++++++++++++++

Go to the `full code <https://github.com/matrix-io/matrix-creator-malos/blob/master/src/python_test/test_pressure.py>`_:

.. code:: python

  from multiprocessing import Process

  from zmq.eventloop import ioloop
  from matrix_io.proto.malos.v1 import sense_pb2

  def pressure_data_callback(data):
      """Callback that prints new data updates to stdout"""
      pressure_info = sense_pb2.Pressure().FromString(data[0])
      print('{0}'.format(pressure_info))

  if __name__ == '__main__':
      # Instantiate ioloop
      ioloop.install()

      # Start a process to get the data
      Process(target=register_data_callback, args=(pressure_data_callback, creator_ip, pressure_port)).start()

      # Start a process to get the error messages
      Process(target=register_error_callback, args=(pressure_error_callback, creator_ip, pressure_port)).start()

      # Start a process to keep the driver alive
      Process(target=driver_keep_alive, args=(creator_ip, pressure_port)).start()


Configuring and reading the humidity sensor
+++++++++++++++++++++++++++++++++++++++++++

Go to the `full code <https://github.com/matrix-io/matrix-creator-malos/blob/master/src/python_test/test_humidity.py>`_:

.. code:: python

  import time
  from matrix_io.proto.malos.v1 import driver_pb2
  from matrix_io.proto.malos.v1 import sense_pb2

  from multiprocessing import Process
  from zmq.eventloop import ioloop

  from utils import driver_keep_alive, register_data_callback, register_error_callback

  # or local ip of MATRIX creator
  creator_ip = os.environ.get('CREATOR_IP', '127.0.0.1')

  humidity_port = 20013 + 4


  def config_socket():
      """Configure and calibrate the humidity driver"""

      # Grab the zmq context and set it to push, then connect to it
      context = zmq.Context()
      socket = context.socket(zmq.PUSH)
      socket.connect('tcp://{0}:{1}'.format(creator_ip, humidity_port))

      # Create a new driver config
      driver_config_proto = driver_pb2.DriverConfig()

      # Set the delay between updates that the driver returns
      driver_config_proto.delay_between_updates = 2.0

      # Stop sending updates if there is no ping for 6 seconds
      driver_config_proto.timeout_after_last_ping = 6.0

      # Calibrate the temperature by taking a real world
      # measurment from a thermometer and enter it in here
      # in degrees celcius
      driver_config_proto.humidity.current_temperature = 23

      # Serialize the config and send it to the config socket
      socket.send(driver_config_proto.SerializeToString())


  def humidity_data_callback(data):
      """Capture any data and print them to stdout"""
      humidity_info = sense_pb2.Humidity().FromString(data[0])
      print('{0}'.format(humidity_info))

  if __name__ == '__main__':
      # Instiate ioloop
      ioloop.install()

      # Run the configure socket function to  calibrate the sensor
      config_socket()

      # Start a new process that captures and prints data to stdout
      Process(target=register_data_callback, args=(humidity_data_callback, creator_ip, humidity_port)).start()

      # Start another new process to capture errors to stdout
      Process(target=register_error_callback, args=(humidity_error_callback, creator_ip, humidity_port)).start()

      # Start one more new process to keep the driver alive
      # If this thread in particular is killed, 6 seconds later
      # the driver will stop sending updates due to out config
      Process(target=driver_keep_alive, args=(creator_ip, humidity_port)).start()


Configuring and reading the IMU (Inertial Measurement Unit)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Go to the `full code <https://github.com/matrix-io/matrix-creator-malos/blob/master/src/python_test/test_imu.py>`_:

.. code:: python

  def imu_data_callback(data):
      """Callback that prints new data updates to stdout"""
      imu_info = sense_pb2.Imu().FromString(data[0])
      print('{0}'.format(imu_info))


  def imu_error_callback(error):
      """Callback that prints error messages to stdout"""
      print('{0}'.format(error))


  if __name__ == '__main__':
      # Instantiate ioloop
      ioloop.install()

      # Start a process to get the data
      Process(target=register_data_callback, args=(imu_data_callback, creator_ip, imu_port)).start()

      # Start a process to get the error messages
      Process(target=register_error_callback, args=(imu_error_callback, creator_ip, imu_port)).start()

      # Start a process to keep the driver alive
      Process(target=driver_keep_alive, args=(creator_ip, imu_port)).start()

Setting the Everloop LED intensity
++++++++++++++++++++++++++++++++++

Go to the `full code <https://github.com/matrix-io/matrix-creator-malos/blob/master/src/python_test/test_everloop.py>`_:

.. code:: python

  from matrix_io.proto.malos.v1 import driver_pb2
  from matrix_io.proto.malos.v1 import io_pb2

  def set_everloop_intensity(intensity):
      """Sets all of the LEDS to a given rgbw value"""

      # grab zmq context
      context = zmq.Context()

      # get socket for config
      config_socket = context.socket(zmq.PUSH)
      config_socket.connect('tcp://{0}:{1}'.format(creator_ip, creator_everloop_base_port))

      # create a new driver config strut
      config = driver_pb2.DriverConfig()

      # initialize an empty list for the "image" or LEDS
      image = []

      # iterate over all 35 LEDS and set the rgbw value of each
      # then append it to the end of the list/image thing
      for led in range(35):
          ledValue = io_pb2.LedValue()
          ledValue.blue = 0
          ledValue.red = 0
          ledValue.green = intensity
          ledValue.white = 0
          image.append(ledValue)

      # add the "image" to the config driver
      config.image.led.extend(image)

      # send a serialized string of the driver config
      # to the config socket
      config_socket.send(config.SerializeToString())


  def animation(max_intensity=50):
      """
      This invokes the set intesnity multiple times to
      produce an animation
      """

      # Set an initial intesity from a value passed in via a
      # function parameter
      intensity_value = max_intensity

      # Invoke the intesity function before going into the loop of
      # no return so we have an initial value
      set_everloop_intensity(intensity_value)

      # Start loop of no return!
      while True:
          # Decrement the intesity value by 1
          intensity_value -= 1

          # check to see if intensity is 0 and reset it to max if not
          if intensity_value < 0:
              intensity_value = max_intensity

          # Set the intesity using the new value
          set_everloop_intensity(intensity_value)

          # Print value to stdout for debugging
          print('Intensity: {0}'.format(intensity_value))

          # Delay half a second before running the code again
          time.sleep(0.5)

  if __name__ == '__main__':
      # Instantiate ioloop
      ioloop.install()

      # Start a new process that will register
      # your callback with malOS using the utils.py
      Process(target=register_error_callback, args=(led_error_callback, creator_ip, creator_everloop_base_port)).start()

      # Start another new process that invokes the animation
      Process(target=animation, args=(40,)).start()

Using the GPIO
++++++++++++++

Go to the `full code <https://github.com/matrix-io/matrix-creator-malos/blob/master/src/python_test/test_gpio.py>`_:

.. code:: python

  from matrix_io.proto.malos.v1 import driver_pb2
  from matrix_io.proto.malos.v1 import io_pb2

  # Grab a zmq context
  context = zmq.Context()

  # Create a zmq push socket
  socket = context.socket(zmq.PUSH)

  # Connect to push socket
  socket.connect('tcp://{0}:{1}'.format(creator_ip, creator_gpio_base_port))

  # Create a new driver config
  config = driver_pb2.DriverConfig()

  # Set pin number to control
  config.gpio.pin = 15

  # Set pin 15 to output mode
  config.gpio.mode = io_pb2.GpioParams.OUTPUT

  # Start the unescapable loop!
  while True:

      # Bit shift the value on the pin
      # from high to low to high to low...
      config.gpio.value ^= 1

      # Print some debug statements
      print ('GPIO{0}={1}'.format(config.gpio.pin, config.gpio.value))

      # Serialize the configuration we created
      # and send it to the socket
      socket.send(config.SerializeToString())

      # Nap time
      time.sleep(1)


.. _`matrixprotos`: https://github.com/matrix-io/protocol-buffers
.. _`MATRIX documentation / Quickstart`: https://creator.matrix.one/#!/develop/start 
.. _`Community`: http://community.matrix.one
.. _`Github repo`: https://github.com/matrix-io
.. _`Examples`: https://creator.matrix.one/#!/examples
.. _`Python generated code reference`: https://grpc.io/docs/reference/python/generated-code.html
.. _`MATRIX MALOS repo`: https://github.com/matrix-io/matrix-creator-malos/tree/master/src/python_test
.. _`MATRIX MALOS protocol`: https://github.com/matrix-io/matrix-creator-malos
.. _`ZeroMQ`: http://zeromq.org/
.. _`protocol buffers`: https://developers.google.com/protocol-buffers/docs/proto3
