library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is -- Somador de todos os bits definidos por size
    port(
        a_maior, b_maior: in bit_vector(32 downto 0);
        cin: in bit;
        s_maior: out bit_vector(32 downto 0);
        cout: out bit
    );
end entity adder;

architecture full_adder of adder is
    component adder1bit is
        port(
            a, b, cin: in bit;
            s, cout: out bit
        );
    end component adder1bit;

    signal mid_cout: bit_vector(32 downto 0);

    begin
        somador: for i in 32 downto 0 generate
            primeiro_bit: if i = 0 generate
                ni: adder1bit port map(a_maior(i), b_maior(i), cin, s_maior(i), mid_cout(i)); -- o primeiro bit recebe 0 como cin 
            end generate primeiro_bit;

            outros_bits: if i > 0 generate
                ni: adder1bit port map(a_maior(i), b_maior(i), mid_cout(i - 1), s_maior(i), mid_cout(i));
            end generate outros_bits;

        end generate somador;
        cout <= mid_cout(32); -- carry out do somador maior 
end architecture full_adder;