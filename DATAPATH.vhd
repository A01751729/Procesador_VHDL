	--ANDRES MENDEZ CORTEZ A01751729
--DATAPATH DEL PROCESADOR
library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

--DATAPATH
entity DATAPATH is
				--entradas
	port(CLK,RST,IR_LOAD,MAR_LOAD,PC_LOAD,PC_INC,
				A_LOAD,B_LOAD,CCR_LOAD: in std_logic;
				BUS1_SEL,BUS2_SEL: in std_logic_vector(1 downto 0);
				ALU_SEL: in std_logic_vector(3 downto 0);
				FROM_MEM: in std_logic_vector(7 downto 0);
				--salidas
				CCR_RESULT: out std_logic_vector(3 downto 0);
				IR,TO_MEM,ADDRESS: out std_logic_vector(7 downto 0)
				);
end entity;

architecture RTL of DATAPATH is 
	component ALU_4B is
		port(A,B: in std_logic_vector(7 downto 0);
		CIN,NA,NB,AANDB,NOTB,NOTA,AXORB,AORB,APLUSB,INCA,INCB,DECA,DECB: in std_logic;
		FLAG_O,FLAG_N,FLAG_Z: out std_logic;
		SUM: out std_logic_vector(7 downto 0);
		COUT: out std_logic);
			
	end component;
	--señales
	signal BUS1, BUS2: std_logic_vector(7 downto 0);
	signal PC_SIG,A_SIG,B_SIG,ALU_SIG: std_logic_vector(7 downto 0);
	signal FLAG_REG: std_logic_vector(3 downto 0);
	signal CONTROL: std_logic_vector(10 downto 0);
	signal N: std_logic:='0';
	
	begin

	--INSTRUCTION REGISTER
	IR_P: process(CLK)
		begin
			if RST='1' then
				IR<="00000000";
			elsif ((CLK'event and CLK='1') and IR_LOAD='1') then
				IR<=BUS2;
			end if;
	end process;
	
	--MEMORY ADDRESS REGISTER
   MAR_P: process(CLK)
		begin
			if RST='1' then
				ADDRESS<="00000000";
			elsif ((CLK'event and CLK='1') and MAR_LOAD='1') then
				ADDRESS<=BUS2;
			end if;
	end process;
	
	
	--PROGRAM COUNTER
	--PROGRAM COUNTER
	PC_P: process(CLK)
	begin
		 if RST='1' then
			  PC_SIG<="00000000";
		 elsif (CLK'event and CLK='1') then
			  if (PC_LOAD='1') then
					PC_SIG <= BUS2;  -- Carga nueva dirección (JMP)
			  elsif (PC_INC='1') then
					PC_SIG <= std_logic_vector(unsigned(PC_SIG) + 1);  -- Incremento normal
			  end if;
		 end if;
	end process;
	
	
	--REGISTRO A
	A_P: process(CLK)
		begin
			if RST='1' then
				A_SIG<="00000000";
			elsif ((CLK'event and CLK='1') and A_LOAD='1') then
				A_SIG<=BUS2;
			end if;
	end process;
	
	
	--REGISTRO B
	B_P: process(CLK)
		begin
			if RST='1' then
				B_SIG<="00000000";
			elsif ((CLK'event and CLK='1') and B_LOAD='1') then
				B_SIG<=BUS2;
			end if;
	end process;
	
	
	--REGISTRO DE BANDERAS
	CCR_P: process(CLK)
		begin
			if RST='1' then
				CCR_RESULT<="0000";
			elsif ((CLK'event and CLK='1') and CCR_LOAD='1') then
				CCR_RESULT<=FLAG_REG;
			end if;
			
	end process;
	
	--control de la alu
	--10=NB,9=AANDB,8=NOTB,7=NOTA,6=AXORB,5=AORB,4=APLUSB,3=INCA,2=INCB,1=DECA,0=DECB
	with ALU_SEL select
    CONTROL <= "00000010000" when "0001",--suma A+B
               "10000010000" when "0010",--resta A-B
               "01000000000" when "0011",--and
               "00000100000" when "0100",--or
					"00001000000" when "0101",--xor
               "00000011000" when "0110",--incrementa A
               "00000010100" when "0111",--incrementa B
               "00000010010" when "1000",--decrementa A
					"00000010001" when "1001",--decrementa B
               "00010000000" when "1010",--not(A)
               "00100000000" when "1011",--not(B)
					"00000000000" when others;
      
	
	ALU: ALU_4B port map(BUS1,B_SIG,N,N,CONTROL(10),CONTROL(9),CONTROL(8),CONTROL(7),CONTROL(6),
								CONTROL(5),CONTROL(4),CONTROL(3),CONTROL(2),CONTROL(1),CONTROL(0),
								FLAG_REG(1),FLAG_REG(3),FLAG_REG(2),ALU_SIG,FLAG_REG(0));
	--MULTIPLEXOR DE BUS1
	BUS1 <= PC_SIG when BUS1_SEL="00" else
         A_SIG when BUS1_SEL="01" else
			B_SIG when BUS1_SEL="10" else
         "00000000";
	--MULTIPLEXOR DE BUS1		
	BUS2 <= ALU_SIG when BUS2_SEL="00" else
         BUS1 when BUS2_SEL="01" else
			FROM_MEM when BUS2_SEL="10" else
         ALU_SIG;
			
	TO_MEM<=BUS1;
end architecture;
