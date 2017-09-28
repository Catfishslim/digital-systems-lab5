entity n_bit_adder is
  generic(N : integer := 4);
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
      s(0) <= x(0) XOR y(0) XOR c_in;
      c(0) <= (x(0) AND c_in) OR (y(0) AND c_in) OR (x(0) AND y(0));
      -- now do the rest of the N bits
      for i in 1 to N-1 loop
        s(i) <= x(i) XOR y(i) XOR c(i-1);
        c(i) <= (x(i) AND c(i-1)) OR (y(i) AND c(i-1)) OR (x(i) AND y(i));
      end loop;
      -- assign c_out from carry of last adder
      c_out <= c(N-1);    
  end process add;
    
end simple;