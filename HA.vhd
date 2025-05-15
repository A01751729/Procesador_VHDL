--Andrés Méndez Cortez
--A01751729
--Medio sumador
Library ieee;
use ieee.std_logic_1164.all;

--entidad del medio sumador
entity HA is
	port(A,B: in std_logic;--define AB como entradas logicas
	     S, Co:out std_logic);--define S y Co como salidas logicas
end entity;
--se conectan las entradas y salidas, xor para la suma y and para el carry
architecture RTL of HA is
	begin
		S  <= A xor B;
		Co <= A and B;
end architecture;