LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY N_Adder IS
  GENERIC (
    N : INTEGER := 5
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

  -- Hace complemento a 1 cuando se indica una resta "sign = 0"

	inb_Complement <= NOT inb WHEN sign = '0' ELSE inb;
	
  -- Se inicia el Carry de entrada en 1 cuando es una resta
	
	c(0) <= (NOT sign);

  -- Genera N Full_Adder s
  
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

  Cout <= c(N);
  
END ARCHITECTURE structural;