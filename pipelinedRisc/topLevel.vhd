library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity topLevel is
    port(
        clk  :  in STD_LOGIC;
		  reset: in STD_LOGIC
    );
end;

architecture test of topLevel is
    component riscvsingle
    port(
        clk, reset: in STD_LOGIC;
        PC: out STD_LOGIC_VECTOR(31 downto 0);
        Instr: in STD_LOGIC_VECTOR(31 downto 0);
        MemWrite: out STD_LOGIC;
        ALUResult, WriteData: out STD_LOGIC_VECTOR(31 downto 0);
        ReadData: in STD_LOGIC_VECTOR(31 downto 0));
    end component;

component imem
    port(
        a: in STD_LOGIC_VECTOR(31 downto 0);
        rd: out STD_LOGIC_VECTOR(31 downto 0)   
    );
end component;

component dmem
    port(
        clk, we: in STD_LOGIC;
        a, wd: in STD_LOGIC_VECTOR(31 downto 0);
        rd: out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

signal PC, Instr, ReadData: STD_LOGIC_VECTOR(31 downto 0);
signal s_writeData, s_dataAdr  : STD_LOGIC_VECTOR(31 downto 0);
signal s_memWrite : STD_LOGIC;

begin
    -- instantiate processor and memories
    rvsingle: riscvsingle 
    port map(
        clk, reset, PC, Instr,
        s_memWrite, s_dataAdr,
        s_writeData, ReadData
    );
    
    imem1: imem port map(PC, Instr);

    dmem1: dmem port map(clk, s_memWrite, s_dataAdr, s_writeData, ReadData);
end;