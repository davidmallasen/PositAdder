library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity test_posit16_decoder is
    generic (
        N   : integer := 16;
        ES  : integer := 2;
        R_N : integer := 4;
        F_N : integer := 16-3-2+1 -- {N - (sign and minimum regime) - ES + (hidden fraction bit)}
    );
end test_posit16_decoder;

architecture test of test_posit16_decoder is
    component posit16_decoder
    port (
        x       : in  std_logic_vector(N-1 downto 0);
        sign    : out std_logic;
        regime  : out signed(R_N downto 0);
        exp     : out std_logic_vector(ES-1 downto 0);
        frac    : out std_logic_vector(F_N-1 downto 0);
        x_abs   : out std_logic_vector(N-2 downto 0);
        zero    : out std_logic;
        inf     : out std_logic
    );
    end component;

    signal x       : std_logic_vector(N-1 downto 0);
    signal sign    : std_logic;
    signal regime  : signed(R_N downto 0);
    signal exp     : std_logic_vector(ES-1 downto 0);
    signal frac    : std_logic_vector(F_N-1 downto 0);
    signal x_abs   : std_logic_vector(N-2 downto 0);
    signal zero    : std_logic;
    signal inf     : std_logic;
begin
    DUT: posit16_decoder
        port map(
            x => x,
            sign => sign,
            regime => regime,
            exp => exp,
            frac => frac,
            x_abs => x_abs,
            zero => zero,
            inf => inf
        );

    process
    begin
        x <= "1000000000000000";

        wait for 1 ns;

        assert(sign = '1')
        report "1000000000000000 wrong sign"
        severity error;

        assert(regime = "10001")
        report "1000000000000000 wrong regime"
        severity error;

        assert(exp = "00")
        report "1000000000000000 wrong exp"
        severity error;

        assert(frac = ("000000000000"))
        report "1000000000000000 wrong frac"
        severity error;

        assert(x_abs = ("000000000000000"))
        report "1000000000000000 wrong x_abs"
        severity error;

        assert(zero = '0')
        report "1000000000000000 wrong zero"
        severity error;

        assert(inf = '1')
        report "1000000000000000 wrong inf"
        severity error;

        ----------

        x <= "0000000000000001";
        
        wait for 1 ns;

        assert(sign = '0')
        report "0000000000000001 wrong sign"
        severity error;

        assert(regime = "10010")
        report "0000000000000001 wrong regime"
        severity error;

        assert(exp = "00")
        report "0000000000000001 wrong exp"
        severity error;

        assert(frac = ("100000000000"))
        report "0000000000000001 wrong frac"
        severity error;

        assert(x_abs = ("000000000000001"))
        report "0000000000000001 wrong x_abs"
        severity error;

        assert(zero = '0')
        report "0000000000000001 wrong zero"
        severity error;

        assert(inf = '0')
        report "0000000000000001 wrong inf"
        severity error;

        ----------

        x <= "0000001110011010";

        wait for 1 ns;

        assert(sign = '0')
        report "0000001110011010 wrong sign"
        severity error;

        assert(regime = "11011")
        report "0000001110011010 wrong regime"
        severity error;

        assert(exp = "11")
        report "0000001110011010 wrong exp"
        severity error;

        assert(frac = ("100110100000"))
        report "0000001110011010 wrong frac"
        severity error;

        assert(x_abs = ("000001110011010"))
        report "0000001110011010 wrong x_abs"
        severity error;

        assert(zero = '0')
        report "0000001110011010 wrong zero"
        severity error;

        assert(inf = '0')
        report "0000001110011010 wrong inf"
        severity error;

        ----------

        x <= "1000001110011010";

        wait for 1 ns;

        assert(sign = '1')
        report "1000001110011010 wrong sign"
        severity error;

        assert(regime = "00100")
        report "1000001110011010 wrong regime"
        severity error;

        assert(exp = "00")
        report "1000001110011010 wrong exp"
        severity error;

        assert(frac = ("111001100000"))
        report "1000001110011010 wrong frac"
        severity error;

        assert(x_abs = ("111110001100110"))
        report "1000001110011010 wrong x_abs"
        severity error;

        assert(zero = '0')
        report "1000001110011010 wrong zero"
        severity error;

        assert(inf = '0')
        report "1000001110011010 wrong inf"
        severity error;

        ----------

        x <= "0010100110110010";

        wait for 1 ns;

        assert(sign = '0')
        report "0010100110110010 wrong sign"
        severity error;

        assert(regime = "11111")
        report "0010100110110010 wrong regime"
        severity error;

        assert(exp = "01")
        report "0010100110110010 wrong exp"
        severity error;

        assert(frac = ("100110110010"))
        report "0010100110110010 wrong frac"
        severity error;

        assert(x_abs = ("010100110110010"))
        report "0010100110110010 wrong x_abs"
        severity error;

        assert(zero = '0')
        report "0010100110110010 wrong zero"
        severity error;

        assert(inf = '0')
        report "0010100110110010 wrong inf"
        severity error;

        ----------

        x <= "1010100110110010";

        wait for 1 ns;

        assert(sign = '1')
        report "0010100110110010 wrong sign"
        severity error;

        assert(regime = "00000")
        report "0010100110110010 wrong regime"
        severity error;

        assert(exp = "10")
        report "0010100110110010 wrong exp"
        severity error;

        assert(frac = ("111001001110"))
        report "0010100110110010 wrong frac"
        severity error;

        assert(x_abs = ("101011001001110"))
        report "0010100110110010 wrong x_abs"
        severity error;

        assert(zero = '0')
        report "0010100110110010 wrong zero"
        severity error;

        assert(inf = '0')
        report "0010100110110010 wrong inf"
        severity error;

        ----------

        x <= "0111111110110010";

        wait for 1 ns;

        assert(sign = '0')
        report "0111111110110010 wrong sign"
        severity error;

        assert(regime = "00111")
        report "0111111110110010 wrong regime"
        severity error;

        assert(exp = "11")
        report "0111111110110010 wrong exp"
        severity error;

        assert(frac = ("100100000000"))
        report "0111111110110010 wrong frac"
        severity error;

        assert(x_abs = ("111111110110010"))
        report "0111111110110010 wrong x_abs"
        severity error;

        assert(zero = '0')
        report "0111111110110010 wrong zero"
        severity error;

        assert(inf = '0')
        report "0111111110110010 wrong inf"
        severity error;

        ----------

        x <= "1111111110110010";

        wait for 1 ns;

        assert(sign = '1')
        report "1111111110110010 wrong sign"
        severity error;

        assert(regime = "11000")
        report "1111111110110010 wrong regime"
        severity error;

        assert(exp = "00")
        report "1111111110110010 wrong exp"
        severity error;

        assert(frac = ("111100000000"))
        report "1111111110110010 wrong frac"
        severity error;

        assert(x_abs = ("000000001001110"))
        report "1111111110110010 wrong x_abs"
        severity error;

        assert(zero = '0')
        report "1111111110110010 wrong zero"
        severity error;

        assert(inf = '0')
        report "1111111110110010 wrong inf"
        severity error;

        ----------

    end process ;
end test;