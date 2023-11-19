library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_bit.all;

entity alu is
    port(
        a, b        :  in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl  :  in  STD_LOGIC_VECTOR(2  downto 0);
        ALUResult   :  out STD_LOGIC_VECTOR(31 downto 0);
        Zero        :  out  STD_LOGIC
    );
end;

 architecture alu_arch of alu is

    signal overflow, s_slt  : std_logic;
    signal op_sum           : std_logic_vector(31 downto 0);
    signal s_sum, s_result  : std_logic_vector(31 downto 0);
    signal not_b, zeroExt   : std_logic_vector(31 downto 0);
    signal s_zero           : std_logic_vector(31 downto 0);

    component mux2 
        generic(width: integer);
        port(
            d0, d1  : in  STD_LOGIC_VECTOR(width-1 downto 0);
            s       : in  STD_LOGIC;
            y       : out STD_LOGIC_VECTOR(width-1 downto 0));
        end component;
    
    component adder
        port(
            a, b    : in  STD_LOGIC_VECTOR(31 downto 0);
            y       :  out STD_LOGIC_VECTOR(31 downto 0));
        end component;
        
    component extend
        port(
            instr   : in  STD_LOGIC_VECTOR(31 downto 7);
            immsrc  : in  STD_LOGIC_VECTOR(1  downto 0);
            immext  : out STD_LOGIC_VECTOR(31 downto 0));
        end component;

begin
    not_b <= not b;

    mux_somador: mux2 generic map(32) port map(b, not_b, ALUControl(0), op_sum);
    alu_adder: adder port map(a, op_sum, s_sum);

    overflow <= not(ALUControl(0) xor a(31) xor b(31)) and (a(31) xor s_sum(31)) and not (ALUControl(1));

    s_slt <= overflow xor s_sum(31);

    with ALUControl select
    s_result <=    s_sum when "000",
                        s_sum when "001",
                        (a and b) when "010",
                        (a or b) when "011",
                        zeroExt  when "101",
                        a        when others;
        
    zeroExt <= (31 downto 1 => '0') & (s_slt);

    s_zero <= (31 downto 0 => '0');

    Zero <= '1' when s_result = s_zero else '0';
    ALUResult <= s_result;

end alu_arch;