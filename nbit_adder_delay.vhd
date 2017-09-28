
--Time to correct value is: 14 ns per bit 


entity n_bit_adder is
  generic(N : integer := 4;
    delay_not : time := 3 ns;
    delay_and : time := 4 ns;
    delay_or  : time := 5 ns;
    delay_xor : time := 7 ns);

  port(x,y   : in bit_vector(N-1 downto 0);
       c_in  : in bit;
       c_out : out bit;
       s     : out bit_vector(N-1 downto 0));
end n_bit_adder;

architecture simple of n_bit_adder is

  signal c : bit_vector(N-1 downto 0);
  begin
  
  -- use a process here because we need sequential statements
  add : process(x,y,c_in,c)
    begin
      -- the first bit is a special case because of c_in
      s(0) <= x(0) XOR y(0) XOR c_in after (delay_xor *2 );
      c(0) <= (x(0) AND c_in) OR (y(0) AND c_in) OR (x(0) AND y(0)) after (delay_and + 2*delay_or); --using two AND delays because two of the gates are run parallel
      -- now do the rest of the N bits
      for i in 1 to N-1 loop
        s(i) <= x(i) XOR y(i) XOR c(i-1) after (delay_xor*2);
        c(i) <= (x(i) AND c(i-1)) OR (y(i) AND c(i-1)) OR (x(i) AND y(i)) after (delay_and + 2*delay_or); --using two AND delays because two of the gates are run parallel
      end loop;
      -- assign c_out from carry of last adder
      c_out <= c(N-1);    
  end process add;
    
end simple;