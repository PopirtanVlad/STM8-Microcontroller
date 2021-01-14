LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY PC IS
	PORT (
		Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		En : IN STD_LOGIC;
		jmp : IN STD_LOGIC;
        jmpa : in STD_LOGIC_VECTOR (23 downto 0);
		Output : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
END PC;

ARCHITECTURE Behavioral OF PC IS
	SIGNAL temp : std_logic_vector(23 DOWNTO 0) := (OTHERS => '0');
	signal jump_output:std_logic_vector(23 downto 0):=(others=>'0');
    signal branch_output:std_logic_vector(23 downto 0):=(others=>'0');
BEGIN
	Output <= temp;
	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF Rst = '1' THEN
				temp <= (OTHERS => '0');
			ELSIF En = '1' THEN
				temp <= jump_output; 
			END IF;
		END IF;
	END PROCESS;
	
	process(jmp)
	begin
	   if jmp='1' then
	       jump_output<=jmpa;
	   else
	       jump_output<=temp+1;
	   end if; 
	end process;

END Behavioral;