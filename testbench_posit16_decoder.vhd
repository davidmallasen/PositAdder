library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_posit16_decoder is
    generic (
        N   : integer := 16;
        ES  : integer := 2;
        R_N : integer := 4;
        F_N : integer := 16-3-2+1 -- {N - (sign and minimum regime) - ES + (hidden fraction bit)}
    );
end test_posit16_decoder;

architecture test of test_posit16_decoder is
    component posit16_decoder
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
    end component;

    signal x       : std_logic_vector(N-1 downto 0);
    signal sign    : std_logic;
    signal regime  : signed(R_N downto 0);
    signal exp     : std_logic_vector(ES-1 downto 0);
    signal frac    : std_logic_vector(F_N-1 downto 0);
    signal x_abs   : std_logic_vector(N-2 downto 0);
    signal zero    : std_logic;
    signal inf     : std_logic;
begin
    DUT: posit16_decoder
        port map(
            x => x,
            sign => sign,
            regime => regime,
            exp => exp,
            frac => frac,
            x_abs => x_abs,
            zero => zero,
            inf => inf
        );

    process
    begin
        x <= "1000000000000000";
        wait for 1 ns;
        x <= "0000000000000001";
        wait for 1 ns;
        x <= "0000001110011010";
        wait for 1 ns;
        x <= "1000001110011010";
        wait for 1 ns;
        x <= "0010100110110010";
        wait for 1 ns;
        x <= "1010100110110010";
        wait for 1 ns;
        x <= "0111111110110010";
        wait for 1 ns;
        x <= "1111111110110010";
        wait for 1 ns;
        -- 8ns
    end process ;
end test;