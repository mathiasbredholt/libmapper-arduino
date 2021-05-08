# libmapper-arduino <img style="float:right;padding:10px" src="http://libmapper.github.io/images/libmapper_logo_black_512px.png" width="100">
- An Arduino library for using libmapper.
- Works with ESP32 only.
- Tested with arduino-esp32 v1.0.4.

## Installation
* Unzip libmapper.zip from [releases](https://github.com/mathiasbredholt/libmapper-arduino/releases) into Arduino libraries folder
* Library is included in .ino file using ```#include <mapper.h>```
* Use the C API as described [here](http://libmapper.github.io/tutorials/c.html) 

## Stack overflow in loopTask
* https://github.com/mathiasbredholt/libmapper-arduino/issues/2
* The stack size of the main loopTask in arduino-esp32 is 8192 bytes . It should be increased, but this can only be done locally at the moment.
* It can be changed in `hardware/esp32/1.0.4/cores/esp32/main.cpp`. The following works for me:
```
extern "C" void app_main()
{
    loopTaskWDTEnabled = false;
    initArduino();
    xTaskCreateUniversal(loopTask, "loopTask", 16384, NULL, 1, &loopTaskHandle, CONFIG_ARDUINO_RUNNING_CORE);
}
```

## Updating library
- Run `update-library.sh`
