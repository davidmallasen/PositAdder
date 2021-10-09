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
    end component;

    component right_shifter_12b
        port (
            -- Input vector
            x     : in  std_logic_vector(11 downto 0);
            -- Number of bits to shift
            count : in  std_logic_vector(3 downto 0);
            -- Output vector right-shifted count bits
            y     : out std_logic_vector(11 downto 0)
        );
    end component;

    component LZcountshift_12b
        port (
            -- Input vector that contains at lease one 1
            x       : in  std_logic_vector(11 downto 0);
            -- Number of leading zeros
            nlzeros : out unsigned(3 downto 0);
            -- Output vector left-shifted nlzeros bits
            y       : out std_logic_vector(11 downto 0)
        );
    end component;

    component posit16_encoder is
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
    signal frac_s_shift : std_logic_vector(11 downto 0);
    signal frac_add : std_logic_vector(11 downto 0);
    signal frac_r : std_logic_vector(11 downto 0);
    signal frac_r_shift : std_logic_vector(11 downto 0);

    signal abs_x : std_logic_vector(14 downto 0);
    signal abs_y : std_logic_vector(14 downto 0);

    signal inf_x : std_logic;
    signal inf_y : std_logic;
    signal inf_r : std_logic;

    signal sf_x : std_logic_vector(6 downto 0);
    signal sf_y : std_logic_vector(6 downto 0);
    signal sf_l : std_logic_vector(6 downto 0);
    signal sf_s : std_logic_vector(6 downto 0);
    signal sf_r : std_logic_vector(6 downto 0);
    signal sf_r_tmp : signed(6 downto 0);

    signal offset_tmp : signed(6 downto 0);
    signal offset : std_logic_vector(3 downto 0);

    signal ovf_r : std_logic;

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
            sf_s   <= sf_y;
            frac_s <= frac_y;
        else
            sign_l <= sign_y;
            sf_l   <= sf_y;
            frac_l <= frac_y;
            sf_s   <= sf_x;
            frac_s <= frac_x;
        end if;
    end process;

    -- Align the significands
    offset_tmp <= signed(sf_l) - signed(sf_s);
    offset <= std_logic_vector(offset_tmp(3 downto 0)) when offset_tmp < 16 else
              (others => '1');

    inst_rshifter : right_shifter_12b
        port map (
            x     => frac_s,
            count => offset,
            y     => frac_s_shift
        );

    -- Add the fractions
    frac_add <= std_logic_vector(unsigned(frac_l) - unsigned(frac_s_shift)) when (sign_x xor sign_y) = '1' else 
                std_logic_vector(unsigned(frac_l) + unsigned(frac_s_shift));
    
    ovf_r <= frac_add(11);

    frac_r <= '0' & frac_add(11 downto 1) when ovf_r = '1' else
              frac_add;

    inst_LZcountshift : LZcountshift_12b
        port map (
            x       => frac_r,
            nlzeros => nzeros,
            y       => frac_r_shift
        );

    sf_r_tmp <= signed(sf_l) - signed(nzeros);
    sf_r <= std_logic_vector(sf_r_tmp + 1) when ovf_r = '1' else
            std_logic_vector(sf_r_tmp);

    inf_r <= inf_x or inf_y;

    inst_encoder : posit16_encoder
        port map (
            sign => sign_l,
            sf   => sf_r,
            frac => frac_r,
            inf  => inf_r
        );

end behaviour;