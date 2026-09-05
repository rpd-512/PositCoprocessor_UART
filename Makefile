VERILATOR = verilator

RTL = rtl/coprocessor.sv \
      rtl/uart_head.sv \
      rtl/posit_arithmetic.sv

CPP = serial_virtual/vserial_bridge.cpp

TARGET = vserial_bridge

all:
	$(VERILATOR) -Wall \
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