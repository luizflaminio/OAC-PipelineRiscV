library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_unit is
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

end entity;

architecture behavioral of hazard_unit is

    signal s_stall: std_logic;

begin
    -- forwarding
    forward_AE : process (Rs1E, RdM, RdW, RegWriteM, RegWriteW)
    begin
        if ((Rs1E = RdM) and RegWriteM="1" and (Rs1E /= "00000")) then
            ForwardAE <= "10"; -- forward from memory stage
        elsif ((Rs1E = RdW) and RegWriteW="1" and (Rs1E /= "00000")) then
            ForwardAE <= "01"; -- forward from writeback stage
        else
            ForwardAE <= "00"; -- no forwarding
        end if;
    end process;

	forward_BE : process (Rs2E, RdM, RdW, RegWriteM, RegWriteW)
    begin
        if ((Rs2E = RdM) and RegWriteM="1"and (Rs2E /= "00000")) then
            ForwardBE <= "10"; -- forward from memory stage
        elsif ((Rs2E = RdW) and RegWriteW="1" and (Rs2E /= "00000")) then
            ForwardBE <= "01"; -- forward from writeback stage
        else
            ForwardBE <= "00"; -- no forwarding
        end if;
    end process;

    -- stall
    stall_process: process(ResultSrcE0, RdE, Rs1D, Rs2d)
    begin
        if(ResultSrcE0 = '0' and ((RdE = Rs1D) or (RdE = Rs2D))) then
            s_stall <= '1';
        else s_stall <= '0';
        end if;
    end process;

    StallF <= s_stall;
    StallD <= s_stall;
    FlushE <= s_stall or PCSrcE; 
	FlushD <= PCSrcE; 

end architecture;