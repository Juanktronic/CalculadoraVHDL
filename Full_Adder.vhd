LIBRARY IEEE;
USE ieee.std_logic_1164.all;

------------------------------------------------------------
-- Archivo      : Full_Adder.vhd
-- Descripción  : Código usado sumador de un bit.
-- Autores      : Mojica, Guevara y Díaz.
-- Fecha        : [01/09/25]
------------------------------------------------------------
-- Detalles:
--   - Propósito: Ser base del N_Adder.
--                y distribuirlas en los bloques.
--   - Entradas : A: std_LOGIC de la primera entrada.
--                B: std_LOGIC de la segunda entrada.
--                Cin: Accarreo de entrada que afecta el 
--                     resultado
--   - Salidas  : S: Resultado.
--                Cout: Acarreo de salida de la suma.
------------------------------------------------------------


ENTITY Full_Adder IS
    PORT(
			A    : IN  STD_LOGIC;
			B    : IN  STD_LOGIC;
			Cin  : IN  STD_LOGIC;
			Cout : OUT STD_LOGIC;
			S    : OUT STD_LOGIC
		   );
END ENTITY Full_Adder;
ARCHITECTURE gateLevel OF Full_Adder IS
BEGIN
	s <= A XOR B XOR Cin;
	Cout <= (A AND B) OR (A AND Cin) or (B AND Cin);
 
END ARCHITECTURE gateLevel;