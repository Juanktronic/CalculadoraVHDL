LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Calc_tb IS
END ENTITY;

ARCHITECTURE sim OF Calc_tb IS

    -- Declaración del componente DUT
    COMPONENT Calc IS
        PORT( 
            A_bin       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            B_bin       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            Add_Or_Mul  : IN  STD_LOGIC;
            Sum_Or_Sub  : IN  STD_LOGIC;
            Result      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    -- Señales para conectar al DUT
    SIGNAL A_bin       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL B_bin       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Add_Or_Mul  : STD_LOGIC;
    SIGNAL Sum_Or_Sub  : STD_LOGIC;
    SIGNAL Result      : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    -- Instanciación del DUT
    UUT: Calc
        PORT MAP(
            A_bin      => A_bin,
            B_bin      => B_bin,
            Add_Or_Mul => Add_Or_Mul,
            Sum_Or_Sub => Sum_Or_Sub,
            Result     => Result
        );

    -- Proceso de estímulos
    stim_proc: PROCESS
    BEGIN
        -- ***** PRUEBAS DE SUMA *****
        Add_Or_Mul <= '1';  -- Suma/Resta
        Sum_Or_Sub <= '1';  -- Suma

        A_bin <= "0011"; B_bin <= "0010";  -- 3 + 2 = 5
        WAIT FOR 20 ns;

        A_bin <= "0100"; B_bin <= "0101";  -- 4 + 5 = 9
        WAIT FOR 20 ns;

        A_bin <= "0111"; B_bin <= "0001";  -- 7 + 1 = 8
        WAIT FOR 20 ns;

        A_bin <= "1001"; B_bin <= "0011";  -- 9 + 3 = 12
        WAIT FOR 20 ns;

        A_bin <= "1111"; B_bin <= "0001";  -- 15 + 1 = 16
        WAIT FOR 20 ns;

        -- ***** PRUEBAS DE RESTA *****
        Add_Or_Mul <= '1';  -- Suma/Resta
        Sum_Or_Sub <= '0';  -- Resta

        A_bin <= "0101"; B_bin <= "0011";  -- 5 - 3 = 2
        WAIT FOR 20 ns;

        A_bin <= "0110"; B_bin <= "0100";  -- 6 - 4 = 2
        WAIT FOR 20 ns;

        A_bin <= "1000"; B_bin <= "1001";  -- 8 - 7 = 1
        WAIT FOR 20 ns;

        A_bin <= "1111"; B_bin <= "1010";  -- 15 - 10 = 5
        WAIT FOR 20 ns;

        A_bin <= "0101"; B_bin <= "1001";  -- 9 - 12 = (negativo)
        WAIT FOR 20 ns;

        -- ***** PRUEBAS DE MULTIPLICACIÓN *****
        Add_Or_Mul <= '0';  -- Multiplicación (ignora Sum_Or_Sub)

        A_bin <= "0011"; B_bin <= "0010";  -- 3 * 2 = 6
        WAIT FOR 20 ns;

        A_bin <= "0100"; B_bin <= "0101";  -- 4 * 5 = 20
        WAIT FOR 20 ns;

        A_bin <= "0111"; B_bin <= "0011";  -- 7 * 3 = 21
        WAIT FOR 20 ns;

        A_bin <= "1001"; B_bin <= "0100";  -- 9 * 4 = 36
        WAIT FOR 20 ns;

        A_bin <= "1111"; B_bin <= "1111";  -- 15 * 15 = 225
        WAIT FOR 20 ns;

        -- Fin de simulación
        WAIT;
    END PROCESS;

END sim;
