library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flopr is

  generic(width: integer);
  port(
    clk, reset  : in  STD_LOGIC;
    d           :  in  STD_LOGIC_VECTOR(width-1 downto 0);
    q           :  out STD_LOGIC_VECTOR(width-1 downto 0));
end;
architecture asynchronous of flopr is

begin
  process(clk, reset) begin
    if reset = '1' then  q <= (others => '0');
    elsif rising_edge(clk) then q <= d;
    end if;
  end process;
end;