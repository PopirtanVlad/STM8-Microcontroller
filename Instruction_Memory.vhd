library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
entity Instruction_Memory is
    Port(Clk:in std_logic;
         Addr: in STD_LOGIC_VECTOR(23 downto 0);
         Instr : out STD_LOGIC_VECTOR(31 downto 0));
end entity;

ARCHITECTURE Behavioral OF Instruction_Memory IS
TYPE INSTR_TYPE is array (255 downto 0) of std_logic_vector (31 downto 0); --The upper limit should be 16,777,216, but I used 255 for this project. 
signal Instructions : INSTR_TYPE :=(others=>(others=>'0'));

begin
    Instructions(0)<=x"0035000A";Instructions(1)<=x"00350102";Instructions(2)<=x"00350201";Instructions(3)<=x"00350301";Instructions(4)<=x"00B60200";
    Instructions(5)<=x"00BB0300";Instructions(6)<=x"00050302";Instructions(7)<=x"00B70200";Instructions(8)<=x"003C0100";Instructions(9)<=x"003C0000";
    Instructions(10)<=x"00B00100";Instructions(11)<=x"00030400";
    process(Clk)
    begin
        if Clk'event and Clk='1' then
            Instr<=Instructions(to_integer(unsigned(Addr)));
        end if;
    end process;
end Behavioral;