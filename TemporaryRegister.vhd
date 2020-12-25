library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TemporaryRegister is
    Generic (N: integer);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Input : in STD_LOGIC_VECTOR (N-1 downto 0);
           Output : out STD_LOGIC_VECTOR (N-1 downto 0));
end TemporaryRegister;

architecture Behavioral of TemporaryRegister is
signal temp:std_logic_vector(N-1 downto 0):=(others=>'0');
begin
    Output<=temp;
    process(Clk,Rst)
    begin
        if Rst='1' then
            temp<=(others=>'0');   
        elsif clk='1' and clk'event then
            temp<=Input;
        end if;
    end process;
 
end Behavioral;
