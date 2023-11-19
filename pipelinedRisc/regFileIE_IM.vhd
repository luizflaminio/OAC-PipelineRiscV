-- 4 registradores
-- ALUResult, WriteDataE, RdE, PCPlus4E
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regFileIE_IM is
    port (
        clk, reset, en : in  std_logic;
        RegWriteE, MemWriteE    : in  std_logic; 
        ResultScrE              : in  std_logic_vector(1 downto 0);
        ALUResultE, WriteDataE  : in  std_logic_vector(31 downto 0);
        RdE                     : in  std_logic_vector(4 downto 0);
        PCPlus4E                : in  std_logic_vector(31 downto 0);
        RegWriteM, MemWriteM    : out std_logic; 
        ResultScrM              : out std_logic_vector(1 downto 0); 
        ALUResultM, WriteDataM  : out std_logic_vector(31 downto 0);
        RdM                     : out std_logic_vector(4 downto 0);
        PCPlus4M                : out std_logic_vector(31 downto 0)    
    );
end entity regFileIE_IM;

architecture arch_regE of regFileIE_IM is
    component flopenr
        generic(width: integer);
        port(
            clk, reset, en  : in  std_logic;
            d               : in  std_logic_vector(width-1 downto 0);
            q               : out std_logic_vector(width-1 downto 0));
    end component;
begin

    -- sinais do datapath
    regRdE      : flopenr generic(32) port map(clk, reset, en, RdE, RdM);
    regResultE  : flopenr generic(32) port map(clk, reset, en, ALUResultD, ALUResultM);
    regPCPlus4E : flopenr generic(32) port map(clk, reset, en, PCPlus4E, PCPlus4M);
    regWriteDtE : flopenr generic(32) port map(clk, reset, en, WriteDataE, WriteDataM);

    --sinais da UC
    regWriteE       : flopenr generic(32) port map(clk, reset, en, RegWriteE, RegWriteM);
    regResultE      : flopenr generic(32) port map(clk, reset, en, ResultScrE, ResultScrM);
    regMemWriteE    : flopenr generic(32) port map(clk, reset, en, MemWriteE, MemWriteM);
        
    
end architecture arch_regE