-- 4 registradores
-- ALUResultM, WriteDataM, RdM, PCPlus4M
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regFileIM_IW is
    port (
        clk, reset, en       : in  std_logic;
        RegWriteM            : in  std_logic_vector(0 downto 0); 
        ResultSrcM           : in  std_logic_vector(1 downto 0);
        ALUResultM, PCPlus4M : in  std_logic_vector(31 downto 0);
        RdM                  : in  std_logic_vector(4 downto 0);
        ReadDataM            : in std_logic_vector(31 downto 0);
        RegWriteW            : out std_logic_vector(0 downto 0); 
        ResultSrcW           : out std_logic_vector(1 downto 0);
        ALUResultW, PCPlus4W : out std_logic_vector(31 downto 0);
        RdW                  : out std_logic_vector(4 downto 0);
        ReadDataW            : out std_logic_vector(31 downto 0)
    );
end entity regFileIM_IW;

architecture arch_regM of regFileIM_IW is
    component flopenr
        generic(width: integer);
        port(
            clk, reset, en  : in  std_logic;
            d               : in  STD_LOGIC_VECTOR(width-1 downto 0);
            q               : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
begin
    -- sinais do datapath
    regRdM      : flopenr generic map(5) port map(clk, reset, en, RdM, RdW);
    regResultM  : flopenr generic map(32) port map(clk, reset, en, ALUResultM, ALUResultW);
    regPCPlus4M : flopenr generic map(32) port map(clk, reset, en, PCPlus4M, PCPlus4W);
    regWriteDtM : flopenr generic map(32) port map(clk, reset, en, ReadDataM, ReadDataW);

    --sinais da UC
    reg_regWriteM       : flopenr generic map(1) port map(clk, reset, en, RegWriteM, RegWriteW);
    reg_regResultM      : flopenr generic map(2) port map(clk, reset, en, ResultSrcM, ResultSrcW); 

end architecture arch_regM;