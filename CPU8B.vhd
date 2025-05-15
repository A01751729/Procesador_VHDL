--ANDRES MENDEZ CORTEZ A01751729
--PROCESADOR DE 8 BITS
--INCLUYE CONTROL UNIT, DATAPATH, ALU Y MEMORIAS
library ieee;
use ieee.std_logic_1164.all;

entity CPU8B is 
	port(CLK, RST: in std_logic;
			IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,
			IN10,IN11,IN12,IN13,IN14,IN15: in std_logic_vector(7 downto 0);
			OUT0,OUT1,OUT2,OUT3,OUT4,OUT5,OUT6,OUT7,OUT8,OUT9,OUT10,
			OUT11,OUT12,OUT13,OUT14,OUT15: out std_logic_vector(7 downto 0));
end entity;

architecture RTL of CPU8B is
--necesita la unidad de control data path y el bloque de memoria
	 component CONTROL is 
		port (--entradas
				CLK, RST: in std_logic;
				IR: in std_logic_vector(7 downto 0);
				CCR_RESULT: in std_logic_vector(3 downto 0);
				--salidas
				IR_LOAD,MAR_LOAD,PC_LOAD,PC_INC,
				A_LOAD,B_LOAD,CCR_LOAD,WR: out std_logic;
				BUS1_SEL,BUS2_SEL: out std_logic_vector(1 downto 0);
				ALU_SEL: out std_logic_vector(3 downto 0)
		);
		end component;
	
		component DATAPATH is
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
		end component;
		
		component MEMORIA is 
				port(ADRESS: in std_logic_vector(7 downto 0);
						DATA_IN:in std_logic_vector(7 downto 0);
						WR,CLK,RST: in std_logic;
						DATA_OUT: out std_logic_vector(7 downto 0);
						
						P_IN0,P_IN1,P_IN2,P_IN3,P_IN4,
						P_IN5,P_IN6,P_IN7,P_IN8,P_IN9,
						P_IN10,P_IN11,P_IN12,P_IN13,P_IN14,
						P_IN15: in std_logic_vector(7 downto 0);
						
						P_OUT0,P_OUT1,P_OUT2,P_OUT3,P_OUT4,
						P_OUT5,P_OUT6,P_OUT7,P_OUT8,P_OUT9,
						P_OUT10,P_OUT11,P_OUT12,P_OUT13,P_OUT14,
						P_OUT15: out std_logic_vector(7 downto 0));
		end component;
		
		--hora de conectar nuestra manualidad art atack
		--necesitamos muchas señales
		signaL IR_L,MAR_L,PC_L,PC_I,A_L,B_L,CCR_L,WR: std_logic;
		signal IR,DIRECCION,FROM_MEM,TO_MEM: std_logic_vector(7 downto 0);
		signal CCR,ALUSEL: std_logic_vector(3 downto 0);
		signal BUS1S,BUS2S: std_logic_vector(1 downto 0);
		
		signal CLK_100HZ: std_logic;  -- Nueva señal de reloj dividido
      signal counter: integer range 0 to 49999 := 0;  -- Para dividir 10MHz a 100Hz
		
		BEGIN 
		process(CLK, RST)
		 begin
			  if RST = '1' then
					counter <= 0;
					CLK_100HZ <= '0';
			  elsif (CLK'event and CLK='1') then
					if counter = 49999 then  -- 50,000 ciclos (10MHz/50,000 = 200Hz, pero alternamos flancos)
						 counter <= 0;
						 CLK_100HZ <= not CLK_100HZ;
					else
						 counter <= counter + 1;
					end if;
			  end if;
		 end process;
		
		FSM: CONTROL port map(CLK_100HZ,RST,IR,CCR,IR_L,MAR_L,PC_L,PC_I,A_L,B_L,CCR_L,WR,BUS1s,BUS2S,ALUSEL);
		DTP: DATAPATH port map(CLK_100HZ,RST,IR_L,MAR_L,PC_L,PC_I,A_L,B_L,CCR_L,BUS1S,BUS2S,ALUSEL,FROM_MEM,CCR,IR,TO_MEM,DIRECCION);
		MEM: MEMORIA port map(DIRECCION,TO_MEM,WR,CLK_100HZ,RST,FROM_MEM,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,
									 OUT0,OUT1,OUT2,OUT3,OUT4,OUT5,OUT6,OUT7,OUT8,OUT9,OUT10,OUT11,OUT12,OUT13,OUT14,OUT15);
		

end architecture;
