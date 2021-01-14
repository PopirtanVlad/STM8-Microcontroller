library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ConditionCodeRegister is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Resets : in std_logic_vector(6 downto 0);
           Sets: in STd_Logic_vector(6 downto 0);
           Display: out std_logic_vector(6 downto 0);
           RstCondCode: in std_logic);
end ConditionCodeRegister;

architecture Behavioral of ConditionCodeRegister is
signal RegisterContent:std_logic_vector(6 downto 0);
begin
    Display<=RegisterContent;
    process(Clk)
    begin
        if RstCondCode='1' then
            RegisterContent<=(others=>'0');
        else
            for I in 0 to 6 loop
                if Sets(I)='1' then
                    RegisterContent(I)<='1';
                elsif Resets(I)='1' then
                    RegisterContent(I)<='0';
                end if;
        end loop;
        end if;
    end process;
end Behavioral;
