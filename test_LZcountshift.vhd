library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_LZcountshift is
end test_LZcountshift;

architecture test of test_LZcountshift is

    component LZcountshift
        port (
            -- Input vector
            x       : in  std_logic_vector(13 downto 0);
            -- Number of leading zeros
            nlzeros : out unsigned(3 downto 0);
            -- Output vector left-shifted nlzeros bits
            y       : out std_logic_vector(13 downto 0)
        );
    end component;

    signal x : std_logic_vector(13 downto 0);
    signal nlzeros : unsigned(3 downto 0);
    signal y : std_logic_vector(13 downto 0);

begin

    DUT: LZcountshift
        port map(
            x       => x,
            nlzeros => nlzeros,
            y       => y
        );
            
        process
        begin

            x <= "1" & (12 downto 0 => '0');

            wait for 1 ns;

            assert(nlzeros = 0)
            report "1 & zeros and nlzeros != 0" 
            severity error;

            assert(y = x)
            report "1 & zeros and y != x" 
            severity error;

            ----------

            x <= (12 downto 0 => '0') & "1";

            wait for 1 ns;

            assert(nlzeros = 13)
            report "zeros & 1 and nlzeros != 13" 
            severity error;

            assert(y = ("1" & (12 downto 0 => '0')))
            report "zeros & 1 and y != 1 & zeros" 
            severity error;

            ----------

            x <= (13 downto 0 => '0');

            wait for 1 ns;

            assert(nlzeros = 14)
            report "zeros and nlzeros != 14" 
            severity error;

            assert(y = (13 downto 0 => '0'))
            report "zeros and y != zeros" 
            severity error;

            ----------

            x <= "00000111001100";

            wait for 1 ns;

            assert(nlzeros = 5)
            report "00000111001100 and nlzeros != 5" 
            severity error;

            assert(y = "11100110000000")
            report "00000111001100 and wrong y" 
            severity error;

            ----------

            x <= "01010011011000";

            wait for 1 ns;

            assert(nlzeros = 1)
            report "01010011011000 and nlzeros != 1" 
            severity error;

            assert(y = "10100110110000")
            report "01010011011000 and wrong y" 
            severity error;

        end process;

end test;