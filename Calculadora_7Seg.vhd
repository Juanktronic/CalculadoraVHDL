LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Calculadora_7Seg IS
    PORT (
        a           : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Operando A
        b           : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Operando B
        Add_Or_Mul   : IN  STD_LOGIC;                     -- 0 = suma, 1 = multiplicación
        seg7_units  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Display unidades
        seg7_tens   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- Display decenas
    );
END ENTITY Calculadora_7Seg;

ARCHITECTURE structural OF Calculadora_7Seg IS
    -- Señales internas
    SIGNAL sum_result  : STD_LOGIC_VECTOR(4 DOWNTO 0);   
    SIGNAL mult_result : STD_LOGIC_VECTOR(6 DOWNTO 0);   
    SIGNAL selected_result : STD_LOGIC_VECTOR(6 DOWNTO 0); 
    SIGNAL units_digit : STD_LOGIC_VECTOR(3 DOWNTO 0);   
    SIGNAL tens_digit  : STD_LOGIC_VECTOR(3 DOWNTO 0);   
    
    -- Señales optimizadas - solo las restas necesarias
    SIGNAL res_10, res_80 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL carry_10, carry_80 : STD_LOGIC;
    SIGNAL sum_carry : STD_LOGIC;
    
    -- Constantes
    SIGNAL const_10 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL const_80 : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN
    const_10 <= "0001010";  -- 10 en binario
    const_80 <= "1010000";  -- 80 en binario

    -- Instancia del sumador
    adder: ENTITY work.N_Adder1
        GENERIC MAP (N => 5)
        PORT MAP (
            ina  => '0' & a,
            inb  => '0' & b,
            sign => '1',
            sum  => sum_result,
            Cout => sum_carry
        );
    
    -- Instancia del multiplicador
    multiplier: ENTITY work.Mult4x7
        PORT MAP (
            a    => a,
            b    => b,
            prod => mult_result
        );
    
    -- Selección del resultado
    selected_result <= ("00" & sum_result) WHEN Add_Or_Mul = '0' ELSE mult_result;
    
    -- Solo dos restas: una para verificar >= 80 y otra para el módulo 10
    sub_80: ENTITY work.N_Adder1
        GENERIC MAP (N => 7)
        PORT MAP (
            ina  => selected_result,
            inb  => const_80,
            sign => '0',
            sum  => res_80,
            Cout => carry_80
        );
        
    sub_10: ENTITY work.N_Adder1
        GENERIC MAP (N => 7)
        PORT MAP (
            ina  => selected_result,
            inb  => const_10,
            sign => '0',
            sum  => res_10,
            Cout => carry_10
        );
    
    -- Lógica simplificada usando comparaciones directas con el resultado
    WITH selected_result SELECT
        tens_digit <= "1000" WHEN "1010000"|"1010001",
                      "0111" WHEN "1000110"|"1000111"|"1001000"|"1001001"|"1001010"|"1001011"|"1001100"|"1001101"|"1001110"|"1001111",
                      "0110" WHEN "0111100"|"0111101"|"0111110"|"0111111"|"1000000"|"1000001"|"1000010"|"1000011"|"1000100"|"1000101",
                      "0101" WHEN "0110010"|"0110011"|"0110100"|"0110101"|"0110110"|"0110111"|"0111000"|"0111001"|"0111010"|"0111011",
                      "0100" WHEN "0101000"|"0101001"|"0101010"|"0101011"|"0101100"|"0101101"|"0101110"|"0101111"|"0110000"|"0110001",
                      "0011" WHEN "0011110"|"0011111"|"0100000"|"0100001"|"0100010"|"0100011"|"0100100"|"0100101"|"0100110"|"0100111",
                      "0010" WHEN "0010100"|"0010101"|"0010110"|"0010111"|"0011000"|"0011001"|"0011010"|"0011011"|"0011100"|"0011101",
                      "0001" WHEN "0001010"|"0001011"|"0001100"|"0001101"|"0001110"|"0001111"|"0010000"|"0010001"|"0010010"|"0010011",
                      "0000" WHEN OTHERS; 
    
    -- Unidades: módulo 10 usando when-else
    units_digit <= selected_result(3 DOWNTO 0) WHEN carry_10 = '0' ELSE  -- Si < 10, usar directo
                   res_10(3 DOWNTO 0);                                     -- Si >= 10, usar residuo
    
    -- Decodificadores de 7 segmentos
    seg7_units <= "1000000" WHEN units_digit = "0000" ELSE  -- 0
                  "1111001" WHEN units_digit = "0001" ELSE  -- 1
                  "0100100" WHEN units_digit = "0010" ELSE  -- 2
                  "0110000" WHEN units_digit = "0011" ELSE  -- 3
                  "0011001" WHEN units_digit = "0100" ELSE  -- 4
                  "0010010" WHEN units_digit = "0101" ELSE  -- 5
                  "0000010" WHEN units_digit = "0110" ELSE  -- 6
                  "1111000" WHEN units_digit = "0111" ELSE  -- 7
                  "0000000" WHEN units_digit = "1000" ELSE  -- 8
                  "0010000" WHEN units_digit = "1001" ELSE  -- 9
                  "1111111";                                 -- Error
    
    WITH tens_digit SELECT
        seg7_tens <= "1000000" WHEN "0000",  -- 0
                     "1111001" WHEN "0001",  -- 1
                     "0100100" WHEN "0010",  -- 2
                     "0110000" WHEN "0011",  -- 3
                     "0011001" WHEN "0100",  -- 4
                     "0010010" WHEN "0101",  -- 5
                     "0000010" WHEN "0110",  -- 6
                     "1111000" WHEN "0111",  -- 7
                     "0000000" WHEN "1000",  -- 8
                     "1111111" WHEN OTHERS;  -- Error
							
END ARCHITECTURE structural;