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

    begin

end architecture;