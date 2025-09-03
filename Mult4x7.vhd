LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Mult4x7 IS
  PORT (
    a    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- Operando A (4 bits)
    b    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- Operando B (4 bits)
    prod : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)    -- Producto (7 bits)
  );
END ENTITY;

ARCHITECTURE RTL OF Mult4x7 IS

  COMPONENT N_Adder IS
    GENERIC ( N : INTEGER := 5 );
    PORT (
      ina  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      inb  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      sign : IN  STD_LOGIC;                 -- '1' = suma, '0' = resta
      sum  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      Cout : OUT STD_LOGIC
    );
  END COMPONENT;

  -- Productos parciales
  SIGNAL pp0, pp1, pp2, pp3 : STD_LOGIC_VECTOR(6 DOWNTO 0);

  -- Acumuladores
  SIGNAL acc0, acc1, acc2, acc3, acc4 : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

  -- Generación de productos parciales
  pp0 <= ("000" & a)         WHEN b(0) = '1' ELSE (OTHERS => '0');
  pp1 <= ("00"  & a & '0')   WHEN b(1) = '1' ELSE (OTHERS => '0');
  pp2 <= ("0"   & a & "00")  WHEN b(2) = '1' ELSE (OTHERS => '0');
  pp3 <= (        a & "000") WHEN b(3) = '1' ELSE (OTHERS => '0');

  acc0 <= (OTHERS => '0');

  -- Sumas parciales
  add0 : N_Adder
    GENERIC MAP ( N => 7 )
    PORT MAP (
      ina  => acc0,
      inb  => pp0,
      sign => '1',
      sum  => acc1,
      Cout => OPEN
    );

  add1 : N_Adder
    GENERIC MAP ( N => 7 )
    PORT MAP (
      ina  => acc1,
      inb  => pp1,
      sign => '1',
      sum  => acc2,
      Cout => OPEN
    );

  add2 : N_Adder
    GENERIC MAP ( N => 7 )
    PORT MAP (
      ina  => acc2,
      inb  => pp2,
      sign => '1',
      sum  => acc3,
      Cout => OPEN
    );

  add3 : N_Adder
    GENERIC MAP ( N => 7 )
    PORT MAP (
      ina  => acc3,
      inb  => pp3,
      sign => '1',
      sum  => acc4,
      Cout => OPEN
    );

  -- Resultado final
  prod <= acc4;

END ARCHITECTURE;
