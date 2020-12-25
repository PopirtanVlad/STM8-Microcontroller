Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity X_Index is
   PORT(Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		En : IN STD_LOGIC;
		XH_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		XL_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		XH_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		XL_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end X_Index;

architecture Behavioral of X_Index is
signal XH:std_logic_vector(7 downto 0):=(others=>'0');
signal XL:std_logic_vector(7 downto 0):=(others=>'0');
begin
    XH_OUT<=XH;
    XL_OUT<=XL;
    process(Clk)
    begin
        if Clk'event and Clk='1' then
            if En='1' then
                XH<=XH_IN;
                XL<=XL_IN;
            end if;
        end if;
    end process;

end Behavioral;
