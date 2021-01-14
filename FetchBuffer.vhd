library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FetchBuffer is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (31 downto 0);
           InstrOut : out STD_LOGIC_VECTOR (31 downto 0);
           Stall : out STD_LOGIC);
end FetchBuffer;

architecture Behavioral of FetchBuffer is
Type WORDS_TYPE is array (2 downto 0) of std_logic_vector(31 downto 0);
signal words: WORDS_TYPE :=(others=>(others=>'0'));
signal count: integer  range 1 to 3 := 1;
signal full: std_logic:='0';
begin   
    InstrOut<=words(count);
    process(Clk)
    begin
        if clk'event and clk='1' then
            if Rst='1' then
                words<=(others=>(others=>'0'));
            else
                words(count)<=Instr;
                if Full='1' then
                    Stall<='0';
                else
                    Stall<='1';
                end if;
                if count = 3 then
                    Full<='1';
                    count<=1;
                else
                    Full<='0';
                    count<=count+1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
