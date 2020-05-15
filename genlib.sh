#!/bin/sh
SRC_DIR=../
OUTPUT_DIR=Arduino/libmapper
OUTPUT_SRC_DIR=$OUTPUT_DIR/src
OUTPUT_LIB_DIR=$OUTPUT_SRC_DIR/esp32
mkdir -p $OUTPUT_DIR
mkdir -p $OUTPUT_LIB_DIR
cp libmapper.a $OUTPUT_LIB_DIR/libmapper.a
cp $SRC_DIR/library.properties $OUTPUT_DIR/library.properties
cp -R $SRC_DIR/examples $OUTPUT_DIR
cp $SRC_DIR/mapper.h $OUTPUT_SRC_DIR/mapper.h
mkdir -p $OUTPUT_SRC_DIR/mapper
find $SRC_DIR/libmapper/include -name "*.h" -exec cp -prv {} $OUTPUT_SRC_DIR/mapper/ ";"
mkdir -p $OUTPUT_SRC_DIR/lo
find $SRC_DIR/liblo/lo -name "*.h" -exec cp -prv {} $OUTPUT_SRC_DIR/lo/ ";"
