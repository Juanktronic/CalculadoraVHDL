LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Calc IS
    PORT( 
        A_bin        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        B_bin        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        Add_Or_Mul   : IN  STD_LOGIC;
        Sum_Or_Sub   : IN  STD_LOGIC;
		  seg7_A       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  seg7_B       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  s7resul_A    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  s7resul_B    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
END ENTITY Calc;

ARCHITECTURE behaviour OF Calc IS

	 SIGNAL A_Sum_Sub      : STD_LOGIC_VECTOR(4 DOWNTO 0);
	 SIGNAL B_Sum_Sub      : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Add_Sub_Result : STD_LOGIC_VECTOR(4 DOWNTO 0);
	 SIGNAL Not_Add_Sub_Result : STD_LOGIC_VECTOR(4 DOWNTO 0);
	 SIGNAL Neg_Abs_Value  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Add_Sub_Ext    : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL Mul_Result     : STD_LOGIC_VECTOR(6 DOWNTO 0);
	 SIGNAL Abs_Add_Sub_Ext: STD_LOGIC_VECTOR(6 DOWNTO 0);
	 SIGNAL Result         : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL Cout_Sign      : STD_LOGIC;
	 SIGNAL Sign           : STD_LOGIC;

BEGIN

	A_Sum_Sub <= "0" & A_bin;
	B_Sum_Sub <= "0" & B_bin;

   Add_Sub: ENTITY work.N_Adder
        GENERIC MAP (
            N => 5
        )
        PORT MAP(
            ina  => A_Sum_Sub,
            inb  => B_Sum_Sub,
            sign => Sum_Or_Sub,
            sum  => Add_Sub_Result,
            Cout => OPEN
        );

    Mul: ENTITY work.Mult4x7
        PORT MAP(
            a    => A_Bin,
            b    => B_Bin,
            prod => Mul_Result
        );
		  
	Not_Add_Sub_Result <= NOT Add_Sub_Result;
	
   Abs_val: ENTITY work.N_Adder
        GENERIC MAP (
            N => 5
        )
        PORT MAP(
            ina  => Not_Add_Sub_Result,
            inb  => "00001",
            sign => '1',
            sum  => Neg_Abs_Value,
            Cout => OPEN
        );
	

	 Sign <= '1' WHEN (Add_Sub_Result(4) = '1' AND Sum_Or_Sub ='0') ELSE '0';	
--Add_Sub_Ext <= "00" & Add_Sub_Result WHEN Cout_Sign = '1' ELSE "11" & Add_Sub_Result;
    Add_Sub_Ext <= "11" & Add_Sub_Result WHEN (Add_Sub_Result(4) = '1' AND Sum_Or_Sub ='0') ELSE "00" & Add_Sub_Result;

    Result <= Add_Sub_Ext WHEN Add_Or_Mul = '1' ELSE Mul_Result;
	 
	 Abs_Add_Sub_Ext <= "00" & Neg_Abs_Value;
	 
    SS: ENTITY work.Calculadora_7Seg
        PORT MAP(
        a           => A_bin,
        b           => B_bin,
		  Sign        => Sign,
		  Resultd     => Result,
		  ResultAbs   => Abs_Add_Sub_Ext,
		  S7_A        => seg7_A,
		  S7_B        => seg7_B,
		  S7resul_A_Final   => s7resul_A,
		  S7resul_B   => s7resul_B
                 );

END behaviour;