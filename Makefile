.POSIX:

CRYSTAL = /usr/local/bin/crystal
CRYSTAL_SRC = /usr/local/Cellar/crystal/0.27.2/src/
CRYSTAL_LIB = /opt/brew/lib
CRFLAGS = --release

CFLAGS := \
	'-DNODE_GYP_MODULE_NAME=binding' \
	'-DUSING_UV_SHARED=1' \
	'-DUSING_V8_SHARED=1' \
	'-DV8_DEPRECATION_WARNINGS=1' \
	'-D_DARWIN_USE_64_BIT_INODE=1' \
	'-D_LARGEFILE_SOURCE' \
	'-D_FILE_OFFSET_BITS=64' \
	'-DBUILDING_NODE_EXTENSION' \
	-Os \
	-gdwarf-2 \
	-mmacosx-version-min=10.7 \
	-arch x86_64 \
	-Wall \
	-Wendif-labels \
	-W \
	-Wno-unused-parameter \
	-fno-strict-aliasing \
	-MMD

CCFLAGS := \
	-shared \
	-undefined \
	dynamic_lookup \
	-Wl,-no_pie \
	-Wl,-search_paths_first \
	-mmacosx-version-min=10.7 \
	-arch x86_64 \
	-stdlib=libc++ \
	-init _crystal_library_init
	


INCS := \
	-I$(HOME)/.node-gyp/11.14.0/include/node \
	-I$(HOME)/.node-gyp/11.14.0/src \
	-I$(HOME)/.node-gyp/11.14.0/deps/openssl/config \
	-I$(HOME)/.node-gyp/11.14.0/deps/openssl/openssl/include \
	-I$(HOME)/.node-gyp/11.14.0/deps/uv/include \
	-I$(HOME)/.node-gyp/11.14.0/deps/zlib \
	-I$(HOME)/.node-gyp/11.14.0/deps/v8/include

PRELUDE=./crystal/prelude.cr
CRYSTAL_PATH = src:$(CRYSTAL_SRC)
LIBS = $(CRYSTAL_SRC)/ext/libcrystal.a -lgc -ldl -levent -lpcre -lpthread -liconv -ljack
LDFLAGS =  $(LIBS)

run: clean libjack2.o
	c++ $(CCFLAGS) -o build/libjack2.node build/libjack2.o $(LDFLAGS)
	node js/index.js

libjack2.o:
	$(CRYSTAL) build $(CRFLAGS) --cross-compile --prelude $(PRELUDE) -o build/libjack2 src/libjack2.cr

clean: phony
	rm -f libjack2.o *_test bc_flags

phony: