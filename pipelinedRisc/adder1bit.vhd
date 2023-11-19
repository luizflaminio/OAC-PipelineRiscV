entity adder1bit is -- somador completo de um bit
    port(
        a, b, cin: in bit;
        s, cout: out bit
    );
end entity adder1bit;

architecture arch_adder1bit of adder1bit is -- logica somador de um bit
    begin
        s <= a xor b xor cin;
        cout <= (a and b) or (b and cin) or (a and cin);
end architecture arch_adder1bit;
