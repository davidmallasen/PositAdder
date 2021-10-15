library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_right_shifter_12b is
end test_right_shifter_12b;

architecture test of test_right_shifter_12b is

    component right_shifter_12b
        port (
            -- Input vector
            x     : in  std_logic_vector(11 downto 0);
            -- Number of bits to shift
            count : in  std_logic_vector(3 downto 0);
            -- Output vector right-shifted count bits
            y     : out std_logic_vector(14 downto 0)
        );
    end component;

    signal x     : std_logic_vector(11 downto 0);
    signal count : std_logic_vector(3 downto 0);
    signal y     : std_logic_vector(14 downto 0);

begin

    DUT: right_shifter_12b
        port map(
            x => x,
            count => count,
            y => y
        );
            
        process
        begin

            x <= "000001110011";
            count <= "0000";

            wait for 1 ns;

            assert(y = "000001110011000")
            report "000001110011 and count 0 wrong" 
            severity error;

            ----------

            x <= "010001110011";
            count <= "1111";

            wait for 1 ns;

            assert(y = "000000000000001")
            report "010001110011 and count 15 wrong" 
            severity error;

            ----------

            x <= "100001110011";
            count <= "1100";

            wait for 1 ns;

            assert(y = "000000000000101")
            report "010001110011 and count 12 wrong" 
            severity error;

            ----------

            x <= "100001110011";
            count <= "0111";

            wait for 1 ns;

            assert(y = "000000010000111")
            report "100001110011 and count 7 wrong" 
            severity error;

            ----------

            x <= "100001110011";
            count <= "0001";

            wait for 1 ns;

            assert(y = "010000111001100")
            report "100001110011 and count 1 wrong" 
            severity error;

            ----------

            x <= "100001110011";
            count <= "0010";

            wait for 1 ns;

            assert(y = "001000011100110")
            report "100001110011 and count 2 wrong" 
            severity error;

            wait for 1 ns;

            assert(false)
            report "END OF TEST" 
            severity failure;

        end process;

end test;