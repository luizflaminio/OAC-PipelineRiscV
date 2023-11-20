library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regFileIF_ID is
    port (
        clk, reset, en : in  std_logic;
        RD             : in  std_logic_vector(31 downto 0);
        PC, PCPlus4F   : in  std_logic_vector(31 downto 0);
        InstrD         : out std_logic_vector(31 downto 0);
        PCD, PCPlus4D  : out std_logic_vector(31 downto 0)
    );
end entity regFileIF_ID;

architecture arch_regF of regFileIF_ID is
    component flopenr
        generic(width: integer);
        port(
            clk, reset, en  : in  std_logic;
            d               : in  std_logic_vector(width-1 downto 0);
            q               : out std_logic_vector(width-1 downto 0));
    end component;
begin
    regRdF      : flopenr generic map(32) port map(clk, reset, en, RD, InstrD);
    regPCF      : flopenr generic map(32) port map(clk, reset, en, PC, PCD);
    regPCPlus4F : flopenr generic map(32) port map(clk, reset, en, PCPlus4F, PCPlus4D);
    
end architecture arch_regF;