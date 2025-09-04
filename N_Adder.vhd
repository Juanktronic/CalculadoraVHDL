LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------
-- Archivo      : N_Adder.vhd
-- Descripción  : Código sumador genérico. Esta entidad
--                es usada para sumar dos arreglos de N
--                número de bits. Usa Full adders N veces 
--                para hacer una suma por cada posicición.  
--                Cuenta con una opción de resta que permite
--                sumar el primer número de entrada con el 
--                complemento a dos de la segunda entrada.
-- Autores      : Mojica, Guevara y Díaz.
-- Fecha        : [01/09/25]
------------------------------------------------------------
-- Detalles:
--   - Propósito: hacer sumas y restas de arreglos.
--   - Entradas : ina: primer arreglo de entrada.
--                inb: segundo arreglo de entrada.
--                Add_or_Mul: 1 para suma 0 para multiplicación.
--                Sum_Or_Sub: 1 para suma 0 para resta.
--                Sign: Indicador de suma o resta.
--   - Salidas  : sum: Resultado de la operación de las entradas.
--                Cout: Acarreo de salida de la operacón.
------------------------------------------------------------

ENTITY N_Adder IS
  GENERIC (
    N : INTEGER := 5   -- Tamaño de las entradas y la salida
              );
  PORT (
    ina  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    inb  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	 sign : IN  STD_LOGIC;
    sum  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    Cout : OUT STD_LOGIC
  );
END ENTITY N_Adder;

ARCHITECTURE structural OF N_Adder IS
  SIGNAL c : STD_LOGIC_VECTOR(N DOWNTO 0);
  SIGNAL inb_Complement : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN

	inb_Complement <= NOT inb WHEN sign = '0' ELSE inb;

	c(0) <= (NOT sign);

  -- Generates N Full_Adder s
    gen_adders: FOR i IN 0 TO N-1 GENERATE
    Full_Adder_i: ENTITY work.Full_Adder
        PORT MAP (
            A    => ina(i),
            B    => inb_Complement(i),
            Cin  => c(i),
            S    => sum(i),
            Cout => c(i+1)
        );
  END GENERATE;

  Cout <= c(N); -- Carry out
  
END ARCHITECTURE structural;