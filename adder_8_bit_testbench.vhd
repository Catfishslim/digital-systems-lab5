library STD;
use STD.textio.all; -- used for printing output to a txt file for easier documentation
library IEEE;
use IEEE.std_logic_1164.all; -- for std logic tpes
use IEEE.numeric_std.all; -- good for typecasting opperations
use IEEE.std_logic_textio.all;


entity adder_8_bit_testbench is
end adder_8_bit_testbench;

architecture behavior of adder_8_bit_testbench is

  -- define the maximum delay for the DUT
  constant BIT_WIDTH : integer := 8;
  constant MAX_DELAY : time := (2*BIT_WIDTH*14)* 1 ns;-- 2*NumBits*(2*XOR_time)
  constant NO_VECTORS : integer := 5;

  -- declare a constant to hold an array of input values
  type input_value_array is array (1 to NO_VECTORS) of bit_vector(0 to BIT_WIDTH-1);
  type output_value_array is array (1 to NO_VECTORS) of bit_vector(0 to BIT_WIDTH-1);
  constant x_sig_values : input_value_array := ("00000000","00010000","00000010","11110000","00000000");
  constant y_sig_values : input_value_array := ("00000000","00010000","00000110","01001101","00000001");
  constant c_in_sig_values : bit_vector(1 to NO_VECTORS) := ('0','0','0','1','1');
  constant s_sig_values : output_value_array := ("00000000","00100000","00001000","00111110","00000010");
  constant c_out_sig_values : bit_vector(1 to NO_VECTORS) := ('0','0','0','1','0');

  -- define signals that connect to DUT
  signal x_sig, y_sig, s_sig  : bit_vector(0 to BIT_WIDTH-1);
  signal c_in_sig, c_out_sig : bit;
  
  begin
  
    -- this is the process that will generate the inputs
    stimulus : process
      begin
        for i in 1 to NO_VECTORS loop
          x_sig <= x_sig_values(i);
          y_sig <= y_sig_values(i);
          c_in_sig <= c_in_sig_values(i);
          wait for MAX_DELAY;
        end loop;
        wait; -- stop the process to avoid an infinite loop
    end process stimulus;

    -- this is the component instantiation for the
    -- DUT - the device we are testing
    DUT : entity work.n_bit_adder(simple)
      generic map(N => BIT_WIDTH)
      port map(x => x_sig, y => y_sig, c_in => c_in_sig,
               c_out => c_out_sig, s => s_sig);

    -- this is the (optional) process that will monitor 
    -- the outputs
    monitor : process
      variable i : integer;
      variable L : line;
      begin
        wait on x_sig; -- wait for event on x_sig
        wait for MAX_DELAY/2; -- wait half of the "cycle time"
        i := 1;
        while (i <= NO_VECTORS) loop -- look through input values
          exit when (x_sig = x_sig_values(i) AND y_sig = y_sig_values(i) AND
                     c_in_sig = c_in_sig_values(i));
          i := i + 1;
        end loop;
        deallocate (L);  -- get rid of leftovers from last time 
        assert i <= NO_VECTORS -- check to see that i is in bounds
          report "ERROR - no valid input value found"
          severity failure;
        
        if( s_sig /= s_sig_values(i)) then
	  write(L, string'("ERROR - incorrect value on s_sig: s_sig = "));
          write(L, s_sig);
          write(L, string'(", s_sig_values(i) = "));
          write(L, s_sig_values(i));
	  write(L, string'(", i = "));
	  write(L, i);
          report L.all
		
          severity error;
	end if;
        
    end process monitor;
    
end behavior;