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
  signal pp0, pp1, pp2, pp3 : std_logic_vector(6 downto 0);
  signal acc0, acc1, acc2, acc3, acc4 : std_logic_vector(6 downto 0);
  signal carry0, carry1, carry2, carry3 : std_logic; 
begin
  pp0 <= ("000" & a)           when b(0) = '1' else (others => '0');
  pp1 <= ("00"  & a & '0')     when b(1) = '1' else (others => '0');
  pp2 <= ("0"   & a & "00")    when b(2) = '1' else (others => '0');
  pp3 <= (        a & "000")   when b(3) = '1' else (others => '0');

  acc0 <= (others => '0');
  add0: ENTITY work.N_Adder1
        GENERIC MAP (N => 7)
        PORT MAP (
            ina  => acc0,
            inb  => pp0,
            sign => '1',
            sum  => acc1,
            Cout => carry0
        );
        
  add1: ENTITY work.N_Adder1
        GENERIC MAP (N => 7)
        PORT MAP (
            ina  => acc1,
            inb  => pp1,
            sign => '1',
            sum  => acc2,
            Cout => carry1
        );
        
  add2: ENTITY work.N_Adder1
        GENERIC MAP (N => 7)
        PORT MAP (
            ina  => acc2,
            inb  => pp2,
            sign => '1',
            sum  => acc3,
            Cout => carry2
        );
        
  add3: ENTITY work.N_Adder1
        GENERIC MAP (N => 7)
        PORT MAP (
            ina  => acc3,
            inb  => pp3,
            sign => '1',
            sum  => acc4,
            Cout => carry3
        );
        
  prod <= acc4;
end architecture;
