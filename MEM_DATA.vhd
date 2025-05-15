--ANDRES MENDEZ CORTEZ A01751729
--MEMORIA DE DATOS
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity MEM_DATA is
	port(ADRESS: in std_logic_vector(6 downto 0);
			CLK,WR: in std_logic;
			DATA_IN: in std_logic_vector(7 downto 0);
			DATA_OUT: out std_logic_vector(7 downto 0));

end entity;

architecture RTL of MEM_DATA is
	--inicializacion de la memoria
	type memory is array (95 downto 0) of std_logic_vector(7 downto 0);
	signal RAM: memory:=(x"44",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00",
								x"00",x"00",x"00",x"00");
	
	begin
	process(CLK)
		begin
		--se escribe o se lee en cada flanco positivo de reloj
		if (CLK'event and CLK='1') then
			if(WR='1') then
				RAM(conv_integer(unsigned(ADRESS)))<=DATA_IN;
			else
				DATA_OUT<=RAM(conv_integer(unsigned(ADRESS)));
			end if;
			
		end if;
	end process;
end architecture;