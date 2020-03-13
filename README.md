# libmapper_arduino
An Arduino library for using libmapper. Works with ESP32 Arduino only. Tested with arduino-esp32 v1.0.4.

## Installation
* Unzip libmapper.zip from [releases](https://github.com/mathiasbredholt/libmapper_arduino/releases) into Arduino libraries folder
* Library is included in .ino file using ```#include <mapper.h>```
* Use the C API as described [here](http://libmapper.github.io/tutorials/c.html) 

## Compile from source
* Clone repository
```
git clone --recursive https://github.com/mathiasbredholt/libmapper_arduino.git
```
* Until the issue in https://github.com/mathiasbredholt/libmapper_arduino/issues/3 gets fixed the file in `~/Library/Arduino15/packages/esp32/hardware/esp32/1.0.4/tools/sdk/include/lwip/arpa/inet.h` needs to be updated as described in the issue.
* Run
```
make
```
* The Makefile will configure liblo and libmapper
* The Arduino library will be compiled to build/Arduino/libmapper
