# Makefile
# Author: Carlos Henrique Craveiro Aquino Veras
# License: GPL v2
# Purpose: Automate the compile and simulate processes of a simple ALU model written in VHDL language

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

GHDL = ghdl

all: compile simulate

# Compile the libraries, source code and then the test_bench
compile:
	$(GHDL) -a --work=utils lib/utils.vhdl
	$(GHDL) -a src/alu.vhdl
	$(GHDL) -a tb/tb_alu.vhdl	

# Run the simulaion without dumping the signals to a vcd file
simulate:
	$(GHDL) -e tb_alu

# Run the simulaion dumping the signals to a vcd file named tb_alu.vcd
dump: compile
	$(GHDL) -r tb_alu --vcd=tb_alu.vcd

# Sugestion: you can open the .vcd file with softwares like Gtkwave

clear:
	rm -rf *.cf
	rm -rf *.vcd
