LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Calculadora_7Seg IS
    PORT (
        a           : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Operando A
        b           : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Operando B
		  Sign        : IN  STD_LOGIC;
		  Add_or_Mul  : IN  STD_LOGIC;
		  Resultd     : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
		  ResultAbs   : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
		  S7_A        : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  S7_B        : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  S7resul_A_Final   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  S7resul_B   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY Calculadora_7Seg;

ARCHITECTURE structural OF Calculadora_7Seg IS

    SIGNAL E_Invalid          : STD_LOGIC;
    SIGNAL units_digit        : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL tens_digit         : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 SIGNAL units_digit_final  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL tens_digit_final   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 SIGNAL Final_Result       : STD_LOGIC_VECTOR(6 DOWNTO 0);
	 SIGNAL S7resul_A          : STD_LOGIC_VECTOR(6 DOWNTO 0);
	 

BEGIN

  E_Invalid <= (a(3) AND (a(2) OR a(1))) OR (b(3) AND (b(2) OR b(1)));
  
  

    Inp_A: ENTITY work.ssA
  PORT MAP( 
            bin => a,
				sseg_A => S7_A
				);

    Inp_B: ENTITY work.ssB
  PORT MAP( 
            bin => b,
				sseg_B => S7_B
				);

	Final_Result <= Resultd WHEN (Sign = '0' OR Add_or_Mul = '0') ELSE ResultAbs;
   S7Resul_A_Final <= "0111111" WHEN (Sign = '1' AND E_invalid = '0' AND Add_or_Mul = '1') ELSE S7resul_A;

    Result: ENTITY work.bin7_to_dec2
  PORT MAP( 
           bin_in   => Final_Result,
			  tens => tens_digit,
			  ones => units_digit
           );
	
	tens_digit_final <= "1111" WHEN E_invalid = '1' ELSE tens_digit;
	
	
	units_digit_final <= "1111" WHEN E_invalid = '1' ELSE units_digit;
	
	Out_A: ENTITY work.ssA
  PORT MAP( 
            bin => tens_digit_final,
				sseg_A => S7resul_A
				);

    Out_B: ENTITY work.ssB
  PORT MAP( 
            bin => units_digit_final,
				sseg_B => S7resul_B
				);

END structural;