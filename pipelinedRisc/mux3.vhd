library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux3 is
    generic(width: integer := 8);
    port(
        d0, d1, d2  : in  STD_LOGIC_VECTOR(width-1 downto 0);
        s           :  in  STD_LOGIC_VECTOR(1 downto 0);
        y           :  out STD_LOGIC_VECTOR(width-1 downto 0));
end;
architecture behave of mux3 is

begin
  with s select
		y <= d0 when "00",
			  d1 when "01",
		     d2 when "10",
		     (others => '0') when others;
end;