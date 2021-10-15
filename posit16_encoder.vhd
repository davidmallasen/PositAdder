library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity posit16_encoder is
    port (
        sign : in  std_logic;
        sf   : in  std_logic_vector(7 downto 0);
        frac : in  std_logic_vector(14 downto 0);
        inf  : in  std_logic;
        x    : out std_logic_vector(15 downto 0)
    );
end posit16_encoder;

architecture behaviour of posit16_encoder is

    signal exp     : std_logic_vector(1 downto 0);
    signal tmp     : std_logic_vector(17 downto 0);
    signal ans_tmp : std_logic_vector(17 downto 0);
    signal offset  : std_logic_vector(4 downto 0);
    signal l_bit   : std_logic;
    signal g_bit   : std_logic;
    signal r_bit   : std_logic;
    signal s_bit   : std_logic;
    signal round   : std_logic;
    signal not_sf  : std_logic;

    component right_shifter_round
        port (
            -- Input vector
            x        : in  std_logic_vector(17 downto 0);
            -- Number of bits to shift
            count    : in  std_logic_vector(4 downto 0);
            -- Bit to prepend when shifting
            prep_bit : in  std_logic;
            -- Output vector right-shifted count bits
            y        : out std_logic_vector(17 downto 0)
        );
    end component;

begin
    -- Exponent extraction
    exp <= sf(1 downto 0);

    -- Start building the final result
    process(sf, exp, frac)
    begin
        if sf(7) = '1' then
            tmp <= "01" & exp & frac(13 downto 0);
            offset <= not(sf(6 downto 2));
        else
            tmp <= "10" & exp & frac(13 downto 0);
            offset <= sf(6 downto 2);
        end if;
    end process;

    -- Right-shift 'tmp', 'offset' bits prepending ¬sf[MSB] to the left
    -- and OR the discarded bits from the right.
    not_sf <= not sf(7);
    shifter_round: right_shifter_round
        port map(
            x        => tmp,
            count    => offset,
            prep_bit => not_sf,
            y        => ans_tmp
        );

    -- Round bit calculation
    l_bit <= ans_tmp(3);
    g_bit <= ans_tmp(2);
    r_bit <= ans_tmp(1);
    s_bit <= ans_tmp(0);
    round <= g_bit and (l_bit or r_bit or s_bit);

    -- Result construction
    process(inf, sign, ans_tmp, round)
    begin
        if inf = '1' then
            x <= x"8000";
        elsif sign = '1' then
            x <= '1' & std_logic_vector(not(unsigned(ans_tmp(17 downto 3)) + (round & "")) + 1);
        else
            x <= '0' & std_logic_vector(unsigned(ans_tmp(17 downto 3)) + (round & ""));
        end if;          
    end process;
    
end behaviour;