LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY ssA IS
  PORT( bin  :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        sseg_A :  OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		  );
END ENTITY ssA;
----------------------------------------------------------------------------------
ARCHITECTURE behaviour OF ssA IS 
BEGIN
   WITH bin SELECT
	   sseg_A <=
		 "1000000" when "0000",  -- 0
       "1111001" when "0001",  -- 1
       "0100100" when "0010",  -- 2
       "0110000" when "0011",  -- 3
       "0011001" when "0100",  -- 4
       "0010010" when "0101",  -- 5
       "0000010" when "0110",  -- 6
       "1111000" when "0111",  -- 7
       "0000000" when "1000",  -- 8
       "0010000" when "1001",  -- 9
       "0000110" when others;  -- E

END behaviour;
----------------------------------------------------------------------------------
