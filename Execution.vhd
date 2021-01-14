library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Execution is
    Port ( 
           OpCode : in STD_LOGIC_VECTOR (7 downto 0);
           Zero : in STD_LOGIC;
           Negative : in STD_LOGIC;
           OVF : in STD_LOGIC;
           Carry : in STD_LOGIC;
           HalfCarry : in STD_LOGIC;
           AluOutput: in STD_LOGIC_VECTOR(7 downto 0);
           CC : in STD_LOGIC_VECTOR(6 downto 0);
           CCSets : out STD_LOGIC_VECTOR(6 downto 0);
           CCResets : out STD_LOGIC_VECTOR(6 downto 0);
           ResetMem : out STD_LOGIC; --Clear Instruction
           ResetTempRegisters : out STD_LOGIC; --Flush
           ResetRegBank : out STD_logic;
           FirstOperandMux : out STD_LOGIC_VECTOR(1 downto 0); --00=>MEM 01=>RegisterBank 10=>Stack
           SecondOperandMux : out STD_LOGIC;
           WBMux : out STD_LOGIC_VECTOR(1 downto 0); --00=>ALU 01=>RegisterBank 10=>IMM
           Push : out STD_LOGIC;
           Pop : out STD_LOGIC;
           WRegBank : out STD_LOGIC;
           Jmp : out STD_LOGIC;
           WrMem : out STD_LOGIC;
           RegBankMux : out STD_LOGIC_VECTOR(1 downto 0);
           AluOp: out std_logic_vector(3 downto 0);
           RstCondCode: in std_logic;
           ImmAddr: out STD_LOGIC);
end Execution;

architecture Behavioral of Execution is
signal AluOpTemp: std_logic_vector(3 downto 0):=(others=>'0');
begin
    CCSets <=(others=>'0');
    CCResets <=(others=>'0');
    ResetMem <='0'; 
    ResetTempRegisters <='0'; 
    ResetRegBank  <='0';
    FirstOperandMux <="00";
    SecondOperandMux <='0';
    WBMux <="00";
    Push <='0';
    Pop <='0';
    WRegBank <='0';
    Jmp <='0';
    WrMem <='0';
    RegBankMux<="00";
    AluOp<=(others=>'1');
    ImmAddr<='0';
    AluOp<=AluOpTemp;
    process(OpCode)
    begin
        case OpCode is
            when x"B6"=>AluOpTemp<="1111"; --LD REG MEM
                        WRegBank<='1'; RegBankMux<="01";FirstOperandMux<="00"; --We load the data from memory in the Accumulator
                        if AluOutput=x"00" then CCResets<="0000100"; CCSETS<="0000010"; elsif AluOutput(7)='1' then CCresets<="0000010"; CCSETS<="0000100"; else CCResets<="0000110";CCSets<=(others=>'0');end if;
            when x"B7"=>AluOpTemp<="1111"; --LD MEM REG
                        WrMem<='1'; RegBankMux<="01"; WbMux<="01"; FirstOperandMux<="01";
                        if AluOutput=x"00" then CCResets<="0000100"; CCSETS<="0000010"; elsif AluOutput(7)='1' then CCresets<="0000010"; CCSETS<="0000100"; else CCResets<="0000110";CCSets<=(others=>'0');end if; 
            when x"35"=>AluOpTemp<="1111"; --MOV MEM IMM
                        WrMem<='1'; WbMux<="10";
            when x"5"=>AluOpTemp<=(others=>'1');
                        WrMem<='1'; FirstOperandMux<="00"; WbMux<="00"; ImmAddr<='1';
            when x"3F"=>AluOpTemp<=(others=>'1'); --CLR MEM
                        ResetMem<='1'; 
                        CCSets<="0000010";CCResets<="0000100";
            when x"4F"=>AluOpTemp<=(others=>'1'); --CLR A
                        ResetRegBank<='1'; RegBankMux<="01";
                        CCSets<="0000010";CCResets<="0000100";
            when x"88"=>AluOpTemp<="1111"; --PUSH A
                        RegBankMux<="01"; WbMux<="01";Push<='1';
            when x"4B"=>AluOpTemp<="1111"; --PUSH IMM
                         WbMux<="10"; Push<='1';
            when x"3B"=>AluOpTemp<="1111"; --PUSH MEM
                         WbMux<="00"; FirstOperandMux<="00"; Push<='1';
            when x"84"=>AluOpTemp<="1111"; --POP A
                         RegBankMux<="01"; Pop<='1'; WRegBank<='1'; FirstOperandMux<="10";
            when x"86"=>AluOpTemp<="1111"; --POP CC
                        Pop<='1'; FirstOperandMux<="10"; CCSets<=AluOutput(6 downto 0) or "0000000"; CCResets<=(Not AluOutput(6 downto 0)) or "0000000";
            when x"32"=>AluOpTemp<="1111"; --POP MEM
                        Pop<='1'; FirstOperandMux<="10"; WrMem<='1'; WbMux<="00";
            when x"3C"=>AluOpTemp<="1101"; --INC MEM
                        FirstOperandMux<="00"; WbMux<="00"; WrMem<='1';
                        CCSets<=OVF & "000" & Negative & Zero & '0';CCResets<=(NOT OVF) & "000" & (NOT Negative) & (NOT Zero) & '0';
            when x"4C"=>AluOpTemp<="1101"; --INC A
                        FirstOperandMux<="01"; RegBankMux<="01"; WRegBank<='1';
                        CCSets<=OVF & "000" & Negative & Zero & '0';CCResets<=(NOT OVF) & "000" & (NOT Negative) & (NOT Zero) & '0';
            when x"3A"=>AluOpTemp<="1110"; --DEC MEM
                        FirstOperandMux<="00"; WbMux<="00"; WrMem<='1';
                        CCSets<=OVF & "000" & Negative & Zero & '0';CCResets<=(NOT OVF) & "000" & (NOT Negative) & (NOT Zero) & '0';
            when x"4A"=>AluOpTemp<="1110"; --DEC A
                        FirstOperandMux<="01"; RegBankMux<="01"; WRegBank<='1';
                        CCSets<=OVF & "000" & Negative & Zero & '0';CCResets<=(NOT OVF) & "000" & (NOT Negative) & (NOT Zero) & '0';
            when x"3D"=>AluOpTemp<="1111"; --TNZ MEM
                        FirstOperandMux<="00";  if AluOutput=x"00" then CCResets<="0000100"; CCSETS<="0000010"; elsif AluOutput(7)='1' then CCresets<="0000010"; CCSETS<="0000100"; else CCResets<="0000110";CCSets<=(others=>'0');end if;
            when x"4D"=>AluOpTemp<="1111"; --TNZ REG
                        RegBankMux<="01"; FirstOperandMux<="01";  if AluOutput=x"00" then CCResets<="0000100"; CCSETS<="0000010"; elsif AluOutput(7)='1' then CCresets<="0000010"; CCSETS<="0000100"; else CCResets<="0000110";CCSets<=(others=>'0');end if;
            when x"B5"=>AluOpTemp<="0111"; --BCP
                        FirstOperandMux<="00"; SecondOperandMux<='0'; RegBankMux<="01";
                        CCSets<="0000" & Negative & Zero & '0';CCResets<="0000" & (NOT Negative) & (NOT Zero) & '0';
            when x"B1"=>AluOpTemp<="0001"; --CP
                        FirstOperandMux<="00"; SecondOperandMux<='0'; RegBankMux<="01";
                        CCSets<=OVF &"000" & Negative & Zero & Carry;CCResets<=(NOT OVF) &"000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"B4"=>AluOpTemp<="0111"; --AND
                        FirstOperandMux<="00"; SecondOperandMux<='0'; RegBankMux<="01"; WRegBank<='1';
                        CCSets<="0000" & Negative & Zero & '0';CCResets<="0000" & (NOT Negative) & (NOT Zero) & '0';
            when x"BA"=>AluOpTemp<="1000"; --OR
                        FirstOperandMux<="00"; SecondOperandMux<='0'; RegBankMux<="01"; WRegBank<='1';
                       CCSets<="0000" & Negative & Zero & '0';CCResets<="0000" & (NOT Negative) & (NOT Zero) & '0';
            when x"B8"=>AluOpTemp<="1001"; --XOR
                        FirstOperandMux<="00"; SecondOperandMux<='0'; RegBankMux<="01"; WRegBank<='1';
                        CCSets<="0000" & Negative & Zero & '0';CCResets<="0000" & (NOT Negative) & (NOT Zero) & '0';
            when x"11"=>AluOpTemp<="1010"; --BSET
                        FirstOperandMux<="00"; SecondOperandMux<='1'; WbMux<="00"; WrMem<='1';
            when x"12"=>AluOpTemp<="1011"; --BRES
                        FirstOperandMux<="00"; SecondOperandMux<='1'; WbMux<="00"; WrMem<='1';
            when x"13"=>AluOpTemp<="1100"; --BCPL
                        FirstOperandMux<="00"; SecondOperandMux<='1'; WbMux<="00"; WrMem<='1';
            when x"3"=>AluOpTemp<="0001"; --JEF Jump if not equal 
                       if CC(1)='0' then jmp<='1'; ResetTempRegisters<='1'; end if;                   
            when x"4"=>AluOpTemp<="0001"; --JLT Jump lower true. Two made up functions
                       if CC(2)='1' then jmp<='1';ResetTempRegisters<='1'; end if;
            when x"30"=>AluOpTemp<="0011"; --NEG MEM
                        FirstOperandMux<="00"; WbMux<="00"; WrMem<='1';
                        CCSets<=OVF & "000" & Negative & Zero & Carry;CCResets<=(NOT OVF) & "000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"40"=>AluOpTemp<="0011"; --NEG A
                        FirstOperandMux<="01"; WRegBank<='1'; RegBankMux<="01";
                        CCSets<=OVF & "000" & Negative & Zero & Carry;CCResets<=(NOT OVF) & "000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"BB"=>AluOpTemp<="0000"; --ADD
                        FirstOperandMux<="00"; SecondOperandMux<='0'; RegBankMux<="01"; WRegBank<='1';
                        CCSets<=OVF & '0' & HalfCarry & '0' & Negative & Zero & Carry;CCResets<=(NOT OVF) & '0' & (NOT HalfCarry) & '0' & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"B0"=>AluOpTemp<="0001"; --SUB A MEM
                        FirstOperandMux<="00"; SecondOperandMux<='0'; RegBankMux<="01"; WRegBank<='1';
                        CCSets<=OVF & "000" & Negative & Zero & Carry;CCResets<=(NOT OVF) & "000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"38"=>AluOpTemp<="0100"; --SLL MEM
                        FirstOperandMux<="00"; WbMux<="00"; WrMem<='1';
                        CCSets<="0000" & Negative & Zero & Carry;CCResets<="0000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"48"=>AluOpTemp<="0100"; --SLL REG
                        FirstOperandMux<="01"; WRegBank<='1'; RegBankMux<="01";
                        CCSets<="0000" & Negative & Zero & Carry;CCResets<="0000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"37"=>AluOpTemp<="0110"; --SRA MEM
                        FirstOperandMux<="00"; WbMux<="00"; WrMem<='1';
                        CCSets<="0000" & Negative & Zero & Carry;CCResets<="0000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"47"=>AluOpTemp<="0110"; --SRA REG
                        FirstOperandMux<="01"; WRegBank<='1'; RegBankMux<="01";
                        CCSets<="0000" & Negative & Zero & Carry;CCResets<="0000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"34"=>AluOpTemp<="0101"; --SRL MEM
                        FirstOperandMux<="00"; WbMux<="00"; WrMem<='1';
                        CCSets<="0000" & Negative & Zero & Carry;CCResets<="0000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"44"=>AluOpTemp<="0101"; --SRL REG
                        FirstOperandMux<="01"; WRegBank<='1'; RegBankMux<="01";
                        CCSets<="0000" & Negative & Zero & Carry;CCResets<="0000" & (NOT Negative) & (NOT Zero) & (NOT Carry);
            when x"CC"=>AluOpTemp<=(others=>'1'); --JP
                        Jmp<='1'; ResetTempRegisters<='1';
            when x"9B"=>AluOpTemp<=(others=>'1'); --SIM
                        CCSets<="0101000"; CCResets<=(others=>'0');
            when x"9A"=>AluOpTemp<=(others=>'1'); --RIM
                        CCSets<="0100000"; CCResets<="0001000";
            when x"99"=>AluOpTemp<=(others=>'1'); --SCF
                        CCSets<="0000001"; CCResets<=(others=>'0');
            when x"98"=>AluOpTemp<=(others=>'1'); --RCF
                        CCSets<=(others=>'0');  CCResets<="0001001";
            when x"8C"=>AluOpTemp<=(others=>'1'); --CCF
                        if CC(0)='1' then CCResets<="0000001"; CCSETS<=(others=>'0'); else CCresets<=(others=>'0'); CCSETS<="0000001"; end if;
            when others=>AluOpTemp<=(others=>'1'); --NOP
                        CCSets<=(others=>'0'); CCResets<=(others=>'0');
        end case;            
    end process;
end Behavioral;
