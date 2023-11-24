library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regFileID_IE is
    port (
        clk, reset, en : in  std_logic;
        RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD : in  std_logic_vector(0 downto 0); 
        ResultSrcD                                    : in  std_logic_vector(1 downto 0);
        ALUControlD                                   : in  std_logic_vector(2 downto 0);
        RD1, RD2, PCD, PCPlus4D, ImmExtD              : in  std_logic_vector(31 downto 0);
        RdD, Rs1D, Rs2D                               : in  std_logic_vector(4 downto 0);
        RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE : out std_logic_vector(0 downto 0); 
        ResultSrcE                                    : out std_logic_vector(1 downto 0);
        RD1E, RD2E, PCE, PCPlus4E, ImmExtE            : out std_logic_vector(31 downto 0);
        ALUControlE                                   : out std_logic_vector(2 downto 0);
        RdE, Rs1E, Rs2E                               : out std_logic_vector(4 downto 0)
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
    regRd1D     : flopenr generic map(32) port map(clk, reset, en, RD1, RD1E);
    regRd2D     : flopenr generic map(32) port map(clk, reset, en, RD2, RD2E);
    regRs1D     : flopenr generic map(5) port map(clk, reset, en, Rs1D, Rs1E);
    regRs2D     : flopenr generic map(5) port map(clk, reset, en, Rs2D, Rs2E);
    regPCD      : flopenr generic map(32) port map(clk, reset, en, PCD, PCE);
    regRdD      : flopenr generic map(5) port map(clk, reset, en, RdD, RdE);
    regImmExtD  : flopenr generic map(32) port map(clk, reset, en, immExtD, immExtE);
    regPCPlus4D : flopenr generic map(32) port map(clk, reset, en, PCPlus4D, PCPlus4E);
    
    --sinais da UC
    reg_regWriteD       : flopenr generic map(1) port map(clk, reset, en, RegWriteD, RegWriteE);
    regResultD      : flopenr generic map(2) port map(clk, reset, en, ResultSrcD, ResultSrcE);
    regMemWriteD    : flopenr generic map(1) port map(clk, reset, en, MemWriteD, MemWriteE);
    regJumpD        : flopenr generic map(1) port map(clk, reset, en, JumpD, JumpE);
    regBranchD      : flopenr generic map(1) port map(clk, reset, en, BranchD, BranchE);
    regAluControlD  : flopenr generic map(3) port map(clk, reset, en, ALUControlD, ALUControlE);
    refAluSrcD      : flopenr generic map(1) port map(clk, reset, en, ALUSrcD, ALUSrcE);
    
end architecture arch_regD;