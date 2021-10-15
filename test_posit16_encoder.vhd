library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_posit16_encoder is
end test_posit16_encoder;

architecture test of test_posit16_encoder is

    signal sign    : std_logic;
    signal sf      : std_logic_vector(6 downto 0);
    signal frac    : std_logic_vector(14 downto 0);
    signal inf     : std_logic;
    signal x       : std_logic_vector(15 downto 0);

    component posit16_encoder
        port (
            sign    : in  std_logic;
            sf      : in std_logic_vector(6 downto 0);
            frac    : in std_logic_vector(14 downto 0);
            inf     : in std_logic;
            x       : out std_logic_vector(15 downto 0)
        );
    end component;

begin

    DUT: posit16_encoder
        port map(
            sign => sign,
            sf => sf,
            frac => frac,
            inf => inf,
            x => x
        );

    process
    begin
        -- Test 1

        sign <= '1';
        sf <= "10001" & "00";
        frac <= "000000000000000";
        inf <= '1';
        wait for 1 ns;
        assert(x = "1000000000000000")
        report "Test 1 should be 1000000000000000"
        severity error;

        -- Test 2

        sign <= '0';
        sf <= "10010" & "00";
        frac <= "100000000000000";
        inf <= '0';
        wait for 1 ns;
        assert(x = "0000000000000001")
        report "Test 2 should be 0000000000000001"
        severity error;
        
        -- Test 3

        sign <= '0';
        sf <= "11011" & "11";
        frac <= "100110100000000"; 
        inf <= '0';
        wait for 1 ns;
        assert(x = "0000001110011010")
        report "Test 3 should be 0000001110011010"
        severity error;

        -- Test 4

        sign <= '1';
        sf <= "00100" & "00";
        frac <= "111001100000000";
        inf <= '0';
        wait for 1 ns;
        assert(x = "1000001110011010")
        report "Test 4 should be 1000001110011010"
        severity error;

        -- Test 5

        sign <= '0';
        sf <= "11111" & "01";
        frac <= "100110110010000"; 
        inf <= '0';
        wait for 1 ns;
        assert(x = "0010100110110010")
        report "Test 5 should be 0010100110110010"
        severity error;

        -- Test 6

        sign <= '1';
        sf <= "00000" & "10";
        frac <= "111001001110000"; 
        inf <= '0';
        wait for 1 ns;
        assert(x = "1010100110110010")
        report "Test 6 should be 1010100110110010"
        severity error;

        -- Test 7

        sign <= '0';
        sf <= "00111" & "11";
        frac <= "100100000000000"; 
        inf <= '0';
        wait for 1 ns;
        assert(x = "0111111110110010")
        report "Test 7 should be 0111111110110010"
        severity error;

        -- Test 8

        sign <= '1';
        sf <= "11000" & "00";
        frac <= "111100000000000";
        inf <= '0';
        wait for 1 ns;
        assert(x = "1111111110110010")
        report "Test 8 should be 1111111110110010"
        severity error;

        -- Test 9

        sign <= '0';
        sf <= "00001" & "00";
        frac <= "100010111011000";
        inf <= '0';
        wait for 1 ns;
        assert(x = "0110000001011110")
        report "Test 9 should be 0110000001011110"
        severity error;

        -- Test 10

        sign <= '1';
        sf <= "00001" & "11";
        frac <= "101001000011000";
        inf <= '0';
        wait for 1 ns;
        assert(x = "1001001011011110")
        report "Test 10 should be 1001001011011110"
        severity error;

    end process;
end test ;