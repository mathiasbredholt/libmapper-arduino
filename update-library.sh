#!/bin/sh
cd -- "$(dirname "$BASH_SOURCE")"

SEDOPTION=
if [[ "$OSTYPE" == "darwin"* ]]; then
  SEDOPTION="''"
fi

rm -rf src
mkdir src

cp mapper.h src/mapper.h
cp mapper_cpp.h src/mapper_cpp.h

mkdir -p tmp
cd tmp

# libmapper
git clone https://github.com/mathiasbredholt/libmapper.git
cd libmapper
./autogen.sh
mkdir -p ../../src/mapper
# Include compat.h at beginning of each source file
for i in src/*.c; do sed -i $SEDOPTION '1i\
#include <compat.h>
' $i ; done
cp src/*.c ../../src/mapper
cp src/*.h ../../src/mapper
cp include/mapper/*.h ../../src/mapper
cd ..
rm -rf libmapper

# liblo
git clone https://github.com/radarsat1/liblo.git
cd liblo
./autogen.sh
mkdir -p ../../src/lo
# # Include compat.h at beginning of each source file
for i in src/*.c; do sed -i $SEDOPTION '1i\
#include <compat.h>
' $i ; done
cp src/address.c ../../src/lo
cp src/blob.c ../../src/lo
cp src/bundle.c ../../src/lo
cp src/message.c ../../src/lo
cp src/method.c ../../src/lo
cp src/pattern_match.c ../../src/lo
cp src/send.c ../../src/lo
cp src/server.c ../../src/lo
cp src/server_thread.c ../../src/lo
cp src/timetag.c ../../src/lo
cp src/version.c ../../src/lo
cp src/*.h ../../src/lo
cp *.h ../../src/lo
cp lo/*.h ../../src/lo
cd ..
rm -rf liblo

# compat-idf
git clone https://github.com/mathiasbredholt/compat-idf.git
cd compat-idf
git checkout origin/v4.0
mkdir -p ../../src/compat
cp src/*.c ../../src/compat
cp include/*.h ../../src
cp -rf include/netinet ../../src
cd ..
rm -rf compat-idf

# zlib
git clone https://github.com/madler/zlib.git
cd zlib
mkdir -p ../../src/zlib
cp crc32.c ../../src/zlib
cp crc32.h ../../src
cp zlib.h ../../src
cp zutil.h ../../src
cp zconf.h ../../src
cd ..
rm -rf zlib

cd ..

rm -rf tmp
