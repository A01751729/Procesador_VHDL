--ANDRES MENDEZ CORTEZ A01751729
--Puertos de salida, sin dependencias
--
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity MEM_OUT is
	port(--direccion, dato y señales de control
		ADRESS: in std_logic_vector(3 downto 0);
			CLK,W,RST: in std_logic;
			DATA_IN: in std_logic_vector(7 downto 0);
			--todos los puertos declarados
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

end entity;

architecture RTL of MEM_OUT is
	--se inicializa la memoria
	type memory is array (15 downto 0) of std_logic_vector(7 downto 0);
	signal RAM: memory:=(x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00");
	
	begin
	process(RST,CLK)
		begin
		--se reinicia la memoria con el reset
		if (RST='1') then
			RAM(0) <=x"00";
			RAM(1) <=x"00";
			RAM(2) <=x"00";
			RAM(3) <=x"00";
			RAM(4) <=x"00";
			RAM(5) <=x"00";
			RAM(6) <=x"00";
			RAM(7) <=x"00";
			RAM(8) <=x"00";
			RAM(9) <=x"00";
			RAM(10)<=x"00";
			RAM(11)<=x"00";
			RAM(12)<=x"00";
			RAM(13)<=x"00";
			RAM(14)<=x"00";
			RAM(15)<=x"00";
		else
		--si no hay reset se graba los datos en la ubicación seleccionada
			if (CLK'event and CLK='1') then
				if(W='1') then
					RAM(conv_integer(unsigned(ADRESS)))<=DATA_IN;
				end if;	
			end if;
		
			
		end if;
	end process;
	--se asignan las direcciones de memoria a puertos "fisicos"
	PORT_OUT0<= RAM(0);
	PORT_OUT1<= RAM(1);
	PORT_OUT2<= RAM(2);
	PORT_OUT3<= RAM(3);
	PORT_OUT4<= RAM(4);
	PORT_OUT5<= RAM(5);
	PORT_OUT6<= RAM(6);
	PORT_OUT7<= RAM(7);
	PORT_OUT8<= RAM(8);
	PORT_OUT9<= RAM(9);
	PORT_OUT10<=RAM(10);
	PORT_OUT11<=RAM(11);
	PORT_OUT12<=RAM(12);
	PORT_OUT13<=RAM(13);
	PORT_OUT14<=RAM(14);
	PORT_OUT15<=RAM(15);
end architecture;