# libmapper_arduino
An Arduino library for using libmapper

## Installation
* Unzip libmapper.zip from [releases](https://github.com/mathiasbredholt/libmapper_arduino/releases) into Arduino libraries folder
* Library is included in .ino file using ```#include "mapper.h"```
* Use the C API as described [here](http://libmapper.github.io/tutorials/c.html) 

## Compile from source
* Clone repository
```
git clone --recursive https://github.com/mathiasbredholt/libmapper_arduino.git
```
* Run
```
make
```
* The Makefile will configure liblo and libmapper
* The Arduino library will be compiled to build/Arduino/libmapper