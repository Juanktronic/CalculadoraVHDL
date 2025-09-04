LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------
-- Archivo      : Mult4x7
-- Descripción  : Este código implementa un multiplicador de 4x4 bits
--                que produce un resultado de 7 bits. Utiliza el método
--                de productos parciales con desplazamiento y sumas
--                acumulativas para realizar la multiplicación binaria.
-- Autores      : Mojica, Guevara y Díaz
-- Fecha        : [27/08/25]
------------------------------------------------------------
-- Detalles:
--   - Propósito: Multiplicar dos números de 4 bits (0-15 decimal)
--   - Entradas : a y b (Números binarios de 4 bits cada uno)
--   - Salidas  : prod (Resultado de 7 bits, máximo valor 81)
--   - Método   : Productos parciales con sumas acumulativas
------------------------------------------------------------

ENTITY Mult4x7 IS
  PORT (
    a    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- Multiplicando (4 bits)
    b    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- Multiplicador (4 bits)  
    prod : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)    -- Producto final (7 bits)
  );
END ENTITY;

ARCHITECTURE RTL OF Mult4x7 IS
  
  -- Declaración del componente sumador de N bits
  COMPONENT N_Adder IS
    GENERIC ( N : INTEGER := 5 );              -- Parámetro configurable de ancho
    PORT (
      ina  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);  -- Primer operando
      inb  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);  -- Segundo operando
      sign : IN  STD_LOGIC;                       -- Control: '1'=suma, '0'=resta
      sum  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);  -- Resultado de la operación
      Cout : OUT STD_LOGIC                        -- Carry de salida
    );
  END COMPONENT;

  -- Señales para los productos parciales (cada bit de 'b' multiplica 'a')
  -- Estos representan los vectores desplazados para la suma parcial
  SIGNAL pp0, pp1, pp2, pp3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
  
  -- Señales acumuladoras para las sumas parciales secuenciales
  -- acc0: valor inicial (cero)
  -- acc1: acc0 + pp0
  -- acc2: acc1 + pp1  
  -- acc3: acc2 + pp2
  -- acc4: acc3 + pp3 (resultado final)
  SIGNAL acc0, acc1, acc2, acc3, acc4 : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN
 
  -- Cada producto parcial corresponde a multiplicar 'a' por un bit de 'b'
  -- Si el bit correspondiente de 'b' es '1', se toma 'a' desplazado
  -- Si el bit es '0', el producto parcial es cero
  pp0 <= ("000" & a)         WHEN b(0) = '1' ELSE (OTHERS => '0');
  pp1 <= ("00"  & a & '0')   WHEN b(1) = '1' ELSE (OTHERS => '0');
  pp2 <= ("0"   & a & "00")  WHEN b(2) = '1' ELSE (OTHERS => '0');
  pp3 <= (        a & "000") WHEN b(3) = '1' ELSE (OTHERS => '0');

  -- Inicialización del acumulador con ceros
  acc0 <= (OTHERS => '0');

  -- Sumas parciales
  -- Se van sumando secuencialmente los productos parciales
  -- Cada suma utiliza el resultado de la suma anterior
  add0 : N_Adder
    GENERIC MAP ( N => 7 )                     -- Configura el sumador para 7 bits
    PORT MAP (
      ina  => acc0,                            -- Entrada: ceros
      inb  => pp0,                             -- Entrada: primer producto parcial
      sign => '1',                             -- Operación: suma
      sum  => acc1,                            -- Resultado: acc1 = pp0
      Cout => OPEN                             -- Carry no utilizado
    );

  add1 : N_Adder
    GENERIC MAP ( N => 7 )
    PORT MAP (
      ina  => acc1,                            -- Entrada: resultado anterior
      inb  => pp1,                             -- Entrada: segundo producto parcial
      sign => '1',                             -- Operación: suma
      sum  => acc2,                            -- Resultado: acc2 = acc1 + pp1
      Cout => OPEN                             -- Carry no utilizado
    );

  add2 : N_Adder
    GENERIC MAP ( N => 7 )
    PORT MAP (
      ina  => acc2,                            -- Entrada: resultado anterior
      inb  => pp2,                             -- Entrada: tercer producto parcial
      sign => '1',                             -- Operación: suma
      sum  => acc3,                            -- Resultado: acc3 = acc2 + pp2
      Cout => OPEN                             -- Carry no utilizado
    );

  add3 : N_Adder
    GENERIC MAP ( N => 7 )
    PORT MAP (
      ina  => acc3,                            -- Entrada: resultado anterior
      inb  => pp3,                             -- Entrada: cuarto producto parcial
      sign => '1',                             -- Operación: suma
      sum  => acc4,                            -- Resultado: producto final
      Cout => OPEN                             -- Carry no utilizado
    );

  -- El resultado final es la última suma acumulativa
  prod <= acc4;

END ARCHITECTURE;
