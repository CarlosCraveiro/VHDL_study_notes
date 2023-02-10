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
			when "00" => result <= std_logic_vector(unsigned(a) + unsigned(b)); -- 00 - Addition
			when "01" => result <= std_logic_vector(unsigned(a) - unsigned(b)); -- 01 - Subtraction
			when "10" => result <= a and b; 																		-- 10 - Logical AND									
			when others => result <= a or b; 																		-- 11 - Logical OR
		end case;
	end process;
end behavioral;
