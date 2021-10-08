library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_LZcountshift_15b is
end test_LZcountshift_15b;

architecture test of test_LZcountshift_15b is

    component LZcountshift_15b
        port (
            -- Input vector
            x       : in  std_logic_vector(14 downto 0);
            -- Number of leading zeros
            nlzeros : out unsigned(3 downto 0);
            -- Output vector left-shifted count bits
            y       : out std_logic_vector(14 downto 0)
        );
    end component;

    signal x : std_logic_vector(14 downto 0);
    signal nlzeros : unsigned(3 downto 0);
    signal y : std_logic_vector(14 downto 0);

begin

    DUT: LZcountshift_15b
        port map(
            x => x,
            nlzeros => nlzeros,
            y => y
        );
            
        process
        begin

            x <= "1" & (13 downto 0 => '0');

            wait for 1 ns;

            assert(nlzeros = 0)
            report "1 & zeros and nlzeros != 0" 
            severity error;

            assert(y = x)
            report "1 & zeros and y != x" 
            severity error;

            ----------

            x <= (13 downto 0 => '0') & "1";

            wait for 1 ns;

            assert(nlzeros = 14)
            report "zeros & 1 and nlzeros != 14" 
            severity error;

            assert(y = ("1" & (13 downto 0 => '0')))
            report "zeros & 1 and y != 1 & zeros" 
            severity error;

            ----------

            x <= "000001110011010";

            wait for 1 ns;

            assert(nlzeros = 5)
            report "000001110011010 and nlzeros != 5" 
            severity error;

            assert(y = "111001101000000")
            report "000001110011010 and wrong y" 
            severity error;

            ----------

            x <= "010100110110010";

            wait for 1 ns;

            assert(nlzeros = 1)
            report "010100110110010 and nlzeros != 1" 
            severity error;

            assert(y = "101001101100100")
            report "010100110110010 and wrong y" 
            severity error;

        end process;

end test;