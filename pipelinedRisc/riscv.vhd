library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscvsingle is
 port(
    clk, reset              : in  STD_LOGIC;
    PC                      : out STD_LOGIC_VECTOR(31 downto 0);
    Instr                   : in  STD_LOGIC_VECTOR(31 downto 0);
    MemWrite                : out STD_LOGIC;
    ALUResult, WriteData    : out STD_LOGIC_VECTOR(31 downto 0);
    ReadData                : in  STD_LOGIC_VECTOR(31 downto 0));

end;

architecture struct of riscvsingle is
    component controller
    port( 
        op              : in  STD_LOGIC_VECTOR(6 downto 0);
        funct3          : in  STD_LOGIC_VECTOR(2 downto 0);
        funct7b5, Zero  : in  STD_LOGIC;
        ResultSrc       : out STD_LOGIC_VECTOR(1 downto 0);
        MemWrite        : out STD_LOGIC;
        PCSrc, ALUSrc   : out STD_LOGIC;
        RegWrite, Jump  : out STD_LOGIC;
        ImmSrc          : out STD_LOGIC_VECTOR(1 downto 0);
        ALUControl      : out STD_LOGIC_VECTOR(2 downto 0));

        end component;

    component datapath

    port(
        clk, reset              : in STD_LOGIC;
        ResultSrcD              : in STD_LOGIC_VECTOR(1  downto 0);
        PCSrc, ALUSrcD          : in STD_LOGIC;
        RegWriteD               : in STD_LOGIC;
        ImmSrcD                 : in STD_LOGIC_VECTOR(1  downto 0);
        ALUControlD             : in STD_LOGIC_VECTOR(2  downto 0);
        Zero                    : out STD_LOGIC;
        PC                      : out STD_LOGIC_VECTOR(31 downto 0);
        RD                      : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUResult, WriteData    : out STD_LOGIC_VECTOR(31 downto 0);
        ReadData                : in  STD_LOGIC_VECTOR(31 downto 0);
        instrD                  : out STD_LOGIC_VECTOR(31 downto 0);    
        MemWriteD               : in  std_logic_vector(0 downto 0); 
        JumpD, BranchD          : in  std_logic_vector(0 downto 0);
        MemWriteM               : out std_logic);
    end component;

    signal ALUSrcD, RegWriteD, JumpD, Zero, PCSrc : STD_LOGIC;
    signal ResultSrcD, ImmSrcD : STD_LOGIC_VECTOR(1 downto 0);
    signal ALUControlD : STD_LOGIC_VECTOR(2 downto 0);
    signal instrucaoD : STD_LOGIC_VECTOR(31 downto 0);

begin

    c: controller port map(
        instrucaoD(6 downto 0), instrucaoD(14 downto 12),
        instrucaoD(30), Zero, ResultSrcD, MemWriteD,
        PCSrc, ALUSrcD, RegWriteD, JumpD, 
        ImmSrcD, ALUControlD, 
    );

    dp: datapath port map(
        clk, reset, ResultSrcD, PCSrc, ALUSrcD,
        RegWriteD, ImmSrcD, ALUControlD, Zero,
        PC, Instr, ALUResult, WriteData,
        ReadData, instrucaoD, MemWriteD, JumpD, BranchD, MemWrite
    );

end;