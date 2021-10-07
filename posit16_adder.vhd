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

    --component decoder
    --    port (
    --        x : in std_logic_vector(15 downto 0)
    --        -- TODO
    --    );
    --end component;

    --component right_shifter
    --    port (
    --        x : in  std_logic_vector(15 downto 0)
    --        a : in  unsigned(3 downto 0)
    --        y : out std_logic_vector(15 downto 0)
    --    );
    --end component;

    component LZcountshift_14b
    port (
        -- Input vector that contains at lease one 1
        x       : in  std_logic_vector(13 downto 0);
        -- Number of leading zeros
        nlzeros : out unsigned(3 downto 0);
        -- Output vector left-shifted nlzeros bits
        y       : out std_logic_vector(13 downto 0)
    );
    end component;

    --component encoder
    --    port (
    --        x : out std_logic_vector(15 downto 0)
    --        -- TODO
    --    );
    --end component;

    signal sign_x : std_logic;
    signal sign_y : std_logic;
    signal sign_l : std_logic;

    signal regime_x : std_logic_vector(3 downto 0);
    signal regime_y : std_logic_vector(3 downto 0);

    signal exp_x : std_logic_vector(1 downto 0);
    signal exp_y : std_logic_vector(1 downto 0);

    signal frac_x : std_logic_vector(13 downto 0);
    signal frac_y : std_logic_vector(13 downto 0);
    signal frac_l : std_logic_vector(13 downto 0);
    signal frac_s : std_logic_vector(13 downto 0);
    signal frac_s_shift : std_logic_vector(13 downto 0);
    signal frac_add : std_logic_vector(13 downto 0);
    signal frac_r : std_logic_vector(13 downto 0);
    signal frac_r_shift : std_logic_vector(13 downto 0);

    signal inf_x : std_logic;
    signal inf_y : std_logic;
    signal inf_r : std_logic;

    signal abs_x : std_logic_vector(15 downto 0);
    signal abs_y : std_logic_vector(15 downto 0);

    signal sf_x : std_logic_vector(5 downto 0);
    signal sf_y : std_logic_vector(5 downto 0);
    signal sf_l : std_logic_vector(5 downto 0);
    signal sf_s : std_logic_vector(5 downto 0);
    signal sf_r : std_logic_vector(5 downto 0);
    signal sf_r_tmp : unsigned(5 downto 0);

    signal offset : unsigned(5 downto 0);

    signal ovf_r : std_logic;

    signal nzeros : unsigned(3 downto 0);

begin
    --inst_decoder : decoder
    --    port map (
    --        x => x
    --    );

    -- Define the scaling factor
    sf_x <= regime_x & exp_x;
    sf_y <= regime_y & exp_y;

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

    offset <= unsigned(sf_l) - unsigned(sf_s);

    --inst_rshifter : right_shifter
    --    port map (
    --        x => frac_s;
    --        a => offset;
    --        y => frac_s_shift
    --    );

    frac_add <= std_logic_vector(signed(frac_l) - signed(frac_s_shift)) when (sign_x xor sign_y) = '1' else 
                std_logic_vector(signed(frac_l) + signed(frac_s_shift));
    
    ovf_r <= frac_add(13);

    frac_r <= '0' & frac_add(12 downto 0) when ovf_r = '1' else
              frac_add;

    inst_LZcountshift : LZcountshift_14b
        port map (
            x       => frac_r,
            nlzeros => nzeros,
            y       => frac_r_shift
        );

    sf_r_tmp <= unsigned(sf_l) - nzeros;
    sf_r <= std_logic_vector(sf_r_tmp + 1) when ovf_r = '1' else
            std_logic_vector(sf_r_tmp);

    inf_r <= inf_x or inf_y;

    --inst_encoder : encoder
    --    port map (
    --        -- TODO
    --    );

end behaviour;