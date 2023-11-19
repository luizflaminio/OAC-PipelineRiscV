library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.TEXTIO.all;

entity imem is
    port(
        a: in STD_LOGIC_VECTOR(31 downto 0);
        rd: out STD_LOGIC_VECTOR(31 downto 0)
    );
end;

architecture behave of imem is

    type ramtype is array(63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    -- initialize memory from file
    impure function init_ram_hex(carga: in string) return ramtype is
        file arq: text open read_mode is carga;
        variable linha_atual: line;
        variable dado_atual: bit_vector(31 downto 0);
        variable mem_ready: ramtype;

    begin
        for i in ramtype'range loop
            readline(arq, linha_atual); -- Le a primeira linha
            read(linha_atual, dado_atual); -- Busca bit vector na linha e salva no "buffer"
            mem_ready(i) := to_stdlogicvector(dado_atual); -- escreve na memoria-retorno o dado do "buffer"
        end loop;
            return mem_ready;
    end;

    signal mem : ramtype := init_ram_hex("riscvtest.txt");
begin
    -- read memory
    process(a) begin
        rd <= mem(to_integer(unsigned(a(31 downto 2))));
    end process;
end;