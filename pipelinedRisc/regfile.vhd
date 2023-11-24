library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
    port(
        clock: in std_logic;
        reset: in std_logic;
        we3: in std_logic;
        a1, a2, a3: in std_logic_vector(4 downto 0);
        wd3: in std_logic_vector(31 downto 0);
        rd1, rd2: out std_logic_vector(31 downto 0)
    );
end regfile;

architecture regfile_arch of regfile is
    -- Define-se o tipo de um registrador
    type registradores is array (0 to 31) of std_logic_vector(31 downto 0);
    signal reset_value : std_logic_vector(31 downto 0);
    signal reg_file    : registradores;

begin
    reset_value <= (others => '0');

    bancoDeRegistradores : process(reset, clock)
        variable temp_rd1, temp_rd2 : std_logic_vector(31 downto 0);
    begin
        if reset = '1' then
            for i in 0 to 31 loop
                reg_file(i) <= reset_value;
            end loop;
        elsif rising_edge(clock) then
            if we3 = '1' then
                if to_integer(unsigned(a3)) /= 31 then
                    reg_file(to_integer(unsigned(a3))) <= wd3;
                end if;
            end if;
        end if;

        -- Ensure that the reading process covers all possible values
        temp_rd1 := (others => '0');
        temp_rd2 := (others => '0');

        if to_integer(unsigned(a1)) < 32 then
            temp_rd1 := reg_file(to_integer(unsigned(a1)));
        end if;

        if to_integer(unsigned(a2)) < 32 then
            temp_rd2 := reg_file(to_integer(unsigned(a2)));
        end if;

        rd1 <= temp_rd1;
        rd2 <= temp_rd2;
    end process bancoDeRegistradores;
end regfile_arch;