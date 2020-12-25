LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY RAM IS
	PORT (
		Clk : IN std_logic;
		En : IN std_logic;
		wr : IN std_logic;
		addr : IN std_logic_vector(15 DOWNTO 0);
		wraddr : IN std_logic_vector(15 DOWNTO 0);
		data_in : IN std_logic_vector(7 DOWNTO 0);
		data_out : OUT std_logic_vector(7 DOWNTO 0));
END RAM;

ARCHITECTURE Behavioral OF RAM IS
	TYPE RAMTYPE IS ARRAY (255 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0); --Limita superioara a Arrayului ar trebui sa fie 65,536 in cazul stackului
	                                                                       --si 16,777,216 in aczul memoriei. Dar am lasat 255 deoarece nu avem nevoie de atatea spatii 
	SIGNAL ram : RAMTYPE := (OTHERS => (OTHERS => '0'));
BEGIN
	data_out <= ram(conv_integer(addr));
	PROCESS (Clk)
	BEGIN
		IF Clk = '1' AND Clk'EVENT THEN
			IF wr = '1' THEN
				ram(conv_integer(wraddr)) <= data_in;
			END IF; 
		END IF;
	END PROCESS;
END Behavioral;