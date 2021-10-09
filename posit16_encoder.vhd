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
        sf      : in std_logic_vector(ES + R_N downto 0);
        frac    : in std_logic_vector(F_N-1 downto 0);
        inf     : in std_logic;
        x       : out std_logic_vector(N-1 downto 0)
    );
end posit16_encoder;

architecture behaviour of posit16_encoder is

    signal exp      : std_logic_vector(ES-1 downto 0);
    signal tmp      : std_logic_vector(N downto 0);
    signal ans_tmp  : std_logic_vector(N downto 0);
    signal offset   : std_logic_vector(R_N downto 0);
    signal l_bit    : std_logic;
    signal g_bit    : std_logic;
    signal r_bit    : std_logic;
    signal s_bit    : std_logic;
    signal round    : std_logic;

    component right_shifter_round_17b 
        port (
            -- Input vector
            x        : in  std_logic_vector(16 downto 0);
            -- Number of bits to shift
            count    : in  std_logic_vector(4 downto 0);
            -- Bit to prepend when shifting
            prep_bit : in std_logic;
            -- Output vector right-shifted count bits
            y        : out std_logic_vector(16 downto 0);
            -- Sticky bit (OR of the discarded right bits)
            s        : out std_logic
        );
    end component;

begin
    -- Exponent extraction
    exp <= sf(1 downto 0);

    process(sf, exp, frac)
    begin
        if sf(ES + R_N) = '1' then
            tmp <= '1' & exp & frac & "00";
            offset <= not sf(ES + R_N downto 2);
        else
            tmp <= '0' & exp & frac & "00";
            offset <= sf(ES + R_N downto 2);
        end if;
    end process;
    -- Right-shift 'tmp', 'offset' bits prepending ¬sf[MSB] to the left
    -- and OR the discarded bits from the right.
    shifter_round: right_shifter_round_17b
        port map(
            x => tmp,
            count => offset,
            prep_bit => not sf(ES + R_N),
            y => ans_tmp,
            s => s_bit
        );
    -- Round bit calculation
    l_bit <= ans_tmp(2);
    g_bit <= ans_tmp(1);
    r_bit <= ans_tmp(0);
    round <= g_bit and (l_bit or r_bit or s_bit);
    -- Result construction
    process(inf, sign, ans_tmp, round)
    begin
        if inf = '1' then
            x <= x"8000";
        elsif sign = '1' then
            x <= '1' & std_logic_vector(unsigned(not(ans_tmp(N downto 2))) + round + 1);
        else
            x <= '0' & std_logic_vector(unsigned(ans_tmp(N downto 2)) + round);
        end if;          
    end process;
end behaviour;