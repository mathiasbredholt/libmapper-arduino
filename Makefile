COMPILER_PATH := $(HOME)/Library/Arduino15/packages/esp32/tools/xtensa-esp32-elf-gcc/1.22.0-80-g6c4433a-5.2.0/bin
SDK := $(HOME)/Library/Arduino15/packages/esp32/hardware/esp32/1.0.4/tools/sdk
SDK_INCLUDE := $(SDK)/include
CC := $(COMPILER_PATH)/xtensa-esp32-elf-gcc
AR := $(COMPILER_PATH)/xtensa-esp32-elf-ar

BUILD_DIR := ./build
OUTPUT_DIR := $(BUILD_DIR)/Arduino/libmapper
OUTPUT_SRC_DIR := $(OUTPUT_DIR)/src
OUTPUT_LIB_DIR := $(OUTPUT_SRC_DIR)/esp32

INCLUDES := -I"$(SDK_INCLUDE)/config" -I"$(SDK_INCLUDE)/app_trace" -I"$(SDK_INCLUDE)/app_update" -I"$(SDK_INCLUDE)/asio" -I"$(SDK_INCLUDE)/bootloader_support" -I"$(SDK_INCLUDE)/bt" -I"$(SDK_INCLUDE)/coap" -I"$(SDK_INCLUDE)/console" -I"$(SDK_INCLUDE)/driver" -I"$(SDK_INCLUDE)/esp-tls" -I"$(SDK_INCLUDE)/esp32" -I"$(SDK_INCLUDE)/esp_adc_cal" -I"$(SDK_INCLUDE)/esp_event" -I"$(SDK_INCLUDE)/esp_http_client" -I"$(SDK_INCLUDE)/esp_http_server" -I"$(SDK_INCLUDE)/esp_https_ota" -I"$(SDK_INCLUDE)/esp_ringbuf" -I"$(SDK_INCLUDE)/ethernet" -I"$(SDK_INCLUDE)/expat" -I"$(SDK_INCLUDE)/fatfs" -I"$(SDK_INCLUDE)/freemodbus" -I"$(SDK_INCLUDE)/freertos" -I"$(SDK_INCLUDE)/heap" -I"$(SDK_INCLUDE)/idf_test" -I"$(SDK_INCLUDE)/jsmn" -I"$(SDK_INCLUDE)/json" -I"$(SDK_INCLUDE)/libsodium" -I"$(SDK_INCLUDE)/log" -I"$(SDK_INCLUDE)/lwip" -I"$(SDK_INCLUDE)/mbedtls" -I"$(SDK_INCLUDE)/mdns" -I"$(SDK_INCLUDE)/micro-ecc" -I"$(SDK_INCLUDE)/mqtt" -I"$(SDK_INCLUDE)/newlib" -I"$(SDK_INCLUDE)/nghttp" -I"$(SDK_INCLUDE)/nvs_flash" -I"$(SDK_INCLUDE)/openssl" -I"$(SDK_INCLUDE)/protobuf-c" -I"$(SDK_INCLUDE)/protocomm" -I"$(SDK_INCLUDE)/pthread" -I"$(SDK_INCLUDE)/sdmmc" -I"$(SDK_INCLUDE)/smartconfig_ack" -I"$(SDK_INCLUDE)/soc" -I"$(SDK_INCLUDE)/spi_flash" -I"$(SDK_INCLUDE)/spiffs" -I"$(SDK_INCLUDE)/tcp_transport" -I"$(SDK_INCLUDE)/tcpip_adapter" -I"$(SDK_INCLUDE)/ulp" -I"$(SDK_INCLUDE)/vfs" -I"$(SDK_INCLUDE)/wear_levelling" -I"$(SDK_INCLUDE)/wifi_provisioning" -I"$(SDK_INCLUDE)/wpa_supplicant" -I"$(SDK_INCLUDE)/xtensa-debug-module" -I"$(SDK_INCLUDE)/esp-face" -I"$(SDK_INCLUDE)/esp32-camera" -I"$(SDK_INCLUDE)/esp-face" -I"$(SDK_INCLUDE)/fb_gfx"
WARNING_FLAGS := -w -Wpointer-arith -Wno-maybe-uninitialized -Wno-unused-function -Wno-unused-but-set-variable -Wno-unused-variable -Wno-deprecated-declarations -Wno-unused-parameter -Wno-sign-compare -Wno-old-style-declaration
CFLAGS := -DESP_PLATFORM -DMBEDTLS_CONFIG_FILE="mbedtls/esp_config.h" -DHAVE_CONFIG_H -DGCC_NOT_5_2_0=0 -DWITH_POSIX -std=gnu99 -Os -g3 -fstack-protector -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib $(WARNING_FLAGS) -MMD -c

# Compat lib
COMPAT_SRCS_DIR := ./compat/src
COMPAT_INCLUDE_DIR := compat/include
COMPAT_FLAGS := $(CFLAGS) -I$(COMPAT_INCLUDE_DIR) $(INCLUDES)
COMPAT_OBJ_DIR := $(BUILD_DIR)/compat
COMPAT_OBJS := $(addprefix $(COMPAT_OBJ_DIR)/,gai_strerror.o gethostname.o getnameinfo.o ifaddrs.o)

# zlib
ZLIB_SRCS_DIR := ./zlib
ZLIB_INCLUDE_DIR := ./zlib
ZLIB_FLAGS := $(CFLAGS) $(INCLUDES)
ZLIB_OBJ_DIR := $(BUILD_DIR)/zlib
ZLIB_OBJS := $(addprefix $(ZLIB_OBJ_DIR)/,crc32.o)

# liblo
LIBLO_SRCS_DIR := ./liblo/src
LIBLO_INCLUDE_DIR := ./liblo
LIBLO_FLAGS := $(CFLAGS) -include $(COMPAT_INCLUDE_DIR)/compat.h -I$(LIBLO_INCLUDE_DIR) -I$(COMPAT_INCLUDE_DIR) $(INCLUDES)
LIBLO_OBJ_DIR := $(BUILD_DIR)/liblo
LIBLO_OBJS := $(addprefix $(LIBLO_OBJ_DIR)/,address.o blob.o bundle.o message.o method.o pattern_match.o send.o server.o server_thread.o timetag.o version.o)
LIBLO_CONFIGURED := $(shell [ -f liblo/config.h ] && echo "TRUE" || echo "FALSE")

# libmapper
LIBMAPPER_SRCS_DIR := ./libmapper/src
LIBMAPPER_INCLUDE_DIR := ./libmapper/include
LIBMAPPER_FLAGS := $(CFLAGS) -include $(COMPAT_INCLUDE_DIR)/compat.h -I$(LIBMAPPER_INCLUDE_DIR) -I$(COMPAT_INCLUDE_DIR) -I$(LIBLO_INCLUDE_DIR) -I$(ZLIB_INCLUDE_DIR) $(INCLUDES)
LIBMAPPER_OBJ_DIR := $(BUILD_DIR)/libmapper
LIBMAPPER_OBJS := $(addprefix $(LIBMAPPER_OBJ_DIR)/,database.o device.o expression.o link.o list.o map.o network.o properties.o router.o signal.o slot.o table.o timetag.o)
LIBMAPPER_CONFIGURED := $(shell [ -f libmapper/src/config.h ] && echo "TRUE" || echo "FALSE")

$(COMPAT_OBJ_DIR)/%.o : $(COMPAT_SRCS_DIR)/%.c
	@echo Building $<
	@$(CC) $(COMPAT_FLAGS) -c $< -o $@

$(ZLIB_OBJ_DIR)/%.o : $(ZLIB_SRCS_DIR)/%.c
	@echo Building $<
	@$(CC) $(ZLIB_FLAGS) -c $< -o $@

$(LIBLO_OBJ_DIR)/%.o : $(LIBLO_SRCS_DIR)/%.c
	@echo Building $<
	@$(CC) $(LIBLO_FLAGS) -c $< -o $@

$(LIBMAPPER_OBJ_DIR)/%.o : $(LIBMAPPER_SRCS_DIR)/%.c
	@echo Building $<
	@$(CC) $(LIBMAPPER_FLAGS) -c $< -o $@

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