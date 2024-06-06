VERILOG_COMPILER:= iverilog
EXEC_F := exe
SRCS := $(wildcard *.v) $(wildcard */*.v)


# iverilog flags
GENERATION_FLAG := -g2001
WARNING_FLAG := -Wall -Wno-timescale

# tcl / gtkwave
GFLAGS := -S gtkwave.tcl

all: $(SRCS)
	$(VERILOG_COMPILER) $(GENERATION_FLAG) $(WARNING_FLAG) -o $(EXEC_F) $(SRCS)
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
