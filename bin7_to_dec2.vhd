library ieee;
use ieee.std_logic_1164.all;

-- Conversión combinacional por restas sucesivas usando N_Adder (sin clock).
entity bin7_to_dec2 is
  port (
    bin_in : in  std_logic_vector(6 downto 0); -- 0..81
    tens   : out std_logic_vector(3 downto 0); -- 0..8
    ones   : out std_logic_vector(3 downto 0)  -- 0..9
  );
end entity;

architecture rtl of bin7_to_dec2 is
  constant TEN7 : std_logic_vector(6 downto 0) := "0001010"; -- 10
  constant ZERO4: std_logic_vector(3 downto 0) := "0000";

  -- Arreglos para encadenar 9 valores (entrada + 8 posibles restas)
  type slv7_array is array (natural range <>) of std_logic_vector(6 downto 0);
  type slv4_array is array (natural range <>) of std_logic_vector(3 downto 0);

  signal val     : slv7_array(0 to 8);  -- val(0)=bin_in, val(8)=resultado final (0..9)
  signal tensacc : slv4_array(0 to 8);  -- acumulador de decenas (4 bits)

  -- Señales por etapa
  signal sub_out  : slv7_array(0 to 7);
  signal sub_cout : std_logic_vector(0 to 7);  -- '1' si la resta fue válida (>=10)
  signal add1_sel : slv4_array(0 to 7);        -- "0001" si resta válida, "0000" si no
  signal tens_sum : slv4_array(0 to 7);

begin
  -- Etapa 0: cargar entrada y decenas en 0
  val(0)     <= bin_in;
  tensacc(0) <= ZERO4;

  -- Generar 8 etapas: cada una intenta restar 10 y, si fue válida, suma 1 a decenas.
  gen_stages: for i in 0 to 7 generate

    -- Resta: val(i) - 10
    sub_i: entity work.N_Adder
      generic map ( N => 7 )
      port map (
        ina  => val(i),
        inb  => TEN7,
        sign => '0',             -- resta
        sum  => sub_out(i),
        Cout => sub_cout(i)      -- '1' = no hubo préstamo => val(i) >= 10
      );

    -- Selector "0001" si la resta fue válida; "0000" si no
    add1_sel(i) <= "0001" when sub_cout(i) = '1' else "0000";

    -- Acumular decenas: tensacc(i+1) = tensacc(i) + (sub_cout ? 1 : 0)
    add_tens_i: entity work.N_Adder
      generic map ( N => 4 )
      port map (
        ina  => tensacc(i),
        inb  => add1_sel(i),
        sign => '1',             -- suma
        sum  => tens_sum(i),
        Cout => open
      );

    -- Avance de valor: si la resta es válida, avanzar con (val - 10); si no, mantener
    val(i+1) <= sub_out(i) when sub_cout(i) = '1' else val(i);

    -- Avance de decenas
    tensacc(i+1) <= tens_sum(i);

  end generate;

  -- Salidas:
  -- - Decenas: acumulador final
  tens <= tensacc(8);

  -- - Unidades: los 4 LSB del valor final (tras 0..8 restas)
  ones <= val(8)(3 downto 0);

end architecture;