library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Easier mode to access the register we want from the Register bank.

entity RegisterBank is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Write : in STD_LOGIC;
           Input : in STD_LOGIC_VECTOR (7 downto 0);
           MuxRegister : in STD_LOGIC_VECTOR (1 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0));
end RegisterBank;

architecture Behavioral of RegisterBank is
component Accumulator IS
	PORT (
		Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		Input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END component;

component X_Index is
   PORT(Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		En : IN STD_LOGIC;
		XH_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		XL_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		XH_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		XL_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component Y_Index is
   PORT(Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
		En : IN STD_LOGIC;
		YH_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		YL_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		YH_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		YL_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;
signal Aoutput,XOutputL,YOutputL,XOutputH,YOutputH: std_logic_vector(7 downto 0):=(others=>'0');
signal AEn,XEn,YEn,RstA,RstX,RstY:std_logic:='0';
begin
   process(Clk)
   begin
        
            case MuxRegister is
                when "01"=>if Write='1' then
                                AEn<='1'; XEn<='0'; YEn<='0';
                            elsif Rst='1' then
                                RstA<='1';
                            end if;
                           Output<=AOutput;
                when "10"=>if Write='1' then
                                AEn<='0'; XEn<='1'; YEn<='0';
                           elsif Rst='1' then
                                RstX<='1';
                           end if;
                           Output<=XOutputL;
                when "11"=>if Write='1' then
                                AEn<='0'; XEn<='0'; YEn<='1';
                           elsif Rst='1' then
                                RstY<='1';
                           end if;
                           Output<=YOutputL;
                 when "00"=>AEn<='0'; XEn<='0'; YEn<='1';RstX<='0';RstA<='0';RstY<='0';Output<=(others=>'0');
            end case;
   end process;
   Yreg: Y_Index port map(Clk,RstY,YEn,"00000000",Input,YOutputH,YOutputL);
   Xreg: X_Index port map(Clk,RstX,XEn,"00000000",Input,YOutputH,XOutputL);
   Acc:Accumulator port map(Clk,RstA,AEn,Input,AOutput);
   
end Behavioral;
