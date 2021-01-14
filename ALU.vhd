library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
entity ALU is
    Port ( Input1 : in STD_LOGIC_VECTOR (7 downto 0);
           Input2 : in STD_LOGIC_VECTOR (7 downto 0);
           AluOP : in STD_LOGIC_VECTOR (3 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           Zero : out STD_LOGIC;
           Negative : out STD_LOGIC;
           OVF : out STD_LOGIC;
           Carry : out STD_LOGIC;
           HalfCarry : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
signal temp:std_logic_vector(7 downto 0):=(others=>'0');
begin
    process(AluOp)
    begin
        case AluOp is
            when "0000"=>temp<=Input1 + Input2; --ADD
                        OVF<=((Input1(7) and Input2(7)) or (Input2(7) and (NOT temp(7))) or (NOT temp(7) and Input1(7))) xor ((Input1(6) and Input2(6)) or (Input2(6) and (NOT temp(6))) or (NOT temp(6) and Input1(6)));
                        HalfCarry<=(Input1(3) and Input2(3)) or (Input2(3) and (NOT temp(3))) or ((NOT temp(3)) and Input1(3)); 
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));
                        Carry<=(Input1(7) and Input2(7)) or (Input2(7) and (NOT temp(7))) or ((NOT temp(7)) and Input1(7)); 
            when "0001"=>temp<=Input1 - Input2; --SUB
                        OVF<=((Input1(7) and Input2(7)) or (Input1(7) and temp(7)) or (temp(7) and Input1(7) and Input2(7))) xor ((Input1(6) and Input2(6)) or (Input1(6) and temp(6)) or (temp(6) and Input1(6) and Input2(6)));
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));
                        Carry<=((NOT Input1(7)) and Input2(7)) or ((NOT Input1(7)) and temp(7)) or (temp(7) and Input1(7) and Input2(7)); 
            --when "0010"=>temp<=Input1 * Input2; --MUL
            --            Carry<='0';
            --            HalfCarry<='0';
            when "0011"=>temp<=NOT Input1; --NEG
                        OVF<=temp(7) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));
                        Carry<=temp(7) or temp(6) or temp(5) or temp(4) or temp(3) or temp(2) or temp(1) or temp(0);
            when "0100"=>temp<=Input1(7 downto 1) & '0'; --SLL
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));
                        Carry<=Input1(7);
            when "0101"=>temp<='0' & Input1(6 downto 0); --SRL
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));
                        Carry<=Input1(0);
            when "0110"=>temp<=Input1(7) & Input1(7 downto 1); --SRA
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));
                        Carry<=Input1(0);
            when "0111"=>temp<=Input1 and Input2; --AND/BCP
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));
            when "1000"=>temp<=Input1 OR Input2; --OR
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));          
            when "1001"=>temp<=Input1 XOR Input2;--XOR
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));          
            when "1010"=>temp<=Input1 OR Input2; --BSET but second operand is 000..1..0 where 1 is the bit we want to set
            when "1011"=>temp<=INPUT1 AND (NOT INPUT2); --BRES but second operand is 000..1..0 where 1 is the bit we want to reset
            when "1100"=>temp<=Input1;
                        temp(to_integer(unsigned(Input2)))<=NOT temp(to_integer(unsigned(Input2))); --BCPL where Input2 is the position of the bit we want to complement
            when "1101"=>temp<=Input1+1; --INC
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));          
                        OVF<=((Input1(7) and Input2(7)) or (Input2(7) and (NOT temp(7))) or (NOT temp(7) and Input1(7))) xor ((Input1(6) and Input2(6)) or (Input2(6) and (NOT temp(6))) or (NOT temp(6) and Input1(6)));
            when "1110"=>temp<=Input1-1;
                        Negative<=temp(7);
                        Zero<=(NOT temp(7)) and NOT(temp(6)) and NOT(temp(5)) and NOT(temp(4)) and NOT(temp(3)) and NOT(temp(2)) and NOT(temp(1)) and NOT(temp(0));          
                        OVF<=((Input1(7) and Input2(7)) or (Input2(7) and (NOT temp(7))) or (NOT temp(7) and Input1(7))) xor ((Input1(6) and Input2(6)) or (Input2(6) and (NOT temp(6))) or (NOT temp(6) and Input1(6)));
            when "1111"=>temp<=Input1;
            when others=>temp<=(others=>'0');
        end case;
    end process;

end Behavioral;
