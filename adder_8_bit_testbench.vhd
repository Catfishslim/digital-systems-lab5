library STD;
use STD.textio.all; -- used for printing output to a txt file for easier documentation
library IEEE;
use IEEE.std_logic_1164.all; -- for std logic tpes
use IEEE.numeric_std.all; -- good for typecasting opperations
use IEEE.std_logic_textio.all;


entity adder_8_bit_testbench is
end adder_8_bit_testbench;

architecture behavior of adder_8_bit_testbench is

  -- define the device parameters
  constant BIT_WIDTH : integer := 8;
  constant DELAY_RES : time :=  1 ns; 
  constant MAX_DELAY : time := 0 ns; --not needed when testing component response time
  constant NO_VECTORS : integer := 1;

   --declare a constant to hold an array of input values
 
  --for response time testing, chose input values to test the most carry operations possible
  constant x_sig_values : bit_vector(BIT_WIDTH-1 downto 0) := ("11111111");
  constant y_sig_values : bit_vector(BIT_WIDTH-1 downto 0) := ("00000001");
  constant c_in_sig_values : bit := ('1');
  constant s_sig_values : bit_vector := ("00000001");
  constant c_out_sig_values : bit := ('1');

  -- define signals that connect to DUT
  signal x_sig, y_sig, s_sig  : bit_vector(0 to BIT_WIDTH-1);
  signal c_in_sig, c_out_sig : bit;
  
  begin
  
    -- this is the process that will generate the inputs
    stimulus : process
      begin
        
          x_sig <= x_sig_values;
          y_sig <= y_sig_values;
          c_in_sig <= c_in_sig_values;
          wait for MAX_DELAY;
        
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
        
        i := 0;
        while (x_sig = x_sig_values AND y_sig = y_sig_values) loop -- look through input values
          exit when (s_sig = s_sig_values);
          wait for DELAY_RES;
          i := i + 1;
        end loop;


                
        write(L, string'("Time until correct value: "));
        write(L, i); 
        write(L, string'("ns."));
        
        report L.all;
     wait;   
    end process monitor;
    
end behavior;