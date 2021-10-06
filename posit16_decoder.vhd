library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity posit16_decoder is
    generic (
        N   : integer := 16;
        ES  : integer := 2;
        R_N : integer := 4;
        F_N : integer := N - 3 - ES
    );
    port (
        x       : in  std_logic_vector(N-1 downto 0);
        sign    : out std_logic;
        regime  : out std_logic_vector(R_N-1 downto 0);
        exp     : out std_logic_vector(ES-1 downto 0);
        frac    : out std_logic_vector(F_N-1 downto 0);
        x_abs   : out std_logic_vector(N-2 downto 0);
        zero    : out std_logic;
        inf     : out std_logic
    );
end posit16_decoder;

architecture behaviour of posit16_decoder is
    signal nzero : std_logic;
    signal R_tmp : std_logic_vector(N-2 downto 0);
    signal R     : std_logic_vector(N-2 downto 0);    -- Number of regime bits
begin
    -- Sign extraction
    sign <= x(N-1);
    -- Zero and infinite checks
    nzero <= or x(N-2 downto 0);
    zero <= not (sign or nzero);
    inf <= sign and (not nzero);
    -- Get absolute value if 'x' is a negative number
    x_abs <= (not(x(N-2 downto 0)) + 1) when (sign == 1) else x(N-2 downto 0);
    -- Regime extraction
    R_tmp <= not x_abs when (x_abs(N-2) == 1) else x_abs;
        -- Leading One Detector --
    regime <= -R when (x_abs(N-2) == 1) else R-1;
    --
    x_abs <= shift_left(x_abs, R);
    -- Exponent extraction
    exp <= x_abs(N-2 downto N-4);
    -- Fraction bits extraction
    
end behaviour;