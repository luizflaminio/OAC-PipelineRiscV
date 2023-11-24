library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity controller is
    port( 
        op              : in  STD_LOGIC_VECTOR(6 downto 0);
        funct3          : in  STD_LOGIC_VECTOR(2 downto 0);
        funct7b5, Zero  : in  STD_LOGIC;
        ResultSrc       : out STD_LOGIC_VECTOR(1 downto 0);
        MemWrite        : out std_logic_vector(0 downto 0);
        PCSrc, ALUSrc   : out STD_LOGIC;
        RegWrite			: out STD_LOGIC;
        Jump, Branch    : out std_logic_vector(0 downto 0);
        ImmSrc          : out STD_LOGIC_VECTOR(1 downto 0);
        ALUControl      : out STD_LOGIC_VECTOR(2 downto 0));

end;

architecture struct of controller is

    component maindec
    port(
        op              : in  STD_LOGIC_VECTOR(6 downto 0);
        ResultSrc       : out STD_LOGIC_VECTOR(1 downto 0);
        MemWrite        : out STD_LOGIC;
        Branch, ALUSrc  : out STD_LOGIC;
        RegWrite, Jump  : out STD_LOGIC;
        ImmSrc          : out STD_LOGIC_VECTOR(1 downto 0);
        ALUOp           : out STD_LOGIC_VECTOR(1 downto 0));
    end component;

    component aludec
    port(
        opb5        : in  STD_LOGIC;
        funct3      : in  STD_LOGIC_VECTOR(2 downto 0);
        funct7b5    : in  STD_LOGIC;
        ALUOp       : in  STD_LOGIC_VECTOR(1 downto 0);
        ALUControl  : out STD_LOGIC_VECTOR(2 downto 0));
    end component;

    signal ALUOp: STD_LOGIC_VECTOR(1 downto 0);
    signal s_Branch, s_jump: STD_LOGIC;

begin

    md: maindec port map(
        op, ResultSrc, MemWrite(0), s_Branch,
        ALUSrc, RegWrite, s_jump, ImmSrc, ALUOp
    );

    ad: aludec port map(
        op(5), funct3, funct7b5, ALUOp, ALUControl
    );
   
    PCSrc <= (s_Branch and Zero) or s_jump;
	
	 with s_jump select
		Jump <= 	"1" when '1',
					"0" when others;
					
					
	  with s_branch select
		Branch <= 	"1" when '1',
						"0" when others;
end;