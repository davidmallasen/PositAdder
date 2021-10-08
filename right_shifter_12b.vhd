library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

-- Right shifter
entity right_shifter_12b is
    port (
        -- Input vector
        x     : in  std_logic_vector(11 downto 0);
        -- Number of bits to shift
        count : in  std_logic_vector(3 downto 0);
        -- Output vector right-shifted count bits
        y     : out std_logic_vector(11 downto 0)
    );
end right_shifter_12b;

architecture behaviour of right_shifter_12b is

    signal x_4 : std_logic_vector(11 downto 0);
    signal x_3 : std_logic_vector(11 downto 0);
    signal x_2 : std_logic_vector(11 downto 0);
    signal x_1 : std_logic_vector(11 downto 0);
    signal x_0 : std_logic_vector(11 downto 0);

begin
    
    x_4 <= x;

    x_3 <= x_4 when count(3) = '0' else
           (7 downto 0 => '0') & x_4(11 downto 8);

    x_2 <= x_3 when count(2) = '0' else
           (3 downto 0 => '0') & x_3(11 downto 4); 

    x_1 <= x_2 when count(1) = '0' else
           (1 downto 0 => '0') & x_2(11 downto 2);

    x_0 <= x_1 when count(0) = '0' else
           (0 downto 0 => '0') & x_1(11 downto 1);
   
    y <= x_0;

end behaviour;