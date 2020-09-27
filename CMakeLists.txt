cmake_minimum_required(VERSION 3.10)
set(CMAKE_TOOLCHAIN_FILE arduino-esp32.cmake)

project(libmapper)

set(LIBLO_SRCS liblo/src/address.c liblo/src/blob.c liblo/src/bundle.c liblo/src/message.c liblo/src/method.c liblo/src/pattern_match.c liblo/src/send.c liblo/src/server.c liblo/src/server_thread.c liblo/src/timetag.c liblo/src/version.c)
set(LIBMAPPER_SRCS libmapper/src/device.c libmapper/src/expression.c libmapper/src/graph.c libmapper/src/link.c libmapper/src/list.c libmapper/src/map.c libmapper/src/network.c libmapper/src/object.c libmapper/src/properties.c libmapper/src/router.c libmapper/src/signal.c libmapper/src/slot.c libmapper/src/table.c libmapper/src/time.c libmapper/src/value.c)
set(COMPAT_SRCS compat-idf/src/gai_strerror.c compat-idf/src/gethostname.c compat-idf/src/getnameinfo.c compat-idf/src/ifaddrs.c)
set(ZLIB_SRCS zlib/crc32.c)

set(SRCS ${COMPAT_SRCS} ${LIBLO_SRCS} ${LIBMAPPER_SRCS} ${ZLIB_SRCS})

include_directories(libmapper/include liblo compat-idf/include zlib ${IDF_INCLUDES})

add_library(mapper STATIC ${SRCS})

get_filename_component(compat_include compat-idf/include/compat.h ABSOLUTE)
target_compile_options(mapper PRIVATE -DHAVE_CONFIG_H -include${compat_include})

add_custom_command(OUTPUT liblo/config.h
                   COMMAND cp liblo_config.h liblo/config.h
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
add_custom_command(OUTPUT liblo/lo/lo.h
                   COMMAND cp lo.h liblo/lo/lo.h
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
add_custom_command(OUTPUT liblo/lo/lo_endian.h
                   COMMAND cp lo_endian.h liblo/lo/lo_endian.h
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
add_custom_command(OUTPUT libmapper/src/config.h
                   COMMAND cp libmapper_config.h libmapper/src/config.h
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_target(libmapper_config_headers DEPENDS liblo/config.h liblo/lo/lo.h liblo/lo/lo_endian.h libmapper/src/config.h)
add_dependencies(mapper libmapper_config_headers)
add_custom_command(TARGET mapper POST_BUILD COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/genlib.sh)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Arduino/libmapper DESTINATION ${ARDUINO_LIBRARY_PATH})
install(TARGETS mapper DESTINATION ${ARDUINO_LIBRARY_PATH}/libmapper/src/esp32)
