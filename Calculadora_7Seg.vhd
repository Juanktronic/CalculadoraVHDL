library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Archivo      : Calculadora_7Seg.vhd
-- Descripción  : Módulo estructural que conecta las partes
--                de decodificación para mostrar en el 7 seg
--                y el bloque para convertir el binario de 7
--                bits en 2 nibbles.
-- Fecha        : [01/09/25]
------------------------------------------------------------
-- Detalles:
--   - Propósito: Visualizar A, B y el resultado en displays 7-seg.
--                Seleccionar el valor final (signado/absoluto) y
--                convertirlo a decenas/unidades BCD para salida.
--   - Entradas :
--       a[3:0]        (Operando A, 0–15)
--       b[3:0]        (Operando B, 0–15)
--       Sign          (1: resultado negativo; 0: no negativo)
--       Add_or_Mul    (0: multiplicación; 1: suma)
--       Resultd[6:0]  (Resultado directo: para suma o no firmado)
--       ResultAbs[6:0](Resultado absoluto: para valor |res|)
--   - Salidas  :
--       S7_A[6:0]           (7-seg de A)
--       S7_B[6:0]           (7-seg de B)
--       S7resul_A_Final[6:0](7-seg decenas del resultado, con signo)
--       S7resul_B[6:0]      (7-seg unidades del resultado)
------------------------------------------------------------

entity Calculadora_7Seg is
  port (
    a               : in  std_logic_vector(3 downto 0);  -- Operando A
    b               : in  std_logic_vector(3 downto 0);  -- Operando B
    Sign            : in  std_logic;                     -- Indicador de signo del resultado
    Add_or_Mul      : in  std_logic;                     -- 1: Mul, 0: Add
    Resultd         : in  std_logic_vector(6 downto 0);  -- Resultado directo (7 bits)
    ResultAbs       : in  std_logic_vector(6 downto 0);  -- Resultado en valor absoluto (7 bits)
    S7_A            : out std_logic_vector(6 downto 0);  -- Display A
    S7_B            : out std_logic_vector(6 downto 0);  -- Display B
    S7resul_A_Final : out std_logic_vector(6 downto 0);  -- Decenas del resultado (con posible signo)
    S7resul_B       : out std_logic_vector(6 downto 0)   -- Unidades del resultado
  );
end entity Calculadora_7Seg;

architecture structural of Calculadora_7Seg is

  signal E_Invalid          : std_logic;
  signal units_digit        : std_logic_vector(3 downto 0);
  signal tens_digit         : std_logic_vector(3 downto 0);
  signal units_digit_final  : std_logic_vector(3 downto 0);
  signal tens_digit_final   : std_logic_vector(3 downto 0);
  signal Final_Result       : std_logic_vector(6 downto 0);
  signal S7resul_A          : std_logic_vector(6 downto 0);

begin

  --   E_Invalid = 1 si A o B no están en BCD (≥10)
  E_Invalid <= (a(3) and (a(2) or a(1))) or (b(3) and (b(2) or b(1)));

  -- Visualización directa de operandos A y B en 7 segmentos

  Inp_A : entity work.ssA
    port map (
      bin     => a,
      sseg_A  => S7_A
    );

  Inp_B : entity work.ssA
    port map (
      bin     => b,
      sseg_A  => S7_B
    );

  --   - Si Sign = 0 o Add_or_Mul = 0 ⇒ usar Resultd
  --   - En caso contrario ⇒ usar ResultAbs
	  
  Final_Result <= Resultd when (Sign = '0' or Add_or_Mul = '0')
                  else ResultAbs;

  --   Se debe mostrar el signo si se cumplen las siguientes condiciones
  --   que el switch este en modo de Suma o Resta, sea una entrada válida
  --   y el signo sea negativo.
  --   - En otro caso, se muestra la decena calculada.
  --   "0111111" corresponde al segmento para '-'

  S7resul_A_Final <= "0111111" when (Sign = '1' and E_Invalid = '0' and Add_or_Mul = '1') 
	  			else S7resul_A;

  -- Conversión de binario (7 bits) a dos dígitos decimales (BCD)

  Result : entity work.bin7_to_dec2
    port map (
      bin_in => Final_Result,
      tens   => tens_digit,
      ones   => units_digit
    );

  --   "1111" (BCD inválido) para que el decodificador 7-seg
  --   muestre un patrón de error/apagado (según 'ssA').
	  
  tens_digit_final  <= "1111" when E_Invalid = '1' else tens_digit;
  units_digit_final <= "1111" when E_Invalid = '1' else units_digit;

  -- Salida de decenas y unidades del resultado en 7 segmentos

  Out_A : entity work.ssA
    port map (
      bin     => tens_digit_final,
      sseg_A  => S7resul_A
    );

  Out_B : entity work.ssA
    port map (
      bin     => units_digit_final,
      sseg_A  => S7resul_B
    );

end architecture structural;
