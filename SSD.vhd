library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (7 downto 0);
           catozi : out STD_LOGIC_VECTOR(6 downto 0);
           anozi : out STD_LOGIC_VECTOR(1 downto 0));
end SSD;

architecture Behavioral of SSD is
signal temp_count:std_logic_vector(15 downto 0):=(others=>'0');
signal mux_catozi_out:std_logic_vector(3 downto 0):=(others=>'0');
signal mux_anozi_out:std_logic_vector(1 downto 0):=(others=>'0');
signal catozi_out:std_logic_vector(6 downto 0):=(others=>'0');
begin
    anozi<=mux_anozi_out;
    catozi<=catozi_out;
    
    process(clk)
    begin    
        if clk'event and clk='1' then
            temp_count<=temp_count+1;
        end if;
    end process;
    
    process(temp_count)
    begin
        case temp_count(15) is
            when '0' =>mux_catozi_out<=digits(3 downto 0);
            when '1' =>mux_catozi_out<=digits(7 downto 4);
        end case;
        case temp_count(15) is
            when '0' =>mux_anozi_out<="10";
            when '1' =>mux_anozi_out<="01";
        end case;
        
    end process;
    
    process(mux_catozi_out)
    begin
        case mux_catozi_out is
            when "0001"=>catozi_out<="1111001";
            when "0010"=>catozi_out<="0100100";
            when "0011"=>catozi_out<="0110000";
            when "0100"=>catozi_out<="0011001";
            when "0101"=>catozi_out<="0010010";
            when "0110"=>catozi_out<="0000010";
            when "0111"=>catozi_out<="1111000";
            when "1000"=>catozi_out<="0000000";
            when "1001"=>catozi_out<="0010000";
            when "1010"=>catozi_out<="0001000";
            when "1011"=>catozi_out<="0000011";
            when "1100"=>catozi_out<="1000110";
            when "1101"=>catozi_out<="0100001";
            when "1110"=>catozi_out<="0000110";
            when "1111"=>catozi_out<="0001110";
            when others=>catozi_out<="1000000";
         end case;
    end process;
        

    
end Behavioral;
