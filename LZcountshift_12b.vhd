library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

-- Leading zero counter + shifter
-- Muller et al. 2018 Handbook of Floating-Point Arithmetic 8.2.7.3
entity LZcountshift_12b is
    port (
        -- Input vector that contains at lease one 1
        x       : in  std_logic_vector(11 downto 0);
        -- Number of leading zeros
        nlzeros : out unsigned(3 downto 0);
        -- Output vector left-shifted nlzeros bits
        y       : out std_logic_vector(11 downto 0)
    );
end LZcountshift_12b;

architecture behaviour of LZcountshift_12b is

    signal x_4 : std_logic_vector(11 downto 0);
    signal x_3 : std_logic_vector(11 downto 0);
    signal x_2 : std_logic_vector(11 downto 0);
    signal x_1 : std_logic_vector(11 downto 0);
    signal x_0 : std_logic_vector(11 downto 0);

    signal d_3 : std_logic;
    signal d_2 : std_logic;
    signal d_1 : std_logic;
    signal d_0 : std_logic;

begin
    
    x_4 <= x;

    process (x_4, x_3, x_2, x_1)
    begin
        -- i = 3
        -- if there are 2^i leading zeros in x_{i+1}
        if x_4(11 downto 4) = (11 downto 4 => '0') then
            d_3 <= '1';
            x_3 <= x_4(3 downto 0) & (11 downto 4 => '0');  -- x_{i+1} shifted left by 2^i
        else
            d_3 <= '0';
            x_3 <= x_4;
        end if;

        -- i = 2
        if x_3(11 downto 8) = (11 downto 8 => '0') then
            d_2 <= '1';
            x_2 <= x_3(7 downto 0) & (11 downto 8 => '0');
        else
            d_2 <= '0';
            x_2 <= x_3;
        end if;

        -- i = 1
        if x_2(11 downto 10) = (11 downto 10 => '0') then
            d_1 <= '1';
            x_1 <= x_2(9 downto 0) & (11 downto 10 => '0');
        else
            d_1 <= '0';
            x_1 <= x_2;
        end if;

        -- i = 0
        if x_1(11 downto 11) = (11 downto 11 => '0') then
            d_0 <= '1';
            x_0 <= x_1(10 downto 0) & (11 downto 11 => '0');
        else
            d_0 <= '0';
            x_0 <= x_1;
        end if;
    end process;

    nlzeros <= d_3 & d_2 & d_1 & d_0;
    y <= x_0;

end behaviour;