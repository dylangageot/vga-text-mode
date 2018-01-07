----------------------------------------------------------------------------------
-- Author: Dylan Gageot
-- 
-- Create Date:    23:21:54 01/04/2018 
-- Design Name: 	Shift_Line
-- Module Name:    Shift_Line - Behavioral
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Shift_Line is
    Port ( Clk : in  STD_LOGIC;
		   Set : in  STD_LOGIC;
           Shift : in  STD_LOGIC;
		   Reset : in STD_LOGIC;
           ROM_In : in  STD_LOGIC_VECTOR (7 downto 0);
           Shifted_Out : out  STD_LOGIC
		 );
end Shift_Line;

architecture Behavioral of Shift_Line is

	signal Shift_Sig :  STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin

		Shifted_Out <= Shift_Sig(7);

		process (Clk)
		begin
			if rising_edge(CLK) then
				if Reset = '0' then
					if Set = '1' then
						Shift_Sig <= ROM_In;	
					else
						if Shift = '1' then
							Shift_Sig(7 downto 1) <= Shift_Sig(6 downto 0);
							Shift_Sig(0) <= '0';
						end if;
					end if;
				else
					Shift_Sig <= (others => '0');
				end if;
			end if;
		end process;

end Behavioral;