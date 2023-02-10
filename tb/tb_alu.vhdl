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
