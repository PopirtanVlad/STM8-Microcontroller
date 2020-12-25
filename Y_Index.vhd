Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Y_Index is
   PORT(Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		En : IN STD_LOGIC;
		YH_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		YL_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		YH_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		YL_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end Y_Index;

architecture Behavioral of Y_Index is
signal YH:std_logic_vector(7 downto 0):=(others=>'0');
signal YL:std_logic_vector(7 downto 0):=(others=>'0');
begin
    YH_OUT<=YH;
    YL_OUT<=YL;
    process(Clk)
    begin
        if Clk'event and Clk='1' then
            if En='1' then
                YH<=YH_IN;
                YL<=YL_IN;
            end if;
        end if;
    end process;

end Behavioral;
