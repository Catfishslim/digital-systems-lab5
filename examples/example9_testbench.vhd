entity adder_4_bit_testbench is
end adder_4_bit_testbench;

architecture behavior of adder_4_bit_testbench is

  -- define the maximum delay for the DUT
  constant MAX_DELAY : time := 20 ns;
  constant BIT_WIDTH : integer := 4;
  constant NO_VECTORS : integer := 5;

  -- declare a constant to hold an array of input values
  type input_value_array is array (1 to NO_VECTORS) of bit_vector(0 to BIT_WIDTH-1);
  type output_value_array is array (1 to NO_VECTORS) of bit_vector(0 to BIT_WIDTH-1);
  constant x_sig_values : input_value_array := ("0000","0001","0010","0011","0000");
  constant y_sig_values : input_value_array := ("0000","0001","0110","1101","0001");
  constant c_in_sig_values : bit_vector(1 to NO_VECTORS) := ('0','0','0','1','1');
  constant s_sig_values : output_value_array := ("0000","0010","1000","0001","0010");
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
      begin
        wait on x_sig; -- wait for event on x_sig
        wait for MAX_DELAY/2; -- wait half of the "cycle time"
        i := 1;
        while (i <= NO_VECTORS) loop -- look through input values
          exit when (x_sig = x_sig_values(i) AND y_sig = y_sig_values(i) AND
                     c_in_sig = c_in_sig_values(i));
          i := i + 1;
        end loop;
        
        assert i <= NO_VECTORS -- check to see that i is in bounds
          report "ERROR - no valid input value found"
          severity failure;
        
        assert s_sig = s_sig_values(i)
          report "ERROR - incorrect value on s_sig"
          severity error;
        
    end process monitor;
    
end behavior;