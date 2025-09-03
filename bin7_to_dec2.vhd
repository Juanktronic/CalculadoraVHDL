library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Archivo      : bin7_to_dec2.vhd
-- Descripción  : Este código recib ecomo entrada un número 
--					   binario de 7 bits, suficiente para repre-
--					   sentar el rango de 0 - 81 de la multipli-
--					   cación y de -9 hasta 18 de la suma.
--					   Lo convierte en 2 nibbles conteniendo los
--					   2 digitos decimales.
-- Autores      : Mojica, Guevara y Díaz
-- Fecha        : [01/09/25]
------------------------------------------------------------
-- Detalles:
--   - Propósito: Convertir un número binario de 7 bits en
--					   sus dos digitos decimales.
--   - Entradas : bin_in (Número binario de 7 bits)
--   - Salidas  : tens   (Número binario decenas)
--					   ones   (Número binario unidades)
------------------------------------------------------------

entity bin7_to_dec2 is
  port (
    bin_in : in  std_logic_vector(6 downto 0);
    tens   : out std_logic_vector(3 downto 0);
    ones   : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of bin7_to_dec2 is

 -- Constantes que representan valores para restar decenas en binario:

  constant C80 : std_logic_vector(6 downto 0) := "1010000";
  constant C60 : std_logic_vector(6 downto 0) := "0111100";
  constant C40 : std_logic_vector(6 downto 0) := "0101000";
  constant C20 : std_logic_vector(6 downto 0) := "0010100";

  -- Señales intermedias para almacenar valores después de cada resta 
  
    signal Val_0, Val_1, Val_2, Val_3, Val_4 : std_logic_vector(6 downto 0);
	  
  -- Señales para resultados de las restas
  
  signal Sub_80, Sub_60, Sub_40, Sub_20     : std_logic_vector(6 downto 0);
  
  -- Señales que indican si se pudo restar (salida de carry del sumador)
  
  signal C80_Valid, C60_Valid, C40_Valid, C20_Valid : std_logic;
  
  -- Bits restantes (menores a 20), después de restar todas las decenas posibles

  signal Remainder_Bits : std_logic_vector(4 downto 0);
  
  -- Indica si hay al menos 10 en el residuo (para sumar 6 en unidades)
  
  signal C10_Valid      : std_logic;

  signal Ones_Add6 : std_logic_vector(3 downto 0);
begin
 
  -- Valor de entrada (Binario 7 bits) 

 Val_0 <= bin_in;

  -- N_Adder para restar 80/60/40/20 para posteriormente restar 10 y saber si hay valores
  -- en las decenas y confirmar 70/50/30/10
  
  sub80_adder : entity work.N_Adder
    generic map ( N => 7 )
    port map (
      ina  => Val_0,
      inb  => C80,
      sign => '0',
      sum  => Sub_80,
      Cout => C80_Valid
    );

  Val_1 <= Sub_80 when C80_Valid = '1' else Val_0;

  sub60_adder : entity work.N_Adder
    generic map ( N => 7 )
    port map (
      ina  => Val_1,
      inb  => C60,
      sign => '0',
      sum  => Sub_60,
      Cout => C60_Valid
    );

  Val_2 <= Sub_60 when C60_Valid = '1' else Val_1;

  sub40_adder : entity work.N_Adder
    generic map ( N => 7 )
    port map (
      ina  => Val_2,
      inb  => C40,
      sign => '0',
      sum  => Sub_40,
      Cout => C40_Valid
    );

  Val_3 <= Sub_40 when C40_Valid = '1' else Val_2;

  sub20_adder : entity work.N_Adder
    generic map ( N => 7 )
    port map (
      ina  => Val_3,
      inb  => C20,
      sign => '0',
      sum  => Sub_20,
      Cout => C20_Valid
    );

 -- Después de restar todas las decenas, nos quedan los bits del resto (0 a 19)
 
  Val_4 <= Sub_20 when C20_Valid = '1' else Val_3;
  
  Remainder_Bits <= Val_4(4 downto 0);
  
 -- Detectar si el número es >= 10 
 
  C10_Valid <= Remainder_Bits(4) or (Remainder_Bits(3) and (Remainder_Bits(2) or Remainder_Bits(1)));

 -- Construcción del valor de las decenas (tens) en BCD
 -- Se asigna 8, 6, 4, 2 según qué restas fueron posibles
  
  tens(3) <= C80_Valid;
  tens(2) <= C60_Valid or C40_Valid;
  tens(1) <= C60_Valid or C20_Valid;
  tens(0) <= C10_Valid;  -- Con este se asigna para que sea 7 - 5 - 3 - 1
  
 -- Si el resto es ≥10, se suma 6 al valor (BCD correction)
 
    add6_adder : entity work.N_Adder
    generic map ( N => 4 )
    port map (	
      ina  => Remainder_Bits(3 downto 0),
      inb  => "0110",
      sign => '1',
      sum  => Ones_Add6,
      Cout => open
    );

 -- Si hay mas de 10, se usa el valor Ones_Add6 sino se deja el normal
	 
  ones <= Ones_Add6 when C10_Valid = '1' else Remainder_Bits(3 downto 0);
  
end architecture;
