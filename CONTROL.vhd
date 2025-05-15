--ANDRES MENDEZ CORTEZ A01751729
--UNIDAD DE CONTROL
library IEEE;
use IEEE.std_logic_1164.all;

entity CONTROL is 
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
	
end entity;

architecture RTL of CONTROL is

    type ESTADOS is (
        IDLE, Fetch0, Fetch1, Fetch2, DS,   --ciclo fetch
        Op86A, Op86B, Op86C,                -- LOAD_INM_A
        Op87A, Op87B, Op87C,                -- LOAD_INM_B
        Op88A, Op88B, Op88C, Op88D, Op88E,  -- LOAD_DIR_A
        Op89A, Op89B, Op89C, Op89D, Op89E,  -- LOAD_DIR_B
        Op96A, Op96B, Op96C, Op96D,         -- STORE_A
        Op97A, Op97B, Op97C, Op97D,         -- STORE_B
        Op40, Op41, Op42, Op43, Op44,       -- Aritmética lógica
        Op45, Op46, Op47, Op48,             -- INC/DEC
        Op50, Op51,                         -- NOT
        Op20, Op20A, Op20B,                 -- JMP
        Op21, Op21A, Op21B, Op21C,          -- JN
        Op22, Op22A, Op22B, Op22C,          -- JNN
        Op23, Op23A, Op23B, Op23C,          -- JZ
        Op24, Op24A, Op24B, Op24C,          -- JNZ
        Op25, Op25A, Op25B, Op25C,          -- JOV
        Op26, Op26A, Op26B, Op26C,          -- JNOV
        Op27, Op27A, Op27B, Op27C,          -- JC
        Op28, Op28A, Op28B, Op28C           -- JNC
    );

    signal EDO, EDOF : ESTADOS;
    signal N, Z, O, C: std_logic;
    signal start : std_logic := '1'; -- Se añadió para evitar error de referencia

begin

    N <= CCR_RESULT(3); -- Bandera Negativo
    Z <= CCR_RESULT(2); -- Bandera Cero
    O <= CCR_RESULT(1); -- Bandera Overflow
    C <= CCR_RESULT(0); -- Bandera Carry

    P1: process (CLK,RST)
    begin
        if (RST = '1') then
            EDO <= IDLE;
        elsif (CLK'event and CLK='1') then
            EDO <= EDOF;
        end if;
    end process;

    P2: process(EDO, IR, N,Z,O,C)
    begin
        case EDO is
            when IDLE =>
                EDOF <= Fetch0;

            when Fetch0 =>
                EDOF <= Fetch1;

            when Fetch1 =>
                EDOF <= Fetch2;

            when Fetch2 =>
                EDOF <= DS;

            when DS =>
                case IR is
						--asignacion
                    when x"86" => EDOF <= Op86A;
                    when x"87" => EDOF <= Op87A;
                    when x"88" => EDOF <= Op88A;
                    when x"89" => EDOF <= Op89A;
                    when x"96" => EDOF <= Op96A;
                    when x"97" => EDOF <= Op97A;
						  --ALU
                    when x"40" => EDOF <= Op40;
                    when x"41" => EDOF <= Op41;
                    when x"42" => EDOF <= Op42;
                    when x"43" => EDOF <= Op43;
                    when x"44" => EDOF <= Op44;
                    when x"45" => EDOF <= Op45;
                    when x"46" => EDOF <= Op46;
                    when x"47" => EDOF <= Op47;
                    when x"48" => EDOF <= Op48;
                    when x"50" => EDOF <= Op50;
                    when x"51" => EDOF <= Op51;
						  --jumps
                    when x"21" => if N = '0' then EDOF <= Op21; else EDOF <= Op21A; end if;
                    when x"22" => if N = '1' then EDOF <= Op22; else EDOF <= Op22A; end if;
                    when x"23" => if Z = '0' then EDOF <= Op23; else EDOF <= Op23A; end if;
                    when x"24" => if Z = '1' then EDOF <= Op24; else EDOF <= Op24A; end if;
                    when x"25" => if O = '0' then EDOF <= Op25; else EDOF <= Op25A; end if;
                    when x"26" => if O = '1' then EDOF <= Op26; else EDOF <= Op26A; end if;
                    when x"27" => if C = '0' then EDOF <= Op27; else EDOF <= Op27A; end if;
                    when x"28" => if C = '1' then EDOF <= Op28; else EDOF <= Op28A; end if;
                    when others => EDOF <= IDLE;
                end case;
					 
					 
					 
					 
				--LOAD INMEDIATO A	 

            when Op86A => EDOF <= Op86B;
            when Op86B => EDOF <= Op86C;
            when Op86C => EDOF <= IDLE;

				--LOAD INMEDIATO B
				
            when Op87A => EDOF <= Op87B;
            when Op87B => EDOF <= Op87C;
            when Op87C => EDOF <= IDLE;

					
				 -- LOAD DIR A
            when Op88A => EDOF <= Op88B;
            when Op88B => EDOF <= Op88C;
            when Op88C => EDOF <= Op88D;
            when Op88D => EDOF <= Op88E;
            when Op88E => EDOF <= IDLE;

            -- LOAD DIR B
            when Op89A => EDOF <= Op89B;
            when Op89B => EDOF <= Op89C;
            when Op89C => EDOF <= Op89D;
            when Op89D => EDOF <= Op89E;
            when Op89E => EDOF <= IDLE;

            -- STORE A
            when Op96A => EDOF <= Op96B;
            when Op96B => EDOF <= Op96C;
            when Op96C => EDOF <= Op96D;
            when Op96D => EDOF <= IDLE;

            -- STORE B
            when Op97A => EDOF <= Op97B;
            when Op97B => EDOF <= Op97C;
            when Op97C => EDOF <= Op97D;
            when Op97D => EDOF <= IDLE;
				
				
				--operaciones de la alu
				when Op40=> EDOF <= IDLE;
				when Op41=> EDOF <= IDLE;
				when Op42=> EDOF <= IDLE;
				when Op43=> EDOF <= IDLE; 
				when Op44=> EDOF <= IDLE; -- Aritmética lógica
				when Op45=> EDOF <= IDLE;
				when Op46=> EDOF <= IDLE;
				when Op47=> EDOF <= IDLE;
				when Op48=> EDOF <= IDLE; -- INC/DEC
				when Op50=> EDOF <= IDLE;
				when Op51=> EDOF <= IDLE; --NOT

            -- JMP Incondicional
            when Op20 => EDOF <= Op20A;
            when Op20A => EDOF <= Op20B;
            when Op20B => EDOF <= IDLE;

            -- JN
            when Op21 => EDOF <= IDLE;
            when Op21A => EDOF <= Op21B;
            when Op21B => EDOF <= Op21C;
            when Op21C => EDOF <= IDLE;

            -- JNN
            when Op22 => EDOF <= IDLE;
            when Op22A => EDOF <= Op22B;
            when Op22B => EDOF <= Op22C;
            when Op22C => EDOF <= IDLE;

            -- JZ
            when Op23 => EDOF <= IDLE;
            when Op23A => EDOF <= Op23B;
            when Op23B => EDOF <= Op23C;
            when Op23C => EDOF <= IDLE;

            -- JNZ
            when Op24 => EDOF <= IDLE;
            when Op24A => EDOF <= Op24B;
            when Op24B => EDOF <= Op24C;
            when Op24C => EDOF <= IDLE;

            -- JOV
            when Op25 => EDOF <= IDLE;
            when Op25A => EDOF <= Op25B;
            when Op25B => EDOF <= Op25C;
            when Op25C => EDOF <= IDLE;

            -- JNOV
            when Op26 => EDOF <= IDLE;
            when Op26A => EDOF <= Op26B;
            when Op26B => EDOF <= Op26C;
            when Op26C => EDOF <= IDLE;

            -- JC
            when Op27 => EDOF <= IDLE;
            when Op27A => EDOF <= Op27B;
            when Op27B => EDOF <= Op27C;
            when Op27C => EDOF <= IDLE;

            -- JNC
            when Op28 => EDOF <= IDLE;
            when Op28A => EDOF <= Op28B;
            when Op28B => EDOF <= Op28C;
            when Op28C => EDOF <= IDLE;

            

            when others => NULL;
        end case;
    end process;
	 
	 P3:process(EDO, IR, N,Z,O,C)
		begin
			case EDO is 
            -- Estados principales
            when IDLE =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Fetch0 =>
                IR_Load <= '0';
                MAR_Load <= '1';  -- Cargar MAR con el valor del PC
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Fetch1 =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';     -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Fetch2 =>
                IR_Load <= '1';    -- Cargar IR con dato de memoria
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2
                wr <= '0';
                
            when DS =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            -- LOAD_INM_A (Op86)
            when Op86A =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC (para leer el operando)
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01"; -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op86B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';     -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op86C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';     -- Cargar A con el dato inmediato
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10"; -- Seleccionar memoria en Bus2
                wr <= '0';
                
            -- LOAD_INM_B (Op87)
            when Op87A =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01"; -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op87B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';    -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op87C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';    -- Cargar B con el dato inmediato
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2
                wr <= '0';
                
            -- LOAD_DIR_A (Op88)
            when Op88A =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC para leer la dirección
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op88B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';     -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op88C =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con la dirección de memoria
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2 (dirección)
                wr <= '0';
                
            when Op88D =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op88E =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';     -- Cargar A con dato de memoria
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2 (dato)
                wr <= '0';
                
            -- LOAD_DIR_B (Op89) - Similar a LOAD_DIR_A pero carga B
            when Op89A =>
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op89B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op89C =>
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            when Op89D =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op89E =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';     -- Cargar B con dato de memoria
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- STORE_A (Op96)
            when Op96A =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC para leer dirección
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";   -- Seleccionar PC en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op96B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';      -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op96C =>
                IR_Load <= '0';
                MAR_Load <= '1';    -- Cargar MAR con dirección de memoria
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2
                wr <= '0';
                
            when Op96D =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "01";  -- Seleccionar A en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '1';         -- Escribir en memoria
                
            -- STORE_B (Op97) - Similar a STORE_A pero con B
            when Op97A =>
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op97B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op97C =>
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            when Op97D =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "10";  -- Seleccionar B en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '1';         -- Escribir en memoria
                
            -- Operaciones ALU
            when Op40 =>  -- ADD_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';     -- Cargar resultado en A
                B_Load <= '0';
                ALU_Sel <= "0001"; -- Seleccionar operación de suma
                CCR_Load <= '1';   -- Actualizar banderas
                Bus1_Sel <= "01";  -- Seleccionar A en Bus1
                Bus2_Sel <= "11";  -- Seleccionar ALU en Bus2
                wr <= '0';
                
            when Op41 =>  -- SUB_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0010"; -- Seleccionar operación de resta
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op42 =>  -- AND_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0011"; -- AND
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op43 =>  -- OR_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0100"; -- OR
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op44 =>  -- XOR_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0101"; -- XOR
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op45 =>  -- INC_A
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0110"; -- Incremento A
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op46 =>  -- INC_B
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';
                ALU_Sel <= "0111"; -- Incremento B
                CCR_Load <= '1';
                Bus1_Sel <= "10";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op47 =>  -- DEC_A
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "1000"; -- Decremento A
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op48 =>  -- DEC_B
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';
                ALU_Sel <= "1001"; -- Decremento B
                CCR_Load <= '1';
                Bus1_Sel <= "10";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op50 =>  -- NOT_A
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "1010"; -- NOT A
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op51 =>  -- NOT_B
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';
                ALU_Sel <= "1011"; -- NOT B
                CCR_Load <= '1';
                Bus1_Sel <= "10";
                Bus2_Sel <= "11";
                wr <= '0';
                
            -- Saltos incondicionales
            when Op20 =>  -- JMP
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC para leer dirección de salto
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op20A =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            when Op20B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';     -- Cargar PC con dirección de salto
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";   -- Seleccionar memoria en Bus2
                wr <= '0';
                
            -- Saltos condicionales (todos siguen el mismo patrón)
            -- JN (Op21)
            when Op21 =>  -- No se toma el salto (N=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';      -- Solo incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op21A =>  -- Se toma el salto (N=1)
                IR_Load <= '0';
                MAR_Load <= '1';    -- Cargar MAR con PC para leer dirección
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op21B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op21C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';     -- Cargar PC con dirección de salto
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JNN (Op22) - Similar a JN pero condiciones invertidas
            when Op22 =>  -- No se toma el salto (N=1)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op22A =>  -- Se toma el salto (N=0)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op22B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op22C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JZ (Op23)
            when Op23 =>  -- No se toma el salto (Z=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op23A =>  -- Se toma el salto (Z=1)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op23B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op23C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JNZ (Op24) - Similar a JZ pero condiciones invertidas
            when Op24 =>  -- No se toma el salto (Z=1)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op24A =>  -- Se toma el salto (Z=0)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op24B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op24C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JOV (Op25)
            when Op25 =>  -- No se toma el salto (O=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op25A =>  -- Se toma el salto (O=1)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op25B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op25C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JNOV (Op26) - Similar a JOV pero condiciones invertidas
            when Op26 =>  -- No se toma el salto (O=1)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op26A =>  -- Se toma el salto (O=0)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op26B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op26C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JC (Op27)
            when Op27 =>  -- No se toma el salto (C=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op27A =>  -- Se toma el salto (C=1)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op27B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op27C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JNC (Op28) - Similar a JC pero condiciones invertidas
            when Op28 =>  -- No se toma el salto (C=1)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op28A =>  -- Se toma el salto (C=0)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
					 Bus2_Sel <= "01";
					 wr <= '0';
				
				when Op28B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op28C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
					 
				when others =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
        end case;
    end process;

end architecture;