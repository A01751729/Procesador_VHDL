--ANDRES MENDEZ CORTEZ A01751729
--MEMORIA DE PROGRAMA
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity MEM_PROG is
	port(ADRESS: in std_logic_vector(6 downto 0);
			CLK: in std_logic;
			DATA_OUT: out std_logic_vector(7 downto 0));

end entity;

architecture RTL of MEM_PROG is
	--instrucciones
	--transferencia
	constant LOAD_INM_A: std_logic_vector(7 downto 0):=x"86";
	constant LOAD_INM_B: std_logic_vector(7 downto 0):=x"87";
	constant LOAD_DIR_A: std_logic_vector(7 downto 0):=x"88";
	constant LOAD_DIR_B: std_logic_vector(7 downto 0):=x"89";
	constant STORE_A: std_logic_vector(7 downto 0):=x"96";
	constant STORE_B: std_logic_vector(7 downto 0):=x"97";

	--operaciones
	constant ADD_AB: std_logic_vector(7 downto 0):=x"40";
	constant SUB_AB: std_logic_vector(7 downto 0):=x"41";
	constant AND_AB: std_logic_vector(7 downto 0):=x"42";
	constant OR_AB : std_logic_vector(7 downto 0):=x"43";
	constant XOR_AB: std_logic_vector(7 downto 0):=x"44";
	constant INC_A : std_logic_vector(7 downto 0):=x"45";
	constant INC_B : std_logic_vector(7 downto 0):=x"46";
	constant DEC_A : std_logic_vector(7 downto 0):=x"47";
	constant DEC_B : std_logic_vector(7 downto 0):=x"48";
	constant NOT_A : std_logic_vector(7 downto 0):=x"50";
	constant NOT_B : std_logic_vector(7 downto 0):=x"51";
	
	
	--saltos
	constant JMP  : std_logic_vector(7 downto 0):=x"20";
	constant JN   : std_logic_vector(7 downto 0):=x"21";
	constant JNN  : std_logic_vector(7 downto 0):=x"22";
	constant JZ   : std_logic_vector(7 downto 0):=x"23";
	constant JNZ  : std_logic_vector(7 downto 0):=x"24";
	constant JOV  : std_logic_vector(7 downto 0):=x"25";
	constant JNOV : std_logic_vector(7 downto 0):=x"26";
	constant JC   : std_logic_vector(7 downto 0):=x"27";
	constant JNC  : std_logic_vector(7 downto 0):=x"28";
	
	type memory is array (127 downto 0) of std_logic_vector(7 downto 0);
	--Rutina del programa ya escrita
	signal ROM: memory:=(0		=>LOAD_DIR_A,
								1		=>x"FF",
								2		=>LOAD_INM_B,
								3		=>x"04",
								4		=>ADD_AB,
								5		=>STORE_A,
								6		=>x"E0",
								7		=>JNZ,
								8		=>x"00",
		
								others=>x"00"
								
	);
	
	begin
	process(CLK)
		begin
		--cambia a cada ciclo de reloj
		if (CLK'event and CLK='1') then
			DATA_OUT<=ROM(conv_integer(unsigned(ADRESS)));
		end if;
	end process;
end architecture;