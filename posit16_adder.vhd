library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity posit16_adder is
    port (
        x : in  std_logic_vector(15 downto 0);
        y : in  std_logic_vector(15 downto 0);
        r : out std_logic_vector(15 downto 0)
    );
end posit16_adder;

architecture behaviour of posit16_adder is

    component posit16_decoder is
        port (
            x       : in  std_logic_vector(15 downto 0);
            sign    : out std_logic;
            regime  : out signed(4 downto 0);
            exp     : out std_logic_vector(1 downto 0);
            frac    : out std_logic_vector(11 downto 0);
            x_abs   : out std_logic_vector(14 downto 0);
            zero    : out std_logic;
            inf     : out std_logic
        );
    end component;

    component right_shifter_12b
        port (
            -- Input vector
            x     : in  std_logic_vector(11 downto 0);
            -- Number of bits to shift
            count : in  std_logic_vector(3 downto 0);
            -- Output vector right-shifted count bits
            y     : out std_logic_vector(14 downto 0)
        );
    end component;

    component LZcountshift_12b
        port (
            -- Input vector that contains at lease one 1
            x       : in  std_logic_vector(13 downto 0);
            -- Number of leading zeros
            nlzeros : out unsigned(3 downto 0);
            -- Output vector left-shifted nlzeros bits
            y       : out std_logic_vector(13 downto 0)
        );
    end component;

    component posit16_encoder is
        port (
            sign    : in  std_logic;
            sf      : in std_logic_vector(6 downto 0);
            frac    : in std_logic_vector(14 downto 0);
            inf     : in std_logic;
            x       : out std_logic_vector(15 downto 0)
        );
    end component;

    signal sign_x : std_logic;
    signal sign_y : std_logic;
    signal sign_l : std_logic;

    signal regime_x : signed(4 downto 0);
    signal regime_y : signed(4 downto 0);

    signal exp_x : std_logic_vector(1 downto 0);
    signal exp_y : std_logic_vector(1 downto 0);

    signal frac_x : std_logic_vector(11 downto 0);
    signal frac_y : std_logic_vector(11 downto 0);
    signal frac_l : std_logic_vector(11 downto 0);
    signal frac_s : std_logic_vector(11 downto 0);
    signal frac_s_shift : std_logic_vector(14 downto 0);
    signal frac_s_add : std_logic_vector(15 downto 0);
    signal frac_add : std_logic_vector(15 downto 0);
    signal frac_r : std_logic_vector(14 downto 0);
    signal frac_r_shift : std_logic_vector(13 downto 0);
    signal frac_r_shift_sticky : std_logic_vector(14 downto 0);

    signal abs_x : std_logic_vector(14 downto 0);
    signal abs_y : std_logic_vector(14 downto 0);

    signal inf_x : std_logic;
    signal inf_y : std_logic;
    signal inf_r : std_logic;

    signal sf_x : std_logic_vector(6 downto 0);
    signal sf_y : std_logic_vector(6 downto 0);
    signal sf_l : std_logic_vector(6 downto 0);
    signal sf_r : std_logic_vector(6 downto 0);

    signal offset_tmp : signed(6 downto 0);
    signal offset : std_logic_vector(3 downto 0);

    signal ovf_r : std_logic_vector(0 downto 0);

    signal nzeros : unsigned(3 downto 0);

begin
    inst_decoder_x : posit16_decoder
        port map(
            x      => x,
            sign   => sign_x, 
            regime => regime_x,
            exp    => exp_x,
            frac   => frac_x,
            x_abs  => abs_x,
            zero   => open,
            inf    => inf_x       
        );

    inst_decoder_y : posit16_decoder
        port map(
            x      => y,
            sign   => sign_y, 
            regime => regime_y,
            exp    => exp_y,
            frac   => frac_y,
            x_abs  => abs_y,
            zero   => open,
            inf    => inf_y       
        );

    -- Define the scaling factor
    sf_x <= std_logic_vector(regime_x) & exp_x;
    sf_y <= std_logic_vector(regime_y) & exp_y;

    -- Check the larger and smaller input
    process (abs_x, abs_y, sign_x, sign_y, sf_x, sf_y, frac_x, frac_y)
    begin
        if abs_x > abs_y then
            sign_l <= sign_x;
            sf_l   <= sf_x;
            frac_l <= frac_x;
            frac_s <= frac_y;
        else
            sign_l <= sign_y;
            sf_l   <= sf_y;
            frac_l <= frac_y;
            frac_s <= frac_x;
        end if;
    end process;

    -- Align the significands
    offset_tmp <= abs(signed(sf_x) - signed(sf_y));
    offset <= std_logic_vector(offset_tmp(3 downto 0)) when offset_tmp < 16 else
              (others => '1'); -- What is this for??

    inst_rshifter : right_shifter_12b
        port map (
            x     => frac_s,
            count => offset,
            y     => frac_s_shift
        );

    -- Add the fractions
    frac_s_add <= std_logic_vector(unsigned(not('0' & frac_s_shift)) + 1) when (sign_x xor sign_y) = '1' else
                  '0' & frac_s_shift;
    frac_add <= std_logic_vector(unsigned('0' & frac_l & "000") + unsigned(frac_s_add));
    
    ovf_r <= frac_add(15 downto 15);

    frac_r <= frac_add(15 downto 2) & (frac_add(1) or frac_add(0)) when ovf_r = "1" else
              frac_add(14 downto 0);

    inst_LZcountshift : LZcountshift_12b
        port map (
            x       => frac_r(14 downto 1),
            nlzeros => nzeros,
            y       => frac_r_shift
        );
    frac_r_shift_sticky <= frac_r_shift & frac_r(0);

    sf_r <= std_logic_vector(signed(sf_l) + signed("0" & ovf_r) - signed("0" & nzeros));

    inf_r <= inf_x or inf_y;

    inst_encoder : posit16_encoder
        port map (
            sign => sign_l,
            sf   => sf_r,
            frac => frac_r_shift_sticky,
            inf  => inf_r,
            x    => r
        );

end behaviour;