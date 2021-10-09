library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity posit16_encoder is
    generic (
        N   : integer := 16;
        ES  : integer := 2;
        R_N : integer := 4;
        F_N : integer := 16-3-2+1 -- {N - (sign and minimum regime) - ES + (hidden fraction bit)}
    );
    port (
        sign    : in  std_logic;
        sf      : out std_logic_vector(ES + R_N downto 0);
        frac    : out std_logic_vector(F_N-1 downto 0);
        inf     : out std_logic
    );
end posit16_encoder;

architecture behaviour of posit16_encoder is

    signal exp : std_logic_vector(ES-1 downto 0);
    signal tmp : std_logic_vector(N + 1 downto 0);
    signal offset : std_logic_vector(R_N downto 0);

begin

    exp <= sf(1 downto 0);

    process(sf, exp, frac)
    begin
        if sf(ES + R_N) = '1' then
            tmp <= "01" & exp & frac & "00";
            offset <= not sf(ES + R_N downto 2);
        else
            tmp <= "10" & exp & frac & "00";
            offset <= sf(ES + R_N downto 2);
        end if;
    end process;


end behaviour;