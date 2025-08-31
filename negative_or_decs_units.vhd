LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY negative_or_decs_units IS
  PORT( Resul       :  IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        Invalid     :  IN STD_LOGIC;
		  Carry_sub   :  IN STD_LOGIC;
		  Is_sum      :  IN STD_LOGIC;
		  Ss_resul_a  :  OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  Ss_resul_b  :  OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		  );
END ENTITY negative_or_decs_units;
----------------------------------------------------------------------------------
ARCHITECTURE behaviour OF negative_or_decs_units IS 

SIGNAL Tens_digit   : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL Resul_A      : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL Resul_B      : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL Resul_pos    : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL E_Invalid    : STD_LOGIC_VECTOR(6 DOWNTO 0):= "1001011";
SIGNAL Unit         : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

WITH Resul SELECT
    Tens_digit <= "1000000" WHEN "1111111"|"1111110"|"1111101"|"1111100"|"1111011"|"1111010"|"1111001"|"1111000"|"1110111",
                  "1010000" WHEN "1010001", -- 81
                  "1000110" WHEN "1001000", -- 72
                  "0111100" WHEN "0111111"|"1000000", -- 63,64
                  "0110010" WHEN "0110110"|"0111000", -- 54,56
                  "0101000" WHEN "0101000"|"0101010"|"0101101"|"0110000"|"0110001", -- 40,42,45,48,49
                  "0011110" WHEN "0011110"|"0100000"|"0100011"|"0100100", -- 30,32,35,36
                  "0010100" WHEN "0010100"|"0010101"|"0011000"|"0011001"|"0011011"|"0011100", -- 20,21,24,25,27,28
                  "0001010" WHEN "0001010"|"0001011"|"0001100"|"0001101"|"0001110"|"0001111"|"0010000"|"0010001"|"0010010", -- 10,11,12,13,14,15,16,17,18
                  "0000000" WHEN OTHERS;

Resul_A <= E_Invalid WHEN Invalid = '1' ELSE Tens_digit;

    WITH Resul_A SELECT
        Ss_resul_a <= "0111111" WHEN "1000000",  -- (-)
                      "1000000" WHEN "0000000",  -- 0
                      "1111001" WHEN "0001010",  -- 1
                      "0100100" WHEN "0010100",  -- 2
                      "0110000" WHEN "0011110",  -- 3
                      "0011001" WHEN "0101000",  -- 4
                      "0010010" WHEN "0110010",  -- 5
                      "0000010" WHEN "0111100",  -- 6
                      "1111000" WHEN "1000110",  -- 7
                      "0000000" WHEN "1010000",  -- 8
                      "0000110" WHEN "1001011",  -- E
                      "1000001" WHEN OTHERS;

--- Units

    sub_dec: ENTITY work.N_Adder
        GENERIC MAP (N => 7)
        PORT MAP (
            ina  => Resul,
            inb  => Tens_digit ,
            sign => '0',
            sum  => Unit
        );

--Resul_B <= Resul WHEN (Carry_sub = '0' AND Is_sum = '0') ELSE Unit;
Resul_B <= Resul WHEN ((Tens_digit = "0000000") OR (Tens_digit = "1000000")) ELSE Unit;

Resul_pos <= E_Invalid WHEN Invalid = '1' ELSE Resul_B;

    WITH Resul_pos SELECT
        Ss_resul_B <= "1000000" WHEN "0000000",  -- 0
                      "1111001" WHEN "0000001"|"1111111",  -- 1
                      "0100100" WHEN "0000010"|"1111110",  -- 2
                      "0110000" WHEN "0000011"|"1111101",  -- 3
                      "0011001" WHEN "0000100"|"1111100",  -- 4
                      "0010010" WHEN "0000101"|"1111011",  -- 5
                      "0000010" WHEN "0000110"|"1111010",  -- 6
                      "1111000" WHEN "0000111"|"1111001",  -- 7
                      "0000000" WHEN "0001000"|"1111000",  -- 8
                      "0010000" when "0001001"|"1110111",  -- 9 
                      "0000110" WHEN "1001011",  -- E
                      "1000001" WHEN OTHERS;


END behaviour;
