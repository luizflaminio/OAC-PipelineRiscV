library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regFileID_IE is
    port (
        clk, reset, en : in  std_logic;
        RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD : in  std_logic; 
        ResultScrD                                    : in  std_logic_vector(1 downto 0);
        ALUControlD                                   : in  std_logic_vector(2 downto 0);
        RD1, RD2, PCD, PCPlus4D, ImmExtD              : in  std_logic_vector(31 downto 0);
        RdD                                           : in  std_logic_vector(4 downto 0);
        RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE : out std_logic; 
        ResultScrE                                    : out std_logic_vector(1 downto 0);
        RD1E, RD2E, PCE, PCPlus4E, ImmExtE            : out std_logic_vector(31 downto 0);
        ALUControlE                                   : out std_logic_vector(2 downto 0);
        RdE                                           : out std_logic_vector(4 downto 0)
    );
end entity regFileID_IE;

architecture arch_regD of regFileID_IE is
    component flopenr
        generic(width: integer);
        port(
            clk, reset, en  : in  std_logic;
            d               : in  STD_LOGIC_VECTOR(width-1 downto 0);
            q               : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
begin
    
    -- sinais do datapath
    regRd1D     : flopenr generic(32) port map(clk, reset, en, RD1, RD1E);
    regRd2D     : flopenr generic(32) port map(clk, reset, en, RD2, RD2E);
    regPCD      : flopenr generic(32) port map(clk, reset, en, PCD, PCE);
    regRdD      : flopenr generic(32) port map(clk, reset, en, RdD, RdE);
    regImmExtD  : flopenr generic(32) port map(clk, reset, en, immExtD, immExtE);
    regPCPlus4D : flopenr generic(32) port map(clk, reset, en, PCPlus4D, PCPlus4E);
    
    --sinais da UC
    regWriteD       : flopenr generic(32) port map(clk, reset, en, RegWriteD, RegWriteE);
    regResultD      : flopenr generic(32) port map(clk, reset, en, ResultScrD, ResultScrE);
    regMemWriteD    : flopenr generic(32) port map(clk, reset, en, MemWriteD, MemWriteE);
    regJumpD        : flopenr generic(32) port map(clk, reset, en, JumpD, JumpE);
    regBranchD      : flopenr generic(32) port map(clk, reset, en, BranchD, BranchE);
    regAluControlD  : flopenr generic(32) port map(clk, reset, en, ALUControlD, ALUControlE);
    refAluSrcD      : flopenr generic(32) port map(clk, reset, en, ALUSrcD, ALUSrcE);
    
end architecture arch_regD