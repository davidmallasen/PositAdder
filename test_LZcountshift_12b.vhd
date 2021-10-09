library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_LZcountshift_12b is
end test_LZcountshift_12b;

architecture test of test_LZcountshift_12b is

    component LZcountshift_12b
        port (
            -- Input vector
            x       : in  std_logic_vector(11 downto 0);
            -- Number of leading zeros
            nlzeros : out unsigned(3 downto 0);
            -- Output vector left-shifted count bits
            y       : out std_logic_vector(11 downto 0)
        );
    end component;

    signal x : std_logic_vector(11 downto 0);
    signal nlzeros : unsigned(3 downto 0);
    signal y : std_logic_vector(11 downto 0);

begin

    DUT: LZcountshift_12b
        port map(
            x => x,
            nlzeros => nlzeros,
            y => y
        );
            
        process
        begin

            x <= "1" & (10 downto 0 => '0');

            wait for 1 ns;

            assert(nlzeros = 0)
            report "1 & zeros and nlzeros != 0" 
            severity error;

            assert(y = x)
            report "1 & zeros and y != x" 
            severity error;

            ----------

            x <= (10 downto 0 => '0') & "1";

            wait for 1 ns;

            assert(nlzeros = 11)
            report "zeros & 1 and nlzeros != 11" 
            severity error;

            assert(y = ("1" & (10 downto 0 => '0')))
            report "zeros & 1 and y != 1 & zeros" 
            severity error;

            ----------

            x <= (11 downto 0 => '0');

            wait for 1 ns;

            assert(nlzeros = 12)
            report "zeros and nlzeros != 12" 
            severity error;

            assert(y = (11 downto 0 => '0'))
            report "zeros and y != zeros" 
            severity error;

            ----------

            x <= "000001110011";

            wait for 1 ns;

            assert(nlzeros = 5)
            report "000001110011 and nlzeros != 5" 
            severity error;

            assert(y = "111001100000")
            report "000001110011 and wrong y" 
            severity error;

            ----------

            x <= "010100110110";

            wait for 1 ns;

            assert(nlzeros = 1)
            report "010100110110 and nlzeros != 1" 
            severity error;

            assert(y = "101001101100")
            report "010100110110 and wrong y" 
            severity error;

        end process;

end test;