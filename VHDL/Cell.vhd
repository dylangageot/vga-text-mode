----------------------------------------------------------------------------------
-- Author : Dylan Gageot
-- 
-- Create Date:    09:37:37 01/05/2018 
-- Design Name:    Cell	
-- Module Name:    Cell - Behavioral 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Cell is
    Port ( Clk : in  STD_LOGIC;
		   Active : in STD_LOGIC;
		   Reset : in STD_LOGIC;
           HPOS : in  STD_LOGIC_VECTOR (10 downto 0);
           VPOS : in  STD_LOGIC_VECTOR (10 downto 0);
           RAM_Address : out  STD_LOGIC_VECTOR (12 downto 0);
           ROM_Address : out  STD_LOGIC_VECTOR (2 downto 0);
           Set_Out : out  STD_LOGIC;
           Shift_Out : out  STD_LOGIC);
end Cell;

architecture Behavioral of Cell is

	component divider
		port (
		clk: in std_logic;
		rfd: out std_logic;
		dividend: in std_logic_vector(10 downto 0);
		divisor: in std_logic_vector(3 downto 0);
		quotient: out std_logic_vector(10 downto 0);
		fractional: out std_logic_vector(3 downto 0));
	end component;


	type type_state is (loading, shifting1, shifting2, shifting3, shifting4, shifting5, shifting6, shifting7);
	signal state, next_state : type_state;
	signal RAM_Temp : std_logic_vector (15 downto 0) := (others => '0');

begin

	RAM_Temp <= std_logic_vector(unsigned(HPOS(10 downto 3)) + unsigned(VPOS(10 downto 3))*80);
	ROM_Address <= VPOS(2 downto 0);
	RAM_Address <= RAM_Temp(12 downto 0);

	process (Clk)
	begin
		if rising_edge(Clk) then
			if Reset = '0' and Active = '1' then
				state <= next_state;
			else
				state <= loading;
			end if;
		end if;
	end process;
	
	process (state, VPOS)
	begin
		case state is
			
			when loading =>
				Set_Out <= '1';
				Shift_Out <= '0';
				next_state <= shifting1;
				
			when shifting1 =>
				Set_Out <= '0';
				Shift_Out <= '1';
				next_state <= shifting2;
			
			when shifting2 =>
				Set_Out <= '0';
				Shift_Out <= '1';
				next_state <= shifting3;
				
			when shifting3 =>
				Set_Out <= '0';
				Shift_Out <= '1';
				next_state <= shifting4;
			
			when shifting4 =>
				Set_Out <= '0';
				Shift_Out <= '1';
				next_state <= shifting5;
				
			when shifting5 =>
				Set_Out <= '0';
				Shift_Out <= '1';
				next_state <= shifting6;
				
			when shifting6 =>
				Set_Out <= '0';
				Shift_Out <= '1';
				next_state <= shifting7;
				
			when shifting7 =>
				Set_Out <= '0';
				Shift_Out <= '1';
				next_state <= loading;
			
		end case;
	end process;

end Behavioral;