BIN_DIR = bin
BUILD_DIR = build

all: wifi

wifi:
	./build.sh

clean:
	rm -rf $(BIN_DIR)
	rm -rf $(BUILD_DIR)

.PHONY: wifi all clean
