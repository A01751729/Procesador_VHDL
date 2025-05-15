--ANDRES MENDEZ CORTEZ A01751729
--ALU bit slice
library ieee;
use ieee.std_logic_1164.all;

entity ALU_1B is
  port(
    A, B, CIN: in std_logic;
    NA, NB, AANDB, NOTB, NOTA, AXORB, AORB, APLUSB: in std_logic;
    S, COUT: out std_logic
  );
end entity;


architecture RTL of ALU_1B is 
	component HA is
		port(A,B: in std_logic;
			  S, Co:out std_logic);
	end component;
	
	signal A_HA,B_HA,S_HA,S_HA2,CIN_HA,CO_HA,CO_HA2: std_logic;
	
	begin
	A_HA<=A xor NA;
	B_HA<=B xor NB;
	CIN_HA<= NA or NB or CIN;
	
	I0: HA port map(A_HA,B_HA,S_HA,CO_HA);
	I1: HA port map(S_HA,CIN_HA,S_HA2,CO_HA2);
	COUT<=CO_HA or CO_HA2;
	S<=( AANDB and CO_HA) or (not(B_HA) and NOTB) or (not(A_HA) and NOTA) or (S_HA and AXORB) or ((A_HA or B_HA)and AORB) or (S_HA2 and APLUSB);

end architecture;