library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- library declaration
library utils;

-- package declaration
package debug is
  -- declaration of constants, signals, variables, functions, procedures, etc.
  function reverse(str : string) return string;
 
	function to_string(slv : std_logic_vector) return string;
end package;

-- package body definition
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
