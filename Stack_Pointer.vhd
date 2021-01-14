LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY Stack_Pointer IS
	PORT (
		Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		Push : IN std_logic;
		Pop : IN std_logic;
		Input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		stack_full : OUT std_logic;
		stack_empty : OUT std_logic
	);
END Stack_Pointer;

ARCHITECTURE Behavioral OF Stack_Pointer IS
	TYPE RAMTYPE IS ARRAY (255 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0);
	SIGNAL stack : RAMTYPE := (OTHERS => (OTHERS => '0'));
	SIGNAL stackCursor : integer := 255;
	CONSTANT upperLimit : integer := 0;
	CONSTANT lowerLimit : integer := 255;
	SIGNAL empty, full : std_logic := '0';
BEGIN
	Output <= stack(stackCursor);
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
				stack(stackCursor)<=(others=>'0');
			ELSIF pop = '1' AND empty = '0' THEN
					stackCursor <= stackCursor + 1;
			ELSIF push = '1' AND full = '0' THEN
				stackCursor <= stackCursor - 1;
				stack(stackCursor)<=Input;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;