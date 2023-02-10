 VHDL Study Notes

# Pages Summary

- Getting started!! (This page)

- Entity’s definition and behavior

- Unit Test - The test-bench approach

- Writing a Library

# Getting started!

## Introduction

VHDL stands for VHSIC Hardware Description Language. It's a special kind of computer language used to describe and model digital circuits and systems. It was developed in the 1980s by the U.S. government to help people design and verify digital circuits before building them. Nowadays, it's a popular and widely used standard in the field of digital electronics. With VHDL, you can make sure your digital designs will work as intended before you actually build them!

## Making a simple ALU

```vhdl
-- alu.vhdl
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-- Entity definition
entity simple_alu is
	port (
		a : in std_logic_vector (3 downto 0);
		b : in std_logic_vector (3 downto 0);
		op : in std_logic_vector (1 downto 0);
		result : out std_logic_vector (3 downto 0)
	);
end simple_alu;

-- Architecture definition
architecture behavioral of simple_alu is
begin
	-- ALU operation
	process(a, b, op)
	begin
		case op is
			-- Addition - 00
			when "00" => result <= std_logic_vector(unsigned(a) + unsigned(b));
			-- Subtraction - 01
			when "01" => result <= std_logic_vector(unsigned(a) - unsigned(b));
			-- Logical AND - 10
			when "10" => result <= a and b;	
			-- Logical OR - 11
			when others => result <= a or b;
		end case;
	end process;
end behavioral;
```

## Project suggested directory organization

```bash
.
├── lib
│   └── utils.vhdl
├── Makefile
├── README.md
├── src
│   └── alu.vhdl
└── tb
    └── tb_alu.vhdl
```

- **`README.md`**: a file to document the project, including the purpose of the project, how to run the simulations, etc.
- **`Makefile`**: a file used to automate the compile and simulation processes of the project. It can be replaced with a simple shell script, depending on the project requirements and the preferences of the developer.
- **`src`**: a directory to store the main VHDL source files. In this directory, you can store the entities of your digital circuits.
- **`tb`**: a directory to store the test-benches for each entity in the **`src`** directory.

You can also include a **`scripts`** directory to store scripts to compile and run the simulations, a **`results`** directory to store the simulation outputs, and so on, based on the size and complexity of your project.

## Compile process and its tools

```bash
ghdl -a <file_name>.vhdl
```

## Writing a simple test bench

```vhdl
-- tb_alu.tb
-- Import libraries
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-- Custom library
library utils;
use utils.debug.all;

-- Entity definition
entity tb_alu is
end tb_alu;

-- Architecture definition
architecture behavioral of tb_alu is
  signal a: std_logic_vector(3 downto 0);
  signal b: std_logic_vector(3 downto 0);
  signal op: std_logic_vector(1 downto 0);
	signal result: std_logic_vector(3 downto 0);
 
  -- Component declaration of the entity to be tested
  component simple_alu is
    port (
      a: in std_logic_vector(3 downto 0);
      b: in std_logic_vector(3 downto 0);
      op: in std_logic_vector(1 downto 0);
      result : out std_logic_vector(3 downto 0)
    );
  end component;

begin
  -- Instantiate the component being tested
  DUT: simple_alu port map (
    a => a,
    b => b,
    op => op,
    result => result
  );

	-- Test if the operations are working acording to expected
  process is
  begin
    
		-- Addition operation - 00
    a <= "1010";
    b <= "0010";
    op <= "00";
    wait for 10 ns;
    assert result = "1100" report "Test failed: incorrect output value. Expected 1100, but got " & to_string(result) severity failure;
    
		-- Subtraction operation - 01
    op <= "01";
    wait for 10 ns;
    assert result = "1000" report "Test failed: incorrect output value. Expected 1000, but got " & to_string(result) severity failure;

    -- And operation - 10
    op <= "10";
    wait for 10 ns;
    assert result = "0010" report "Test failed: incorrect output value. Expected 0010, but got " & to_string(result) severity failure;
	
		-- Or operation - 11
		a <= "1010";
    b <= "0001";
    op <= "00";	
		wait for 10 ns;
    assert result = "1011" report "Test failed: incorrect output value. Expected 1011, but got " & to_string(result) severity failure;
    
		-- End the simulation
    wait;
  end process;

end behavioral;
```

## A simple library

```vhdl
-- utils.vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Library declaration
library utils;

-- Package declaration
package debug is
  -- Declaration of constants, signals, variables, functions, procedures, etc.
  function reverse(str : string) return string;
 
	function to_string(slv : std_logic_vector) return string;
end package;

-- Package body definition
package body debug is
  function reverse(str : string) return string is
    variable result : string(1 to str'length);
  begin
    for i in str'range loop
      result(str'length - i + 1) := str(i);
    end loop;
    return result;
  end function;

function to_string(slv : std_logic_vector) return string is
  variable result : string(1 to slv'length);
  variable temp : integer;
begin
  temp := to_integer(unsigned(slv));
  for i in 0 to slv'length-1 loop
    result(i+1) := character'val(temp mod 10 + 48);
    temp := temp / 10;
  end loop;
  return reverse(result);
end function;
end package body;
```

## Simulating and dealing with logs

```makefile
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
```

## Conclusion
