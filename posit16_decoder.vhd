library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity posit16_decoder is
    generic (
        N   : integer := 16;
        ES  : integer := 2;
        R_N : integer := 4;
        F_N : integer := 16-3-2+1 -- {N - (sign and minimum regime) - ES + (hidden fraction bit)}
    );
    port (
        x       : in  std_logic_vector(N-1 downto 0);
        sign    : out std_logic;
        regime  : out signed(R_N downto 0);
        exp     : out std_logic_vector(ES-1 downto 0);
        frac    : out std_logic_vector(F_N-1 downto 0);
        x_abs   : out std_logic_vector(N-2 downto 0);
        zero    : out std_logic;
        inf     : out std_logic
    );
end posit16_decoder;

architecture behaviour of posit16_decoder is
    signal nzero : std_logic;
    signal tmp_abs : std_logic_vector(N-2 downto 0);
    signal int_x_abs : std_logic_vector(N-2 downto 0);

    component posit_regime_extractor
        port (
            -- Input posit vector without sign bit
            x       : in  std_logic_vector(14 downto 0);
            -- Final regime value of x
            regime  : out signed(4 downto 0);
            -- Output posit vector with regime bits shifted out
            y       : out std_logic_vector(14 downto 0)
        );
    end component;

begin
    -- Sign extraction
    sign <= x(N-1);
    -- Zero and infinite checks
    nzero <= '0' when x(N-2 downto 0) = (N-2 downto 0 => '0') else '1';
    zero <= not (x(N-1) or nzero);
    inf <= x(N-1) and (not nzero);
    -- Get absolute value if 'x' is a negative number
    int_x_abs <= std_logic_vector(unsigned(not(x(N-2 downto 0))) + 1) when (x(N-1) = '1') else x(N-2 downto 0);
    -- Regime extraction
    REGIME_EXT: posit_regime_extractor
        port map(
            x => int_x_abs,
            regime => regime,
            y => tmp_abs
        );
    x_abs <= int_x_abs;
    -- Exponent extraction
    exp <= tmp_abs(N-2 downto N-3);
    -- Fraction bits extraction
    frac <= nzero & tmp_abs(N-4 downto N-14);
end behaviour;