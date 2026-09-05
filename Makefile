VERILATOR = verilator

RTL = rtl/*

CPP = serial_virtual/vserial_bridge.cpp

TARGET = vserial_bridge

all:
	$(VERILATOR) -Wall -Wno-fatal \
		-Wno-PINCONNECTEMPTY \
		-Wno-DECLFILENAME \
		--cc --exe --build \
		--top-module coprocessor \
		-CFLAGS "-std=c++17" \
		-LDFLAGS "-lutil" \
		$(RTL) \
		$(CPP) \
		-o $(TARGET)

clean:
	rm -rf obj_dir

.PHONY: all clean