library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

-- Modified leading zero counter + shifter to extract posit regime
-- Inspired by Muller et al. 2018 Handbook of Floating-Point Arithmetic 8.2.7.3
entity posit_regime_extractor is
    port (
        -- Input posit vector without sign bit
        x      : in  std_logic_vector(14 downto 0);
        -- Final regime value of x
        regime : out signed(4 downto 0);
        -- Output posit vector with regime bits shifted out
        y      : out std_logic_vector(14 downto 0)
    );
end posit_regime_extractor;

architecture behaviour of posit_regime_extractor is

    signal x_4 : std_logic_vector(14 downto 0);
    signal x_3 : std_logic_vector(14 downto 0);
    signal x_2 : std_logic_vector(14 downto 0);
    signal x_1 : std_logic_vector(14 downto 0);
    signal x_0 : std_logic_vector(14 downto 0);

    signal d_3 : std_logic;
    signal d_2 : std_logic;
    signal d_1 : std_logic;
    signal d_0 : std_logic;

    signal nlzeros : signed(4 downto 0);

begin
    -- If regime starts with 1, invert the whole vector to count leading zeros
    x_4 <= not x when (x(14) = '1') else x;

    process (x, x_4, x_3, x_2, x_1)
    begin
        -- i = 3
        -- if there are 2^i leading zeros in x_{i+1}
        if x_4(14 downto 7) = (14 downto 7 => '0') then
            d_3 <= '1';
            x_3 <= x_4(6 downto 0) & (14 downto 7 => x(14));  -- x_{i+1} shifted left by 2^i
        else
            d_3 <= '0';
            x_3 <= x_4;
        end if;

        -- i = 2
        if x_3(14 downto 11) = (14 downto 11 => '0') then
            d_2 <= '1';
            x_2 <= x_3(10 downto 0) & (14 downto 11 => x(14));
        else
            d_2 <= '0';
            x_2 <= x_3;
        end if;

        -- i = 1
        if x_2(14 downto 13) = (14 downto 13 => '0') then
            d_1 <= '1';
            x_1 <= x_2(12 downto 0) & (14 downto 13 => x(14));
        else
            d_1 <= '0';
            x_1 <= x_2;
        end if;

        -- i = 0
        if x_1(14 downto 14) = (14 downto 14 => '0') then
            d_0 <= '1';
            x_0 <= x_1(13 downto 0) & (14 downto 14 => x(14));
        else
            d_0 <= '0';
            x_0 <= x_1;
        end if;
    end process;

    -- Compute final regime value 'k'
    nlzeros <= '0' & d_3 & d_2 & d_1 & d_0;
    regime <= nlzeros - 1 when x(14) = '1' else 
              0 - nlzeros;

    -- Revert initial inversion and shift last regime bit
    y <= (not x_0(13 downto 0)) & "0" when x(14) = '1' else 
         x_0(13 downto 0) & "0";

end behaviour;