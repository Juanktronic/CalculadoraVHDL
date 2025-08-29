LIBRARY IEEE;
USE ieee.std_logic_1164.all;
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