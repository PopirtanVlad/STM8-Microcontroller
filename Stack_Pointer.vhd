LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY Stack_Pointer IS
	PORT (
		Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		Load : IN STD_LOGIC;
		Push : IN std_logic;
		Pop : IN std_logic;
		Input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		stack_full : OUT std_logic;
		stack_empty : OUT std_logic
	);
END Stack_Pointer;

ARCHITECTURE Behavioral OF Stack_Pointer IS
	SIGNAL stackCursor : std_logic_vector(15 DOWNTO 0) := std_logic_vector(to_unsigned(255, 15));
	CONSTANT upperLimit : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
	CONSTANT lowerLimit : std_logic_vector(15 DOWNTO 0) := std_logic_vector(to_unsigned(255, 15));
	SIGNAL empty, full : std_logic := '0';
BEGIN
	Output <= stackCursor;
	stack_full <= full;
	stack_empty <= empty;
 
	updateLimits : PROCESS (stackCursor)
	BEGIN
		IF stackCursor = lowerLimit THEN
			empty <= '1';
			full <= '0';
		ELSIF stackCursor = upperLimit THEN
			empty <= '0';
			full <= '1';
		ELSE
			empty <= '0';
			full <= '0';
		END IF;
	END PROCESS;
 
	pushpop : PROCESS (Clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF Rst = '1' THEN
				stackCursor <= lowerLimit;
			ELSIF Enable = '1' THEN
				IF Load = '1' THEN
					stackCursor <= Input;
				END IF;
				IF pop = '1' AND empty = '0' THEN
					stackCursor <= stackCursor + 1;
				END IF;
				IF push = '1' AND full = '0' THEN
					stackCursor <= stackCursor - 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;