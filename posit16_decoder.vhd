library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity posit16_decoder is
    port (
        x      : in  std_logic_vector(15 downto 0);
        sign   : out std_logic;
        regime : out signed(4 downto 0);
        exp    : out std_logic_vector(1 downto 0);
        frac   : out std_logic_vector(11 downto 0);
        x_abs  : out std_logic_vector(14 downto 0);
        zero   : out std_logic;
        inf    : out std_logic
    );
end posit16_decoder;

architecture behaviour of posit16_decoder is

    component posit_regime_extractor
        port (
            -- Input posit vector without sign bit
            x      : in  std_logic_vector(14 downto 0);
            -- Final regime value of x
            regime : out signed(4 downto 0);
            -- Output posit vector with regime bits shifted out
            y      : out std_logic_vector(14 downto 0)
        );
    end component;

    signal nzero     : std_logic;
    signal tmp_abs   : std_logic_vector(14 downto 0);
    signal int_x_abs : std_logic_vector(14 downto 0);

begin
    -- Sign extraction
    sign <= x(15);

    -- Zero and infinite checks
    nzero <= '0' when x(14 downto 0) = (14 downto 0 => '0') else 
             '1';
    zero <= not (x(15) or nzero);
    inf <= x(15) and (not nzero);

    -- Get absolute value if 'x' is a negative number
    int_x_abs <= std_logic_vector(unsigned(not(x(14 downto 0))) + 1) when (x(15) = '1') else 
                 x(14 downto 0);
    x_abs <= int_x_abs;

    -- Regime extraction
    REGIME_EXT: posit_regime_extractor
        port map(
            x      => int_x_abs,
            regime => regime,
            y      => tmp_abs
        );

    -- Exponent extraction
    exp <= tmp_abs(14 downto 13);

    -- Fraction bits extraction
    frac <= nzero & tmp_abs(12 downto 2);

end behaviour;