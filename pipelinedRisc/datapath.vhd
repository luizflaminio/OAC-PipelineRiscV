library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
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
    ALUResultM, WriteDataM  : out STD_LOGIC_VECTOR(31 downto 0);
    ReadDataM               : in  STD_LOGIC_VECTOR(31 downto 0);
    instrD                  : out STD_LOGIC_VECTOR(31 downto 0);    
    MemWriteD               : in  std_logic_vector(0 downto 0); 
    JumpD, BranchD          : in  std_logic_vector(0 downto 0);
    MemWriteM               : out std_logic);
end;

architecture struct of datapath is

    component flopenr 
    generic(width : integer);
    port(
        clk, reset, en  : in  STD_LOGIC;
        d               :  in  STD_LOGIC_VECTOR(width-1 downto 0);
        q               :  out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
   
    component adder
    port(
        a, b    : in  STD_LOGIC_VECTOR(31 downto 0);
        y       :  out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    
    component mux2 
    generic(width: integer);
    port(
        d0, d1  : in  STD_LOGIC_VECTOR(width-1 downto 0);
        s       : in  STD_LOGIC;
        y       : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    
    component mux3 
    generic(width: integer);
    port(
        d0, d1, d2  : in  STD_LOGIC_VECTOR(width-1 downto 0);
        s           : in  STD_LOGIC_VECTOR(1 downto 0);
        y           : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    
    component regfile
    port(
        clk         :  in  STD_LOGIC;
        we3         :  in  STD_LOGIC;
        a1, a2, a3  :  in  STD_LOGIC_VECTOR(4  downto 0);
        wd3         :  in  STD_LOGIC_VECTOR(31 downto 0);
        rd1, rd2    :  out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component extend
    port(
        instr   : in  STD_LOGIC_VECTOR(31 downto 7);
        immsrc  : in  STD_LOGIC_VECTOR(1  downto 0);
        immext  : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component alu
    port(
        a, b        :  in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl  :  in  STD_LOGIC_VECTOR(2  downto 0);
        ALUResult   :  out STD_LOGIC_VECTOR(31 downto 0);
        Zero        :  out  STD_LOGIC);
    end component;

    component hazard_unit
    port(
        Rs1E            : in std_logic_vector(4 downto 0);
        Rs2E            : in std_logic_vector(4 downto 0);
        Rs1D            : in std_logic_vector(4 downto 0);
        Rs2D            : in std_logic_vector(4 downto 0);
        RdE             : in std_logic_vector(4 downto 0); 
        RdM             : in std_logic_vector(4 downto 0); 
        RdW             : in std_logic_vector(4 downto 0); 
        RegWriteM       : in std_logic_vector(0 downto 0);
        RegWriteW       : in std_logic_vector(0 downto 0);
        ResultSrcE0     : in std_logic;
        PCSrcE          : in std_logic;
        ForwardAE       : out std_logic_vector(1 downto 0);
        ForwardBE       : out std_logic_vector(1 downto 0);
        StallF          : out std_logic;
        StallD          : out std_logic;
        FlushE          : out std_logic;
        FlushD          : out std_logic
    );
    end component;

    component regFileIF_ID 
    port (
        clk, reset, en : in  std_logic;
        RD             : in  std_logic_vector(31 downto 0);
        PC, PCPlus4F   : in  std_logic_vector(31 downto 0);
        InstrD         : out std_logic_vector(31 downto 0);
        PCD, PCPlus4D  : out std_logic_vector(31 downto 0)
    );
    end component;

    component regFileID_IE is
    port (
        clk, reset, en                                  : in  std_logic;
        RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD   : in  std_logic_vector(0 downto 0); 
        ResultScrD                                      : in  std_logic_vector(1 downto 0);
        ALUControlD                                     : in  std_logic_vector(2 downto 0);
        RD1, RD2, PCD, PCPlus4D, ImmExtD                : in  std_logic_vector(31 downto 0);
        RdD, Rs1D, Rs2D                                 : in  std_logic_vector(4 downto 0);
        RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE   : out std_logic_vector(0 downto 0); 
        ResultScrE                                      : out std_logic_vector(1 downto 0);
        RD1E, RD2E, PCE, PCPlus4E, ImmExtE              : out std_logic_vector(31 downto 0);
        ALUControlE                                     : out std_logic_vector(2 downto 0);
        RdE, Rs1E, Rs2E                                 : out std_logic_vector(4 downto 0)
    );
    end component;

    component regFileIE_IM 
        port (
            clk, reset, en          : in  std_logic;
            RegWriteE, MemWriteE    : in  std_logic_vector(0 downto 0); 
            ResultScrE              : in  std_logic_vector(1 downto 0);
            ALUResultE, WriteDataE  : in  std_logic_vector(31 downto 0);
            RdE                     : in  std_logic_vector(4 downto 0);
            PCPlus4E                : in  std_logic_vector(31 downto 0);
            RegWriteM, MemWriteM    : out std_logic_vector(0 downto 0); 
            ResultScrM              : out std_logic_vector(1 downto 0); 
            ALUResultM, WriteDataM  : out std_logic_vector(31 downto 0);
            RdM                     : out std_logic_vector(4 downto 0);
            PCPlus4M                : out std_logic_vector(31 downto 0)    
        );
    end component;

    component regFileIM_IW 
        port (
            clk, reset, en       : in  std_logic;
            RegWriteM            : in  std_logic_vector(0 downto 0); 
            ResultScrM           : in  std_logic_vector(1 downto 0);
            ALUResultM, PCPlus4M : in  std_logic_vector(31 downto 0);
            RdM                  : in  std_logic_vector(4 downto 0);
            ReadDataM            : in std_logic_vector(31 downto 0);
            RegWriteW            : out std_logic_vector(0 downto 0); 
            ResultScrW           : out std_logic_vector(1 downto 0);
            ALUResultW, PCPlus4W : out std_logic_vector(31 downto 0);
            RdW                  : out std_logic_vector(4 downto 0);
            ReadDataW            : out std_logic_vector(31 downto 0)
        );
    end component;

    signal PCNext, PCPlus4, PCTarget, s_pc, s_writeData, s_aluResult : STD_LOGIC_VECTOR(31 downto 0);
    
    -- sinais do reg ID/IE
    signal PCD, PCPlus4D : std_logic_vector(31 downto 0);

    --sinais IE/IF
    signal JumpE, BranchE, ALUSrcE, RegWriteE, MemWriteE : std_logic;
    signal ResultScrE : std_logic_vector(0 downto 0);
    signal RD1E, RD2E, PCE, PCPlus4E, ALUResultE : std_logic_vector(31 downto 0);
    signal ALUControlE : std_logic_vector(1 downto 0);

    --sinais IE/IM
    signal RegWriteM, MemWriteM : std_logic; 
    signal RD1E, RD2E, PCE, PCPlus4E, ALUResultE : std_logic_vector(31 downto 0);

    --sinais IM/IW

    --sinais da UH
    signal ImmExtD, ImmExtE:  STD_LOGIC_VECTOR(31 downto 0);
    signal RD1, RD2:, InstrD  STD_LOGIC_VECTOR(31 downto 0);
    signal ResultW:  STD_LOGIC_VECTOR(31 downto 0);
    signal ResultSrcE0, PCSrcE, StallF, StalE, FlushD, FlushE : std_logic;
    signal Rs1E, Rs1D, Rs2D, Rs2E, RdE, RdM, RdW : std_logic_vector(4 downto 0);
    signal RegWriteM, RegWriteW: std_logic_vector(0 downto 0);
    signal ForwardAE, ForwardBE: std_logic_vector(1 downto 0);
begin

    -- next PC logic - IF step
    pcreg: flopenr generic map(32) port map(clk, reset, not stallF ,PCNext, s_pc);
    pcadd4: adder port map(s_pc, X"00000004", PCPlus4);
    pcaddbranch: adder port map(PCE, ImmExtE, PCTargetE);
    pcmux: mux2 generic map(32) port map(PCPlus4, PCTarget, PCSrcE ,PCNext);

    PCSrcE <= JumpE or (BranchE and ZeroE);
    
    -- register file logic
    rf: regfile port map(clk, RegWrite, InstrD(19 downto 15), InstrD(24 downto 20), RdW,
        ResultW, RD1, RD2);
        
    ext: extend port map(InstrD(31 downto 7), ImmSrcD, ImmExtD);
    -- ALU logic
    
    srcbmux: mux2 generic map(32) port map(WriteDataE, ImmExtE, ALUSrcE, SrcBE);
    mainalu: alu port map(SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE);
    resultmux: mux3 generic map(32) port map(ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);

    --new components of pipeline
    muxSrcAE : mux3 generic map(32) port map(RD1E, ResultW, ALUResultM, ForwardAE, SrcAE);
    muxAuxSrcBE : mux3 generic map(32) port map(RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);

    --Hazard Unit
    HU : hazard_unit port map( 
        Rs1E, Rs2E, Rs1D, Rs2D, RdE, RdM, RdW, RegWriteM, RegWriteW, 
        ResultSrcE0, PCSrcE, ForwardAE, ForwardBE, StallF, StallD, FlushE, FlushD);

    -- registers of pipeline
    regIF_ID : regFileIF_ID port map(clk, FlushD, not StallD, RD, PC, PCPlus4, InstrD, PCD, PCPlus4D); 

    regID_IE : regFileID_IE port map(
        clk, FlushE, '1', RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, 
        ResultScrD, ALUControlD, RD1, RD2, PCD, PCPlus4D, ImmExtD, instrD(11 downto 7), instrD(19 downto 15), instrD(24 downto 20), RegWriteE, MemWriteE, 
        JumpE, BranchE, ALUSrcE, ResultScrE, RD1E, RD2E, PCE, PCPlus4E, ImmExtE, ALUControlE, RdE, Rs1E, Rs2E);
    
    regIE_IM : regFileIE_IM port map(
        clk, '0', '1', RegWriteE, MemWriteE, 
        ResultScrE, ALUResultE, WriteDataE, RdE, PCPlus4E, RegWriteM, MemWriteM, 
        ResultScrM, ALUResultM, WriteDataM, RdM, PCPlus4M                
    );

    regIM_IW : regFileIM_IW port map(
        clk, '0', '1', RegWriteM, 
        ResultScrM, ALUResultM, PCPlus4M, RdM, ReadDataM, RegWriteW, 
        ResultScrW, ALUResultW, PCPlus4W, RdW, ReadDataW            
    );
    
    PC <= s_pc;
    ALUResult <= s_aluResult;
    WriteData <= s_writeData;
end;