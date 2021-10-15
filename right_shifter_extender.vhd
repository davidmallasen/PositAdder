library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

-- Right shifter that extends the input vector and keeps the discarded bits as a sticky bit
entity right_shifter_extender is
    port (
        -- Input vector
        x     : in  std_logic_vector(11 downto 0);
        -- Number of bits to shift
        count : in  std_logic_vector(3 downto 0);
        -- Output vector right-shifted count bits which keeps sticky bits to the right
        y     : out std_logic_vector(14 downto 0)
    );
end right_shifter_extender;

architecture behaviour of right_shifter_extender is

    signal x_4 : std_logic_vector(14 downto 0);
    signal x_3 : std_logic_vector(14 downto 0);
    signal x_2 : std_logic_vector(14 downto 0);
    signal x_1 : std_logic_vector(14 downto 0);
    signal x_0 : std_logic_vector(14 downto 0);

    signal s_3 : std_logic;
    signal s_2 : std_logic;
    signal s_1 : std_logic;
    signal s_0 : std_logic;
    signal s   : std_logic;

begin
    
    x_4 <= x & "000";

    x_3 <= x_4 when count(3) = '0' else
           (7 downto 0 => '0') & x_4(14 downto 8);
    s_3 <= '0' when count(3) = '0' else
           '0' when x_4(7 downto 0) = (7 downto 0 => '0') else 
           '1';

    x_2 <= x_3 when count(2) = '0' else
           (3 downto 0 => '0') & x_3(14 downto 4); 
    s_2 <= '0' when count(2) = '0' else
           '0' when x_3(3 downto 0) = (3 downto 0 => '0') else 
           '1';

    x_1 <= x_2 when count(1) = '0' else
           (1 downto 0 => '0') & x_2(14 downto 2);
    s_1 <= '0' when count(1) = '0' else
           '0' when x_2(1 downto 0) = (1 downto 0 => '0') else 
           '1';

    x_0 <= x_1 when count(0) = '0' else
           (0 downto 0 => '0') & x_1(14 downto 1);
    s_0 <= '0' when count(0) = '0' else
           '0' when x_1(0 downto 0) = (0 downto 0 => '0') else 
           '1';
    
    s <= s_3 or s_2 or s_1 or s_0;
    y <= x_0(14 downto 1) & (x_0(0) or s);

end behaviour;