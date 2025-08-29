library ieee;
use ieee.std_logic_1164.all;

entity Mult4x7 is
  port (
    a    : in  std_logic_vector(3 downto 0);  
    b    : in  std_logic_vector(3 downto 0);  
    prod : out std_logic_vector(6 downto 0)
  );
end entity;

architecture rtl of Mult4x7 is
  component N_Adder is
    generic ( N : integer := 5 );
    port (
      ina  : in  std_logic_vector(N-1 downto 0);
      inb  : in  std_logic_vector(N-1 downto 0);
      sign : in  std_logic;                 -- 
      sum  : out std_logic_vector(N-1 downto 0);
      Cout : out std_logic
    );
  end component;


  signal pp0, pp1, pp2, pp3 : std_logic_vector(6 downto 0);

  signal acc0, acc1, acc2, acc3, acc4 : std_logic_vector(6 downto 0);
begin
  pp0 <= ("000" & a)           when b(0) = '1' else (others => '0');
  pp1 <= ("00"  & a & '0')     when b(1) = '1' else (others => '0');
  pp2 <= ("0"   & a & "00")    when b(2) = '1' else (others => '0');
  pp3 <= (        a & "000")   when b(3) = '1' else (others => '0');

  acc0 <= (others => '0');

  add0: N_Adder generic map (N => 7)
        port map (ina => acc0, inb => pp0, sign => '1', sum => acc1, Cout => open);

  add1: N_Adder generic map (N => 7)
        port map (ina => acc1, inb => pp1, sign => '1', sum => acc2, Cout => open);

  add2: N_Adder generic map (N => 7)
        port map (ina => acc2, inb => pp2, sign => '1', sum => acc3, Cout => open);

  add3: N_Adder generic map (N => 7)
        port map (ina => acc3, inb => pp3, sign => '1', sum => acc4, Cout => open);

  prod <= acc4;
end architecture;