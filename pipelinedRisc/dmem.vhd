library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.TEXTIO.all;
use ieee.std_logic_textio.all;

entity dmem is
    port(
        clk, we: in STD_LOGIC;
        a, wd: in STD_LOGIC_VECTOR(31 downto 0);
        rd: out STD_LOGIC_VECTOR(31 downto 0)   
    );
end;



architecture behave of dmem is
    type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem : ramtype;

    begin
        wrt: process(clk)
        begin
          if (clk='1' and clk'event) then
            if (we='1') then
              mem(to_integer(unsigned(a))) <= wd;
            end if;
          end if;
        end process;
        rd <= mem(to_integer(unsigned(a)));
end;