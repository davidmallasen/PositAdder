library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use work.all;

entity test_posit16_adder is
end test_posit16_adder;

architecture test of test_posit16_adder is

    component posit16_adder
        port (
            x : in  std_logic_vector(15 downto 0);
            y : in  std_logic_vector(15 downto 0);
            r : out std_logic_vector(15 downto 0)
        );
    end component;

    file file_in  : text;
    file file_out : text;

    signal x : std_logic_vector(15 downto 0);
    signal y : std_logic_vector(15 downto 0);
    signal r : std_logic_vector(15 downto 0);

begin

    DUT: posit16_adder
        port map(
            x => x,
            y => y,
            r => r
        );
            
    process
        variable line_in  : line;
        variable line_out : line;
        variable add1 : std_logic_vector(15 downto 0);
        variable add2 : std_logic_vector(15 downto 0);
    begin

        file_open(file_in, "posit_input.txt",  read_mode);
        file_open(file_out, "posit_output.txt", write_mode);

        while not endfile(file_in) loop
            readline(file_in, line_in);
            read(line_in, add1);
            readline(file_in, line_in);
            read(line_in, add2);

            x <= add1;
            y <= add2;
     
            wait for 1 ns;
     
            write(line_out, r, right, 16);
            writeline(file_out, line_out);
        end loop;
     
        file_close(file_in);
        file_close(file_out);
         
        wait for 1 ns;

        assert(false)
        report "Simulation finished"
        severity failure;

    end process;

end test;