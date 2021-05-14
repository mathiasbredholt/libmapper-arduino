# libmapper-arduino <img style="float:right;padding:10px" src="http://libmapper.github.io/images/libmapper_logo_black_512px.png" width="100">
- An Arduino library for using libmapper.
- Works with ESP32 only.
- Tested with arduino-esp32 v1.0.4.

## Installation
* Clone or download this repository as zip into libraries folder

### C++ API
* To use the C++ API, add ```#include <mapper_cpp.h>``` to .ino file
* A tutorial for libmapper C++ API is found [here](http://libmapper.github.io/tutorials/cpp.html)

### C API
* To use the C API, add ```#include <mapper.h>``` to .ino file
* A tutorial for libmapper C API is found [here](http://libmapper.github.io/tutorials/c.html)

## Issues
### fatal error: ../../../lwip/src/include/lwip/inet.h: No such file or directory
- https://github.com/mathiasbredholt/libmapper-arduino/issues/3
- The file {Arduino hardware path}/esp32/1.0.6/tools/sdk/include/lwip/arpa/inet.h should be changed from
```
#ifndef INET_H_
#define INET_H_

#include "../../../lwip/src/include/lwip/inet.h"

#endif /* INET_H_ */
```
to
```
#ifndef INET_H_
#define INET_H_

#include "lwip/inet.h"

#endif /* INET_H_ */
```
- This issue is fixed in newer versions of esp-idf and is fixed in arduino-esp32 v2.0.
## Updating library 
- Run `update-library.sh`
