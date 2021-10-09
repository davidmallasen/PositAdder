library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_right_shifter_round_17b is
end test_right_shifter_round_17b;

architecture test of test_right_shifter_round_17b is

    component right_shifter_round_17b
        port (
        -- Input vector
        x        : in  std_logic_vector(16 downto 0);
        -- Number of bits to shift
        count    : in  std_logic_vector(4 downto 0);
        -- Bit to prepend when shifting
        prep_bit : in std_logic;
        -- Output vector right-shifted count bits
        y        : out std_logic_vector(16 downto 0);
        -- Sticky bit (OR of the discarded right bits)
        s        : out std_logic
    );
    end component;

    signal x        : std_logic_vector(16 downto 0);
    signal count    : std_logic_vector(4 downto 0);
    signal prep_bit : std_logic;
    signal y        : std_logic_vector(16 downto 0);
    signal s        : std_logic;

begin

    DUT: right_shifter_round_17b
        port map(
            x        => x,
            count    => count,
            prep_bit => prep_bit,
            y        => y,
            s        => s
        );
            
        process
        begin

            x <= "00000000001110011";
            count <= "00000";
            prep_bit <= '0';

            wait for 1 ns;

            assert(y = "00000000001110011")
            report "00000000001110011, count 0 and prep_bit 0 wrong y" 
            severity error;

            assert(s = '0')
            report "00000000001110011, count 0 and prep_bit 0 wrong s" 
            severity error;

            ----------

            x <= "00000010001110011";
            count <= "11111";
            prep_bit <= '1';

            wait for 1 ns;

            assert(y = "11111111111111111")
            report "00000010001110011, count 31 and prep_bit 1 wrong y" 
            severity error;

            assert(s = '1')
            report "00000010001110011, count 31 and prep_bit 1 wrong s" 
            severity error;

            ----------

            x <= "00000100001110011";
            count <= "10001";
            prep_bit <= '0';

            wait for 1 ns;

            assert(y = "00000000000000000")
            report "00000100001110011, count 17 and prep_bit 0 wrong y"
            severity error;

            assert(s = '1')
            report "00000100001110011, count 17 and prep_bit 0 wrong s" 
            severity error;

            ----------

            x <= "00000100001110011";
            count <= "00111";
            prep_bit <= '1';

            wait for 1 ns;

            assert(y = "11111110000010000")
            report "00000100001110011, count 7 and prep_bit 1 wrong y"
            severity error;

            assert(s = '1')
            report "00000100001110011, count 7 and prep_bit 1 wrong s"
            severity error;

            ----------

            x <= "00000100001110011";
            count <= "00001";
            prep_bit <= '0';

            wait for 1 ns;

            assert(y = "00000010000111001")
            report "00000100001110011, count 1 and prep_bit 0 wrong y"
            severity error;

            assert(s = '1')
            report "00000100001110011, count 1 and prep_bit 0 wrong s"
            severity error;

            ----------

            x <= "00000100001110010";
            count <= "00001";
            prep_bit <= '0';

            wait for 1 ns;

            assert(y = "00000010000111001")
            report "00000100001110010, count 1 and prep_bit 0 wrong y"
            severity error;

            assert(s = '0')
            report "00000100001110010, count 1 and prep_bit 0 wrong s"
            severity error;

            ----------

            x <= "00000100001110011";
            count <= "00010";
            prep_bit <= '1';

            wait for 1 ns;

            assert(y = "11000001000011100")
            report "00000100001110011, count 2 and prep_bit 1 wrong y"
            severity error;

            assert(s = '1')
            report "00000100001110011, count 2 and prep_bit 1 wrong s"
            severity error;

        end process;

end test;