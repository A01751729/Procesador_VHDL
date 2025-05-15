--ANDRES MENDEZ CORTEZ A01751729
--ALU bit slice
library ieee;
use ieee.std_logic_1164.all;

entity ALU_4B is
	port(A,B: in std_logic_vector(7 downto 0);
	CIN,NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,INCA,INCB,DECA,DECB: in std_logic;
	FLAG_O,FLAG_N,FLAG_Z: out std_logic;
	SUM: out std_logic_vector(7 downto 0);
	COUT: out std_logic);
	
end entity;

architecture RTL of ALU_4B is 
	component ALU_1B is
	  port(
		 A, B, CIN: in std_logic;
		 NA, NB, AANDB, NOTB, NOTA, AXORB, AORB, APLUSB: in std_logic;
		 S, COUT: out std_logic
	  );
	end component;
	
	signal S: std_logic_vector(7 downto 0);
	signal C: std_logic_vector(8 downto 1);
	signal ASIG,BSIG: std_logic_vector(7 downto 0);
	begin 
	--procesos que se añadieron despues
	process(INCA,INCB,DECA,DECB)
		begin
		if (INCA = '1') then
		 ASIG<= A;
		 BSIG<= "00000001";
	  elsif (DECA = '1') then
		 ASIG<= A;
		 BSIG<= "11111111";
	  elsif (INCB = '1') then
		 ASIG <="00000001";
		 BSIG <= B;
	  elsif (DECB = '1') then
		 ASIG <="11111111";
		 BSIG <= B;

	  else
		 ASIG <= A;
		 BSIG <= B;
	  end if;
		
	end process;
	
	--instancias
	I0: ALU_1B port map(ASIG(0),BSIG(0),CIN,NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,S(0),C(1));
	I1: ALU_1B port map(ASIG(1),BSIG(1),C(1),NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,S(1),C(2));
	I2: ALU_1B port map(ASIG(2),BSIG(2),C(2),NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,S(2),C(3));
	I3: ALU_1B port map(ASIG(3),BSIG(3),C(3),NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,S(3),C(4));
	I4: ALU_1B port map(ASIG(4),BSIG(4),C(4),NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,S(4),C(5));
	I5: ALU_1B port map(ASIG(5),BSIG(5),C(5),NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,S(5),C(6));
	I6: ALU_1B port map(ASIG(6),BSIG(6),C(6),NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,S(6),C(7));
	I7: ALU_1B port map(ASIG(7),BSIG(7),C(7),NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,S(7),C(8));
	--banderas
	FLAG_Z<='1' when S="00000000" else
				'0';
	
	FLAG_N<=S(7);
	FLAG_O<=C(8) xor S(7);
	
	COUT<=C(8);
	SUM<=S;
end architecture;