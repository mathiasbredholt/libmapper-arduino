COMPILER_PATH := $(HOME)/Library/Arduino15/packages/esp32/tools/xtensa-esp32-elf-gcc/1.22.0-80-g6c4433a-5.2.0/bin
SDK := $(HOME)/Library/Arduino15/packages/esp32/hardware/esp32/1.0.4/tools/sdk
CC := $(COMPILER_PATH)/xtensa-esp32-elf-gcc
AR := $(COMPILER_PATH)/xtensa-esp32-elf-ar

BUILD_DIR := ./build
OUTPUT_DIR := $(BUILD_DIR)/Arduino/libmapper
OUTPUT_SRC_DIR := $(OUTPUT_DIR)/src
OUTPUT_LIB_DIR := $(OUTPUT_SRC_DIR)/esp32

INCLUDES := -I"$(SDK)/include/config" -I"$(SDK)/include/app_trace" -I"$(SDK)/include/app_update" -I"$(SDK)/include/asio" -I"$(SDK)/include/bootloader_support" -I"$(SDK)/include/bt" -I"$(SDK)/include/coap" -I"$(SDK)/include/console" -I"$(SDK)/include/driver" -I"$(SDK)/include/esp-tls" -I"$(SDK)/include/esp32" -I"$(SDK)/include/esp_adc_cal" -I"$(SDK)/include/esp_event" -I"$(SDK)/include/esp_http_client" -I"$(SDK)/include/esp_http_server" -I"$(SDK)/include/esp_https_ota" -I"$(SDK)/include/esp_ringbuf" -I"$(SDK)/include/ethernet" -I"$(SDK)/include/expat" -I"$(SDK)/include/fatfs" -I"$(SDK)/include/freemodbus" -I"$(SDK)/include/freertos" -I"$(SDK)/include/heap" -I"$(SDK)/include/idf_test" -I"$(SDK)/include/jsmn" -I"$(SDK)/include/json" -I"$(SDK)/include/libsodium" -I"$(SDK)/include/log" -I"$(SDK)/include/lwip" -I"$(SDK)/include/mbedtls" -I"$(SDK)/include/mdns" -I"$(SDK)/include/micro-ecc" -I"$(SDK)/include/mqtt" -I"$(SDK)/include/newlib" -I"$(SDK)/include/nghttp" -I"$(SDK)/include/nvs_flash" -I"$(SDK)/include/openssl" -I"$(SDK)/include/protobuf-c" -I"$(SDK)/include/protocomm" -I"$(SDK)/include/pthread" -I"$(SDK)/include/sdmmc" -I"$(SDK)/include/smartconfig_ack" -I"$(SDK)/include/soc" -I"$(SDK)/include/spi_flash" -I"$(SDK)/include/spiffs" -I"$(SDK)/include/tcp_transport" -I"$(SDK)/include/tcpip_adapter" -I"$(SDK)/include/ulp" -I"$(SDK)/include/vfs" -I"$(SDK)/include/wear_levelling" -I"$(SDK)/include/wifi_provisioning" -I"$(SDK)/include/wpa_supplicant" -I"$(SDK)/include/xtensa-debug-module" -I"$(SDK)/include/esp-face" -I"$(SDK)/include/esp32-camera" -I"$(SDK)/include/esp-face" -I"$(SDK)/include/fb_gfx"
WARNING_FLAGS := -w -Wpointer-arith -Wno-maybe-uninitialized -Wno-unused-function -Wno-unused-but-set-variable -Wno-unused-variable -Wno-deprecated-declarations -Wno-unused-parameter -Wno-sign-compare -Wno-old-style-declaration
CFLAGS := -DESP_PLATFORM -DMBEDTLS_CONFIG_FILE="mbedtls/esp_config.h" -DHAVE_CONFIG_H -DGCC_NOT_5_2_0=0 -DWITH_POSIX -std=gnu99 -Os -g3 -fstack-protector -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib $(WARNING_FLAGS) -MMD -c

# Compat lib
COMPAT_SRCS_DIR := compat/src
COMPAT_INCLUDE_DIR := compat/include
COMPAT_FLAGS := -I$(COMPAT_INCLUDE_DIR) $(INCLUDES)
COMPAT_OBJ_DIR := $(BUILD_DIR)/compat
COMPAT_OBJS := $(addprefix $(COMPAT_OBJ_DIR)/,gai_strerror.o gethostname.o getnameinfo.o ifaddrs.o)

# zlib
ZLIB_SRCS_DIR := zlib
ZLIB_INCLUDE_DIR := zlib
ZLIB_FLAGS := $(INCLUDES)
ZLIB_OBJ_DIR := $(BUILD_DIR)/zlib
ZLIB_OBJS := $(addprefix $(ZLIB_OBJ_DIR)/,crc32.o)

# liblo
LIBLO_SRCS_DIR := liblo/src
LIBLO_INCLUDE_DIR := liblo
LIBLO_FLAGS := -include $(COMPAT_INCLUDE_DIR)/compat.h -I$(LIBLO_INCLUDE_DIR) -I$(COMPAT_INCLUDE_DIR) $(INCLUDES)
LIBLO_OBJ_DIR := $(BUILD_DIR)/liblo
LIBLO_OBJS := $(addprefix $(LIBLO_OBJ_DIR)/,address.o blob.o bundle.o message.o method.o pattern_match.o send.o server.o server_thread.o timetag.o version.o)
LIBLO_CONFIGURED := $(shell [ -f liblo/config.h ] && echo "TRUE" || echo "FALSE")

# libmapper
LIBMAPPER_SRCS_DIR := libmapper/src
LIBMAPPER_INCLUDE_DIR := libmapper/include
LIBMAPPER_FLAGS := -include $(COMPAT_INCLUDE_DIR)/compat.h -I$(LIBMAPPER_INCLUDE_DIR) -I$(COMPAT_INCLUDE_DIR) -I$(LIBLO_INCLUDE_DIR) -I$(ZLIB_INCLUDE_DIR) $(INCLUDES)
LIBMAPPER_OBJ_DIR := $(BUILD_DIR)/libmapper
LIBMAPPER_OBJS := $(addprefix $(LIBMAPPER_OBJ_DIR)/,database.o device.o expression.o link.o list.o map.o network.o properties.o router.o signal.o slot.o table.o timetag.o)
LIBMAPPER_CONFIGURED := $(shell [ -f libmapper/src/config.h ] && echo "TRUE" || echo "FALSE")


$(COMPAT_OBJ_DIR)/%.o : $(COMPAT_SRCS_DIR)/%.c
	@echo Building $<
	@$(CC) $(CFLAGS) $(COMPAT_FLAGS) -c $< -o $@

$(ZLIB_OBJ_DIR)/%.o : $(ZLIB_SRCS_DIR)/%.c
	@echo Building $<
	@$(CC) $(CFLAGS) $(ZLIB_FLAGS) -c $< -o $@

$(LIBLO_OBJ_DIR)/%.o : $(LIBLO_SRCS_DIR)/%.c
	@echo Building $<
	@$(CC) $(CFLAGS) $(LIBLO_FLAGS) -c $< -o $@

$(LIBMAPPER_OBJ_DIR)/%.o : $(LIBMAPPER_SRCS_DIR)/%.c
	@echo Building $<
	@$(CC) $(CFLAGS) $(LIBMAPPER_FLAGS) -c $< -o $@

all: $(COMPAT_OBJS) $(ZLIB_OBJS) $(LIBLO_OBJS) $(LIBMAPPER_OBJS)
	@mkdir -p $(OUTPUT_LIB_DIR)
	@echo Linking $(OUTPUT_LIB_DIR)/libmapper.a
	@$(AR) cru $(OUTPUT_LIB_DIR)/libmapper.a $^
	cp library.properties $(OUTPUT_DIR)/library.properties
	cp -R examples $(OUTPUT_DIR)
	cp mapper.h $(OUTPUT_SRC_DIR)/mapper.h
	mkdir -p $(OUTPUT_SRC_DIR)/mapper
	find $(LIBMAPPER_INCLUDE_DIR)/mapper -name "*.h" -exec cp -prv {} $(OUTPUT_SRC_DIR)/mapper/ ";"
	mkdir -p $(OUTPUT_SRC_DIR)/lo
	find $(LIBLO_INCLUDE_DIR)/lo -name "*.h" -exec cp -prv {} $(OUTPUT_SRC_DIR)/lo/ ";"

$(COMPAT_OBJS): | $(COMPAT_OBJ_DIR)

$(COMPAT_OBJ_DIR):
	mkdir -p $(COMPAT_OBJ_DIR)

$(ZLIB_OBJS): | $(ZLIB_OBJ_DIR)

$(ZLIB_OBJ_DIR):
	mkdir -p $(ZLIB_OBJ_DIR)

$(LIBLO_OBJS): | $(LIBLO_OBJ_DIR) configure-liblo

$(LIBLO_OBJ_DIR):
	mkdir -p $(LIBLO_OBJ_DIR)

$(LIBMAPPER_OBJS): | $(LIBMAPPER_OBJ_DIR) configure-libmapper

$(LIBMAPPER_OBJ_DIR):
	mkdir -p $(LIBMAPPER_OBJ_DIR)

.PHONY: configure-liblo
configure-liblo:
ifeq ($(LIBLO_CONFIGURED), TRUE)
	@echo liblo: config.h was found
else
	@echo Configuring liblo...
	@cd liblo && ./autogen.sh
endif

.PHONY: configure-libmapper
configure-libmapper:
ifeq ($(LIBMAPPER_CONFIGURED), TRUE)
	@echo libmapper: config.h was found
else
	@echo Configuring libmapper...
	@cd libmapper && ./autogen.sh
endif

.PHONY : clean
clean :
	-rm $(COMPAT_OBJS) $(ZLIB_OBJS) $(LIBLO_OBJS) $(LIBMAPPER_OBJS) 

# LO = liblo/src
# LO_INCLUDE = liblo
# LO_FLAGS = -include $(COMPAT_INCLUDE)/compat.h -I$(LO_INCLUDE) -I$(COMPAT_INCLUDE) $(INCLUDES)
# LO_SRCS = address.c blob.c bundle.c message.c method.c pattern_match.c send.c server.c server_thread.c timetag.c version.c
# LO_OBJ = $(LO_SRCS:.c=.o)
# LO_OBJ_DIR = $(BUILD_DIR)/liblo
# LO_CONFIGURED = $(shell [ -f liblo/config.h ] && echo "TRUE" || echo "FALSE")

# $(LO_OBJ_DIR)/%.o: $(LO)/%.c 
#   @mkdir -p $(LO_OBJ_DIR)
#   @echo Building $<
#   @$(CC) $(CFLAGS) $(LO_FLAGS) -c $< -o $@

# MAPPER = libmapper/src
# MAPPER_INCLUDE = libmapper/include
# MAPPER_FLAGS = -DDEBUG -I$(COMPAT_INCLUDE) -I$(ZLIB_INCLUDE) -I$(LO_INCLUDE) -I$(MAPPER_INCLUDE) $(INCLUDES)
# MAPPER_SRCS = database.c device.c expression.c link.c list.c map.c network.c properties.c router.c signal.c slot.c table.c timetag.c
# MAPPER_OBJ = $(MAPPER_SRCS:.c=.o)
# MAPPER_OBJ_DIR = $(BUILD_DIR)/libmapper
# MAPPER_CONFIGURED = $(shell [ -f libmapper/src/config.h ] && echo "TRUE" || echo "FALSE")

# $(MAPPER_OBJ_DIR)/%.o: $(MAPPER)/%.c
#   @mkdir -p $(MAPPER_OBJ_DIR)
#   @echo Building $<
#   @$(CC) $(CFLAGS) $(MAPPER_FLAGS) $< -o $@

# .PHONY: all
# all: configure-liblo configure-libmapper libmapper_arduino
#   cp library.properties $(OUTPUT_DIR)/library.properties
#   cp -R examples $(OUTPUT_DIR)
#   cp mapper.h $(OUTPUT_SRC_DIR)/mapper.h
#   mkdir -p $(OUTPUT_SRC_DIR)/mapper
#   find $(MAPPER_INCLUDE)/mapper -name "*.h" -exec cp -prv {} $(OUTPUT_SRC_DIR)/mapper/ ";"
#   mkdir -p $(OUTPUT_SRC_DIR)/lo
#   find $(LO_INCLUDE)/lo -name "*.h" -exec cp -prv {} $(OUTPUT_SRC_DIR)/lo/ ";"

# .PHONY: configure-liblo
# .NOTPARALLEL: configure-liblo
# configure-liblo:
# ifeq ($(LO_CONFIGURED), TRUE)
#   @echo liblo: config.h was found
# else
#   @echo Configuring liblo...
#   @cd liblo && ./autogen.sh
# endif

# .PHONY: configure-libmapper
# .NOTPARALLEL: configure-libmapper
# configure-libmapper:
# ifeq ($(MAPPER_CONFIGURED), TRUE)
#   @echo libmapper: config.h was found
# else
#   @echo Configuring libmapper...
#   @cd libmapper && ./autogen.sh
# endif

# .PHONY: libmapper_arduino
# .NOTPARALLEL: libmapper_arduino
# libmapper_arduino: $(addprefix $(COMPAT_OBJ_DIR)/,$(COMPAT_OBJ)) $(addprefix $(ZLIB_OBJ_DIR)/,$(ZLIB_OBJ)) $(addprefix $(LO_OBJ_DIR)/,$(LO_OBJ)) $(addprefix $(MAPPER_OBJ_DIR)/,$(MAPPER_OBJ))
#   @mkdir -p $(OUTPUT_LIB_DIR)
#   @echo Linking $(OUTPUT_LIB_DIR)/libmapper.a
#   @$(AR) cru $(OUTPUT_LIB_DIR)/libmapper.a $^

# .PHONY: install
# install:
#   mkdir -p ~/Documents/Arduino/libraries/libmapper
#   cp -R $(OUTPUT_DIR)/. ~/Documents/Arduino/libraries/libmapper

# .PHONY: clean
# clean:
#   rm -rf $(BUILD_DIR)