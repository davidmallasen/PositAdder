library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

-- Leading zero counter + shifter
-- Muller et al. 2018 Handbook of Floating-Point Arithmetic 8.2.7.3
entity LZcountshift is
    port (
        -- Input vector
        x       : in  std_logic_vector(13 downto 0);
        -- Number of leading zeros
        nlzeros : out unsigned(3 downto 0);
        -- Output vector left-shifted nlzeros bits
        y       : out std_logic_vector(13 downto 0)
    );
end LZcountshift;

architecture behaviour of LZcountshift is

    signal x_4 : std_logic_vector(13 downto 0);
    signal x_3 : std_logic_vector(13 downto 0);
    signal x_2 : std_logic_vector(13 downto 0);
    signal x_1 : std_logic_vector(13 downto 0);
    signal x_0 : std_logic_vector(13 downto 0);

    signal d_3 : std_logic;
    signal d_2 : std_logic;
    signal d_1 : std_logic;
    signal d_0 : std_logic;

    signal nlzeros_tmp : unsigned(3 downto 0);
begin
    
    x_4 <= x;

    process (x_4, x_3, x_2, x_1)
    begin
        -- i = 3
        -- if there are 2^i leading zeros in x_{i+1}
        if x_4(13 downto 6) = (13 downto 6 => '0') then
            d_3 <= '1';
            x_3 <= x_4(5 downto 0) & (13 downto 6 => '0');  -- x_{i+1} shifted left by 2^i
        else
            d_3 <= '0';
            x_3 <= x_4;
        end if;

        -- i = 2
        if x_3(13 downto 10) = (13 downto 10 => '0') then
            d_2 <= '1';
            x_2 <= x_3(9 downto 0) & (13 downto 10 => '0');
        else
            d_2 <= '0';
            x_2 <= x_3;
        end if;

        -- i = 1
        if x_2(13 downto 12) = (13 downto 12 => '0') then
            d_1 <= '1';
            x_1 <= x_2(11 downto 0) & (13 downto 12 => '0');
        else
            d_1 <= '0';
            x_1 <= x_2;
        end if;

        -- i = 0
        if x_1(13 downto 13) = (13 downto 13 => '0') then
            d_0 <= '1';
            x_0 <= x_1(12 downto 0) & (13 downto 13 => '0');
        else
            d_0 <= '0';
            x_0 <= x_1;
        end if;
    end process;

    nlzeros_tmp <= d_3 & d_2 & d_1 & d_0;
    --nlzeros <= nlzeros_tmp;
    nlzeros <= "1110" when nlzeros_tmp = 15 else
               nlzeros_tmp;
    y <= x_0;

end behaviour;