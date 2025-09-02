library ieee;
use ieee.std_logic_1164.all;

entity bin7_to_dec2 is
  port (
    bin_in : in  std_logic_vector(6 downto 0);
    tens   : out std_logic_vector(3 downto 0);
    ones   : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of bin7_to_dec2 is
  constant C80 : std_logic_vector(6 downto 0) := "1010000";
  constant C60 : std_logic_vector(6 downto 0) := "0111100";
  constant C40 : std_logic_vector(6 downto 0) := "0101000";
  constant C20 : std_logic_vector(6 downto 0) := "0010100";

  signal Val_0, Val_1, Val_2, Val_3, Val_4 : std_logic_vector(6 downto 0);
  signal Sub_80, Sub_60, Sub_40, Sub_20     : std_logic_vector(6 downto 0);
  signal C80_Valid, C60_Valid, C40_Valid, C20_Valid : std_logic;

  signal Remainder_Bits : std_logic_vector(4 downto 0);
  signal C10_Valid      : std_logic;

  signal Ones_Add6 : std_logic_vector(3 downto 0);
begin
  Val_0 <= bin_in;

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

  Val_4 <= Sub_20 when C20_Valid = '1' else Val_3;

  Remainder_Bits <= Val_4(4 downto 0);
  C10_Valid <= Remainder_Bits(4) or (Remainder_Bits(3) and (Remainder_Bits(2) or Remainder_Bits(1)));

  tens(3) <= C80_Valid;
  tens(2) <= C60_Valid or C40_Valid;
  tens(1) <= C60_Valid or C20_Valid;
  tens(0) <= C10_Valid;

  add6_adder : entity work.N_Adder
    generic map ( N => 4 )
    port map (
      ina  => Remainder_Bits(3 downto 0),
      inb  => "0110",
      sign => '1',
      sum  => Ones_Add6,
      Cout => open
    );

  ones <= Ones_Add6 when C10_Valid = '1' else Remainder_Bits(3 downto 0);
end architecture;
