set(SDK $ENV{HOME}/Library/Arduino15/packages/esp32/hardware/esp32/1.0.4/tools/sdk)
set(SDK_INCLUDE ${SDK}/include)
set(tools $ENV{HOME}/Library/Arduino15/packages/esp32/tools/xtensa-esp32-elf-gcc/1.22.0-80-g6c4433a-5.2.0)
set(ARDUINO_COMPILE_FLAGS "-DESP_PLATFORM -DMBEDTLS_CONFIG_FILE=${SDK}/mbedtls/esp_config.h -DHAVE_CONFIG_H -DGCC_NOT_5_2_0=0 -DWITH_POSIX -std=gnu99 -Os -g3 -fstack-protector -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -MMD -I${SDK_INCLUDE}/config -I${SDK_INCLUDE}/app_trace -I${SDK_INCLUDE}/app_update -I${SDK_INCLUDE}/asio -I${SDK_INCLUDE}/bootloader_support -I${SDK_INCLUDE}/bt -I${SDK_INCLUDE}/coap -I${SDK_INCLUDE}/console -I${SDK_INCLUDE}/driver -I${SDK_INCLUDE}/esp-tls -I${SDK_INCLUDE}/esp32 -I${SDK_INCLUDE}/esp_adc_cal -I${SDK_INCLUDE}/esp_event -I${SDK_INCLUDE}/esp_http_client -I${SDK_INCLUDE}/esp_http_server -I${SDK_INCLUDE}/esp_https_ota -I${SDK_INCLUDE}/esp_ringbuf -I${SDK_INCLUDE}/ethernet -I${SDK_INCLUDE}/expat -I${SDK_INCLUDE}/fatfs -I${SDK_INCLUDE}/freemodbus -I${SDK_INCLUDE}/freertos -I${SDK_INCLUDE}/heap -I${SDK_INCLUDE}/idf_test -I${SDK_INCLUDE}/jsmn -I${SDK_INCLUDE}/json -I${SDK_INCLUDE}/libsodium -I${SDK_INCLUDE}/log -I${SDK_INCLUDE}/lwip -I${SDK_INCLUDE}/mbedtls -I${SDK_INCLUDE}/mdns -I${SDK_INCLUDE}/micro-ecc -I${SDK_INCLUDE}/mqtt -I${SDK_INCLUDE}/newlib -I${SDK_INCLUDE}/nghttp -I${SDK_INCLUDE}/nvs_flash -I${SDK_INCLUDE}/openssl -I${SDK_INCLUDE}/protobuf-c -I${SDK_INCLUDE}/protocomm -I${SDK_INCLUDE}/pthread -I${SDK_INCLUDE}/sdmmc -I${SDK_INCLUDE}/smartconfig_ack -I${SDK_INCLUDE}/soc -I${SDK_INCLUDE}/spi_flash -I${SDK_INCLUDE}/spiffs -I${SDK_INCLUDE}/tcp_transport -I${SDK_INCLUDE}/tcpip_adapter -I${SDK_INCLUDE}/ulp -I${SDK_INCLUDE}/vfs -I${SDK_INCLUDE}/wear_levelling -I${SDK_INCLUDE}/wifi_provisioning -I${SDK_INCLUDE}/wpa_supplicant -I${SDK_INCLUDE}/xtensa-debug-module -I${SDK_INCLUDE}/esp-face -I${SDK_INCLUDE}/esp32-camera -I${SDK_INCLUDE}/esp-face -I${SDK_INCLUDE}/fb_gfx") 

set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER ${tools}/bin/xtensa-esp32-elf-gcc)
set(CMAKE_CXX_COMPILER ${tools}/bin/xtensa-esp32-elf-g++)
set(CMAKE_ASM_COMPILER ${tools}/bin/xtensa-esp32-elf-gcc)

set(CMAKE_C_FLAGS ${ARDUINO_COMPILE_FLAGS} CACHE STRING "C Compiler Base Flags")
set(CMAKE_CXX_FLAGS ${ARDUINO_COMPILE_FLAGS} CACHE STRING "C++ Compiler Base Flags")
