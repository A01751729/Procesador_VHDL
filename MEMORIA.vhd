--ANDRES MENDEZ CORTEZ A01751729
--MEMORIA TOP LEVEL ENTITY
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity MEMORIA is 
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
end entity;

architecture RTL of MEMORIA is
	component MEM_PROG is
	port(ADRESS: in std_logic_vector(6 downto 0);
			CLK: in std_logic;
			DATA_OUT: out std_logic_vector(7 downto 0));

	end component;
	
	component MEM_DATA is
	port(ADRESS: in std_logic_vector(6 downto 0);
			CLK,WR: in std_logic;
			DATA_IN: in std_logic_vector(7 downto 0);
			DATA_OUT: out std_logic_vector(7 downto 0));

	end component;

	component MEM_OUT is
	port(ADRESS: in std_logic_vector(3 downto 0);
			CLK,W,RST: in std_logic;
			DATA_IN: in std_logic_vector(7 downto 0);
			PORT_OUT0: out std_logic_vector(7 downto 0);
			PORT_OUT1: out std_logic_vector(7 downto 0);
			PORT_OUT2: out std_logic_vector(7 downto 0);
			PORT_OUT3: out std_logic_vector(7 downto 0);
			PORT_OUT4: out std_logic_vector(7 downto 0);
			PORT_OUT5: out std_logic_vector(7 downto 0);
			PORT_OUT6: out std_logic_vector(7 downto 0);
			PORT_OUT7: out std_logic_vector(7 downto 0);
			PORT_OUT8: out std_logic_vector(7 downto 0);
			PORT_OUT9: out std_logic_vector(7 downto 0);
			PORT_OUT10: out std_logic_vector(7 downto 0);
			PORT_OUT11: out std_logic_vector(7 downto 0);
			PORT_OUT12: out std_logic_vector(7 downto 0);
			PORT_OUT13: out std_logic_vector(7 downto 0);
			PORT_OUT14: out std_logic_vector(7 downto 0);
			PORT_OUT15: out std_logic_vector(7 downto 0));

	end component;
	
	signal ROM_OUT,RAM_OUT: std_logic_vector(7 downto 0);
	signal PORT_OUT_ADDR: std_logic_vector (3 downto 0);
	signal ROM_ADDR,RAM_ADDR: std_logic_vector(6 downto 0);
	
	begin
	ROM_ADDR<=ADRESS(6 downto 0) when (ADRESS(7)='0') else "0000000";
	RAM_ADDR<=ADRESS(6 downto 0) when (ADRESS(7)='1') else "0000000";
	PORT_OUT_ADDR<=ADRESS(3 downto 0) when (ADRESS(7 downto 4)=x"E") else "0000";
	--FLASH
	MROM: MEM_PROG port map(ROM_ADDR,CLK,ROM_OUT);
	--RAM (EL MEJOR ALBUM DE LA HISTORIA)
	MDATA: MEM_DATA port map(RAM_ADDR,CLK,WR,DATA_IN,RAM_OUT);
	--PUERTOS
	PORTS: MEM_OUT port map(PORT_OUT_ADDR,CLK,WR,RST,DATA_IN, P_OUT0,P_OUT1,P_OUT2,P_OUT3,P_OUT4,P_OUT5,P_OUT6,P_OUT7, P_OUT8,P_OUT9,P_OUT10,P_OUT11,P_OUT12,P_OUT13,P_OUT14,P_OUT15);
	--redireccionamiento de memoria								
	DATA_OUT<=ROM_OUT when ADRESS< x"80" else
				 RAM_OUT when ADRESS< x"E0" else
				 P_IN0   when ADRESS= x"F0" else
				 P_IN1   when ADRESS= x"F1" else
				 P_IN2   when ADRESS= x"F2" else
				 P_IN3   when ADRESS= x"F3" else
				 P_IN4   when ADRESS= x"F4" else
				 P_IN5   when ADRESS= x"F5" else
				 P_IN6   when ADRESS= x"F6" else
				 P_IN7   when ADRESS= x"F7" else
				 P_IN8   when ADRESS= x"F8" else
				 P_IN9   when ADRESS= x"F9" else
				 P_IN10  when ADRESS= x"FA" else
				 P_IN11  when ADRESS= x"FB" else
				 P_IN12  when ADRESS= x"FC" else
				 P_IN13  when ADRESS= x"FD" else
				 P_IN14  when ADRESS= x"FE" else
				 P_IN15  when ADRESS= x"FF" else
				 x"00";
	
	
	
end architecture;
