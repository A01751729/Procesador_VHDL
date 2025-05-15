# Procesador_VHDL
implementacion de un procesador de 8 bits en el lenguaje VHDL utilizando la herramienta de quartus prime lite 18.1

CPU8B es la top level entity, esta depende de DATAPATH, MEMORIA y CONTROL
DATAPATH depende de ALU4B que depende de ALU1B que depende de HA
MEMORIA depende de MEM_PROG, MEM_DATA y MEM_OUT que sirven para dividir logicamente la memoria
