library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

-- Right shifter
entity right_shifter_round is
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
end right_shifter_round;

architecture behaviour of right_shifter_round is

    signal x_5 : std_logic_vector(17 downto 0);
    signal x_4 : std_logic_vector(17 downto 0);
    signal x_3 : std_logic_vector(17 downto 0);
    signal x_2 : std_logic_vector(17 downto 0);
    signal x_1 : std_logic_vector(17 downto 0);
    signal x_0 : std_logic_vector(17 downto 0);

    signal s_4 : std_logic;
    signal s_3 : std_logic;
    signal s_2 : std_logic;
    signal s_1 : std_logic;
    signal s_0 : std_logic;
    signal s_tmp : std_logic;

begin
    
    x_5 <= x;

    x_4 <= x_5 when count(4) = '0' else
           (15 downto 0 => prep_bit) & x_4(17 downto 16);
    s_4 <= '0' when count(4) = '0' else
           '0' when x_5(15 downto 0) = (15 downto 0 => '0') else 
           '1';

    x_3 <= x_4 when count(3) = '0' else
           (7 downto 0 => prep_bit) & x_4(17 downto 8);
    s_3 <= '0' when count(3) = '0' else
           '0' when x_4(7 downto 0) = (7 downto 0 => '0') else 
           '1';

    x_2 <= x_3 when count(2) = '0' else
           (3 downto 0 => prep_bit) & x_3(17 downto 4);
    s_2 <= '0' when count(2) = '0' else
           '0' when x_3(3 downto 0) = (3 downto 0 => '0') else 
           '1';

    x_1 <= x_2 when count(1) = '0' else
           (1 downto 0 => prep_bit) & x_2(17 downto 2);
    s_1 <= '0' when count(1) = '0' else
           '0' when x_2(1 downto 0) = (1 downto 0 => '0') else 
           '1';

    x_0 <= x_1 when count(0) = '0' else
           (0 downto 0 => prep_bit) & x_1(17 downto 1);
    s_0 <= '0' when count(0) = '0' else
           '0' when x_1(0 downto 0) = (0 downto 0 => '0') else 
           '1';

    s_tmp <= s_4 or s_3 or s_2 or s_1 or s_0;
    
    y <= x_0(17 downto 1) & (x_0(0) or s_tmp);

end behaviour;