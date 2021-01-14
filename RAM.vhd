LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY RAM IS
	PORT (
		Clk : IN std_logic;
		wr : IN std_logic;
		r : IN std_logic;
		addr : IN std_logic_vector(7 DOWNTO 0);
		wraddr : IN std_logic_vector(7 DOWNTO 0);
		data_in : IN std_logic_vector(7 DOWNTO 0);
		data_out : OUT std_logic_vector(7 DOWNTO 0));
END RAM;

ARCHITECTURE Behavioral OF RAM IS
	TYPE RAMTYPE IS ARRAY (255 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0); 
	SIGNAL ram : RAMTYPE := (OTHERS => (OTHERS => '0'));
BEGIN
	data_out <= ram(conv_integer(addr));
	PROCESS (Clk)
	BEGIN
		IF Clk = '1' AND Clk'EVENT THEN
			IF r='1' then
			    ram(conv_integer(wraddr)) <= (others=>'0');
			ELSIF wr = '1' THEN
				ram(conv_integer(wraddr)) <= data_in;
			END IF; 
		END IF;
	END PROCESS;
END Behavioral;