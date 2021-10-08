library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_posit_regime_extractor is
end test_posit_regime_extractor;

architecture test of test_posit_regime_extractor is

    component posit_regime_extractor
        port (
            -- Input posit vector without sign bit
            x       : in  std_logic_vector(14 downto 0);
            -- Final regime value of x
            regime  : out signed(4 downto 0);
            -- Output posit vector with regime bits shifted out
            y       : out std_logic_vector(14 downto 0)
        );
    end component;

    signal x      : std_logic_vector(14 downto 0);
    signal regime : signed(4 downto 0);
    signal y      : std_logic_vector(14 downto 0);

begin

    DUT: posit_regime_extractor
        port map(
            x => x,
            regime => regime,
            y => y
        );
            
        process
        begin

            x <= "1" & (13 downto 0 => '0');

            wait for 1 ns;

            assert(regime = -1)
            report "Regime should be -1" 
            severity error;

            assert(y = (14 downto 0 => '0'))
            report "Expected result -> 000000000000000" 
            severity error;

            ----------

            x <= (13 downto 0 => '0') & "1";

            wait for 1 ns;

            assert(regime = 13)
            report "Regime should be 13" 
            severity error;

            assert(y = (14 downto 0 => '0'))
            report "Expected result -> 000000000000000" 
            severity error;

            ----------

            x <= "000001110011010";

            wait for 1 ns;

            assert(regime = 4)
            report "Regime should be 4" 
            severity error;

            assert(y = "110011010000000")
            report "Expected result -> 110011010000000" 
            severity error;

            ----------

            x <= "010100110110010";

            wait for 1 ns;

            assert(regime = 0)
            report "Regime should be 0" 
            severity error;

            assert(y = "010011011001000")
            report "Expected result -> 010011011001000" 
            severity error;

            ----------

            x <= "111111110110010";

            wait for 1 ns;

            assert(regime = -8)
            report "Regime should be -8" 
            severity error;

            assert(y = "110010000000000")
            report "Expected result -> 110010000000000" 
            severity error;
            
            ----------

            x <= "000000000000000";

            wait for 1 ns;

            assert(regime = 14)
            report "Regime should be 14" 
            severity error;

            assert(y = "000000000000000")
            report "Expected result -> 000000000000000" 
            severity error;

            ----------

            x <= "111111111111111";

            wait for 1 ns;

            assert(regime = -15)
            report "Regime should be -15" 
            severity error;

            assert(y = "000000000000000")
            report "Expected result -> 000000000000000" 
            severity error;
        end process;

end test;