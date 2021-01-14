library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (1 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end Main;

architecture Behavioral of Main is

component MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component Instruction_Memory is
    Port(Clk:in std_logic;
         Addr: in STD_LOGIC_VECTOR(23 downto 0);
         Instr : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component FetchBuffer is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (31 downto 0);
           InstrOut : out STD_LOGIC_VECTOR (31 downto 0);
           Stall : out STD_LOGIC);
end component;


component PC is
    PORT (
		Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		En : IN STD_LOGIC;
		jmp : IN STD_LOGIC;
        jmpa : in STD_LOGIC_VECTOR (23 downto 0);
		Output : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
end component;
component Execution is
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
           AluOp:out std_logic_vector(3 downto 0);
           RstCondCode: in std_logic;
           ImmAddr : out std_logic);
end component;

component RAM IS
	PORT (
		Clk : IN std_logic;
		wr : IN std_logic;
		r : IN std_logic;
		addr : IN std_logic_vector(7 DOWNTO 0);
		wraddr : IN std_logic_vector(7 DOWNTO 0);
		data_in : IN std_logic_vector(7 DOWNTO 0);
		data_out : OUT std_logic_vector(7 DOWNTO 0));
END component;

component RegisterBank is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Write : in STD_LOGIC;
           Input : in STD_LOGIC_VECTOR (7 downto 0);
           MuxRegister : in STD_LOGIC_VECTOR (1 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component ALU is
    Port ( Input1 : in STD_LOGIC_VECTOR (7 downto 0);
           Input2 : in STD_LOGIC_VECTOR (7 downto 0);
           AluOP : in STD_LOGIC_VECTOR (3 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           Zero : out STD_LOGIC;
           Negative : out STD_LOGIC;
           OVF : out STD_LOGIC;
           Carry : out STD_LOGIC;
           HalfCarry : out STD_LOGIC);
end component;
component ConditionCodeRegister is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Resets : in std_logic_vector(6 downto 0);
           Sets: in STd_Logic_vector(6 downto 0);
           Display: out std_logic_vector(6 downto 0));
end component;
component Stack_Pointer IS
	PORT (
		Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		Push : IN std_logic;
		Pop : IN std_logic;
		Input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		stack_full : OUT std_logic;
		stack_empty : OUT std_logic
	);
END component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (7 downto 0);
           catozi : out STD_LOGIC_VECTOR(6 downto 0);
           anozi : out STD_LOGIC_VECTOR(1 downto 0));
end component;

component TemporaryRegister is
    Generic (N: integer);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Input : in STD_LOGIC_VECTOR (N-1 downto 0);
           Output : out STD_LOGIC_VECTOR (N-1 downto 0));
end component;
signal PCSignal:std_logic_vector(23 downto 0):=(others=>'0');
signal InstructionIn,InstructionOut:std_logic_vector(31 downto 0):=(others=>'0');
signal wrMem,RstMem,Stall,flushSignal,jmp,RstStack,Push,Pop,StackFull,StackEmpty:std_logic:='0';
signal wrBackData,wrAddressIn:std_logic_vector(7 downto 0):=(others=>'0');
signal jmpa:std_logic_vector(23 downto 0):=(others=>'0');
--Decode/MemRead signals
signal Imm,wrAddr,wrData,stackOutput,memOutput,opCode,AddrRegOutFirst:std_logic_vector(7 downto 0):=(others=>'0');
--Execution/WriteBack signals
signal stackOutputEx,memOutputEx,RegBankOutput,AluOutput,FirstOperandMuxOuput,SecondOperandMuxOuput,WBMuxOuput,WrAddress:std_logic_vector(7 downto 0):=(others=>'0');
signal RstRegBank,wrRegBank,Zero,Negative,OVF,Carry,RstCondCode,HalfCarry,SecondOperandMux:std_logic:='0';
signal MuxRegister,FirstOperandMux,WBMux:std_logic_vector(1 downto 0):="00";
signal CCSets,CCResets,CC:std_logic_vector(6 downto 0):=(others=>'0');
signal AluOp:std_logic_vector(3 downto 0):=(others=>'0');
signal MPGsignal,ImmAddr:std_logic:='0';
signal sExec,SignalExec,SignalFetch:std_logic_vector(2 downto 0):=(others=>'0');
begin
    led<=CC;
    process(ImmAddr)
    begin
        if ImmAddr = '0' then
            WrAddress<=AddrRegOutFirst;
        else
            WrAddress<=Imm;
        end if;
    end process;
    --Fetch
    jmpa(7 downto 0)<=Imm;
    ProgramCounter: PC port map(Clk,Rst,MPGSignal,jmp,jmpa,PCSignal);
    InstrMem: Instruction_Memory port map(Clk,PCSignal,InstructionIn);
    FetchBuff:FetchBuffer port map(Clk,Rst,InstructionIn,InstructionOut,Stall);
    WbRegisterPipe:TemporaryRegister generic map(8) port map(Clk,flushSignal,wrBackData,wrData);
    AddRegisterPipe:TemporaryRegister generic map(8) port map(Clk,flushSignal,wrAddressIn,wrAddr);   
    --Decode/MemRead
    Stack: Stack_Pointer port map(Clk,SignalFetch(0),SignalFetch(1),SignalFetch(2),WrData,stackOutput,StackFull,StackEmpty);
    Mem: RAM port map(Clk,wrMem,SignalFetch(0),InstructionOut(15 downto 8),wrAddr,wrData,memOutput);
    OpcodeReg:TemporaryRegister generic map(8) port map(Clk,flushSignal,InstructionOut(23 downto 16),opCode);
    Immediate:TemporaryRegister generic map(8) port map(Clk,flushSignal,InstructionOut(7 downto 0),Imm);
    StackReg:TemporaryRegister generic map(8) port map(Clk,flushSignal,stackOutput,stackOutputEx);
    MemReg:TemporaryRegister generic map(8) port map(Clk,flushSignal,MemOutput,memOutputEx);
    AddrReg:TemporaryRegister generic map(8) port map(Clk,FlushSignal,InstructionOut(15 downto 8),AddrRegOutFirst);
    
    --Execution/WriteBack
    process(FirstOperandMux)
    begin
        case FirstOperandMux is
            when "00"=>FirstOperandMuxOuput<=MemOutputEx;
            when "01"=>FirstOperandMuxOuput<=RegBankOutput;
            when "10"=>FirstOperandMuxOuput<=StackOutputEx;
            when others=>FirstOperandMuxOuput<=(others=>'0');
        end case;
    end process;
    process(SecondOperandMux)
    begin
        case SecondOperandMux is
            when '0' =>SecondOperandMuxOuput<=RegBankOutput;
            when '1' =>SecondOperandMuxOuput<=Imm;
        end case;
    end process;
    process(WbMux)
    begin
        case WbMux is
            when "00"=>WbMuxOuput<=AluOutput;
            when "01"=>WbMuxOuput<=RegBankOutput;
            when "10"=>WbMuxOuput<=Imm;
            when others=>WbMuxOuput<=(others=>'0');
        end case;
    end process;
    Exec:Execution port map(opCode,Zero,Negative,OVF,Carry,HalfCarry,AluOutput,CC,CCSets,CCResets,sExec(0),flushSignal,RstRegBank,FirstOperandMux,SecondOperandMux,WBMux,SExec(1),SExec(2),WrRegBank,Jmp,WrMem,MuxRegister,AluOp,RstCondCode);
    RegBank: RegisterBank port map(Clk,RstRegBank,wrRegBank,AluOutput,MuxRegister,RegBankOutput);
    ArithUnit: ALU port map(FirstOperandMuxOuput,SecondOperandMuxOuput,AluOp,AluOutput,Zero,Negative,OVF,Carry,HalfCarry);
    ConditionCode:ConditionCodeRegister port map(Clk,RstCondCode,CCResets,CCSets,CC);
    WbRegister:TemporaryRegister generic map(8) port map(Clk,flushSignal,WBMuxOuput,WrBackData);
    AddrRegister:TemporaryRegister generic map(8) port map(Clk,flushSignal,WrAddress,wrAddressIn);
    SignExec: TemporaryRegister generic map(3) port map(Clk,flushSignal,sExec,SignalExec);
    SFetch: TemporaryRegister generic map(3) port map(Clk,flushSignal,SignalExec,SignalFetch);
    Afisor: SSD port map(clk, AluOutput,cat,an);
    ButtonClock: MPG port map(clk,btn,MPGSignal);
end Behavioral;
