library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ConditionCodeRegister is
    Generic(NrBits : integer);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Resets : in std_logic_vector(7 downto 0);
           Sets: in STd_Logic_vector(7 downto 0);
           Display: out std_logic_vector(7 downto 0));
end ConditionCodeRegister;

architecture Behavioral of ConditionCodeRegister is
signal RegisterContent:std_logic_vector(7 downto 0);
begin
    process(Clk)
    begin
        for I in 0 to 7 loop
            if Sets(I)='1' then
                RegisterContent(I)<='1';
            elsif Resets(I)='1' then
                RegisterContent(I)<='0';
            end if;
            
        end loop;
    end process;
end Behavioral;
