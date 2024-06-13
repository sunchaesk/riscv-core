VERILOG_COMPILER:= iverilog
EXEC_F := exe
# SRCS := $(wildcard *.v) $(wildcard */*.v)
SRCS := $(wildcard *.v)
TEST ?= test/alu_tb.v


# iverilog flags
GENERATION_FLAG := -g2012
WARNING_FLAG := -Wall -Wno-timescale
INCLUDE_FLAG := -I test/

# tcl / gtkwave
GFLAGS := -S gtkwave.tcl

all: $(SRCS) $(TEST)
	$(VERILOG_COMPILER) $(GENERATION_FLAG) $(WARNING_FLAG) -o $(EXEC_F) $(SRCS) $(TEST) $(INCLUDE_FLAG)
	vvp $(EXEC_F)
	gtkwave $(GFLAGS) $(EXEC_F).vcd

# co stands for: "compilation only" -> no gtkwave simulation
co: $(SRCS)
	$(VERILOG_COMPILER) $(GENERATION_FLAG) $(WARNING_FLAG) -o $(EXEC_F) $(SRCS)
	vvp $(EXEC_F)

clean:
	rm -f *.vcd.pdf
	rm -f *.vcd
	rm -f $(EXEC_F)

.PHONY: clean co
