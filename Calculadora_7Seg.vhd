LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Calculadora_7Seg IS
    PORT (
        a           : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Operando A
        b           : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Operando B
		  Cout_Signd  : IN  STD_LOGIC;                     -- Acarreo de salida indica el signo
		  Sumsub      : IN  STD_LOGIC;
		  Resultd     : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
		  S7_A        : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  S7_B        : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  S7resul_A   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  S7resul_B   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY Calculadora_7Seg;

ARCHITECTURE structural OF Calculadora_7Seg IS

    SIGNAL E_Invalid          : STD_LOGIC;
    SIGNAL units_digit        : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL tens_digit         : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 

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

    Result: ENTITY work.negative_or_decs_units
  PORT MAP( 
           Resul      => Resultd,
           Invalid    => E_Invalid,
           Carry_sub  => Cout_Signd,
			  Is_sum     => Sumsub,
			  Ss_resul_a => S7resul_A,
			  Ss_resul_b => S7resul_B
           );

END structural;