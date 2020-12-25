LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Accumulator IS
	PORT (
		Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		Input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END Accumulator;

ARCHITECTURE Behavioral OF Accumulator IS
	SIGNAL temp : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
BEGIN
	Output <= temp;
	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF Rst = '1' THEN
				temp <= (OTHERS => '0');
			ELSIF Enable = '1' THEN
				temp <= Input; 
			END IF;
		END IF;
	END PROCESS;

END Behavioral;