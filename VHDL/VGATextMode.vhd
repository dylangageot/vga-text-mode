----------------------------------------------------------------------------------
-- Author: Dylan Gageot
-- 
-- Create Date:    21:14:13 01/05/2018 
-- Design Name: 	 VGATextMode on VGA
-- Module Name:    VGATextMode - Behavioral 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VGATextMode is
    Port ( Clk : in  STD_LOGIC;
		     Reset : in STD_LOGIC;
			  RX : in STD_LOGIC;
			  TX : out STD_LOGIC;
           Hsync : out  STD_LOGIC;
           Vsync : out  STD_LOGIC;
           Color : out  STD_LOGIC_VECTOR(7 downto 0);
			  Led : out STD_LOGIC_VECTOR(7 downto 0);
           sw : in  STD_LOGIC_VECTOR(7 downto 0));
end VGATextMode;

architecture Behavioral of VGATextMode is

	-- Shift the line to activate pixel at the right moment
	COMPONENT Shift_Line
		PORT ( 
			Set : IN  STD_LOGIC;
			Shift : IN  STD_LOGIC;
			Reset : IN STD_LOGIC;
			ROM_In : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			Shifted_Out : OUT  STD_LOGIC;
			Clk : IN  STD_LOGIC
		);
	END COMPONENT;

	-- Count for character to draw, drive RAM and ROM
	COMPONENT Cell
		PORT ( 
			Clk : IN  STD_LOGIC;
			Active : IN STD_LOGIC;
			Reset : IN STD_LOGIC;
			HPOS : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
			VPOS : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
			RAM_Address : OUT  STD_LOGIC_VECTOR(12 DOWNTO 0);
			ROM_Address : OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
			Set_Out : OUT  STD_LOGIC;
			Shift_Out : OUT  STD_LOGIC
		);
	END COMPONENT;

	-- CGROM
	COMPONENT ROM
		PORT (
			clka : IN STD_LOGIC;
			addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	-- Deliver a 25.175 MHz to the circuit
	COMPONENT CLOCK
		PORT (
			CLK_IN1 : IN STD_LOGIC;
			CLK_OUT1 : OUT STD_LOGIC
		);
	END COMPONENT;

	-- Very clean VGA component made by Ulrich Zoltán
	COMPONENT vga_controller_640_60
		PORT (
			rst : IN STD_LOGIC;
			pixel_clk : IN STD_LOGIC;
			HS : OUT STD_LOGIC;
			VS : OUT STD_LOGIC;
			hcount : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
			vcount : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
			blank : OUT STD_LOGIC
		);
	END COMPONENT;
	
	-- Content of the 80x60 stored in the RAM
	COMPONENT RAM
		PORT (
			clka : IN STD_LOGIC;
			wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
			dina : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;
	
	-- uC MicroBlaze
	COMPONENT mb_mcs
		PORT (
			Clk : IN STD_LOGIC;
			Reset : IN STD_LOGIC;
			UART_Rx : IN STD_LOGIC;
			UART_Tx : OUT STD_LOGIC;
			GPO1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			GPO2 : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
			GPO3 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			GPI1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
		);
	END COMPONENT;
	
	signal Hcount, Vcount : STD_LOGIC_VECTOR(10 DOWNTO 0) := (others => '0');
	signal RAM_Out, RAM_In : STD_LOGIC_VECTOR(6 DOWNTO 0) := (others => '0');
	signal ROM_Address : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
	signal RAM_Address1, RAM_Address2, To_RAM : STD_LOGIC_VECTOR(12 DOWNTO 0) := (others => '0');
	signal ROM_Out : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	signal To_ROM : STD_LOGIC_VECTOR(9 DOWNTO 0) := (others => '0');
	signal RAM_Controller : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
	signal Set, Shift, Clk_25, Shift_Out, Blank, Active : STD_LOGIC := '0';

begin
	
	compo_clock : clock port map (	
		CLK_IN1 => Clk, 
		CLK_OUT1 => Clk_25
	);
		
	compo_cell : Cell port map (
		Clk => Clk_25, 
		Active => Active, 
		Reset => Reset, 
		HPOS => Hcount, 
		VPOS => Vcount, 
		RAM_Address => RAM_Address1, 
		ROM_Address => ROM_Address, 
		Set_Out => Set, 
		Shift_Out => Shift
	);
		
	compo_shift : Shift_Line port map (
		Clk => Clk_25,
		Set => Set, 
		Shift => Shift, 
		Reset => Reset, 
		ROM_In => ROM_Out, 
		Shifted_Out => Shift_Out
	);
		
	compo_ram : RAM port map (
		clka => Clk, 
		wea(0) => RAM_Controller(1), 
		addra => To_RAM, 
		dina => RAM_In, 
		douta => RAM_Out
	);
		
	compo_rom : ROM port map (
		clka => Clk_25, 
		addra => To_ROM, 
		douta => ROM_Out
	);
		
	compo_vga : vga_controller_640_60 port map (
		rst => Reset, 
		pixel_clk => Clk_25, 
		HS => Hsync, 
		VS => Vsync, 
		hcount => Hcount,
		vcount => Vcount, 
		blank => Blank
	);
		
	mcs_0 : mb_mcs port map (
		Clk => Clk, 
		Reset => Reset, 
		UART_Rx => RX, 
		UART_Tx => TX, 
		GPO1 => RAM_In, 
		GPO2 => RAM_Address2, 
		GPO3 => RAM_Controller, 
		GPI1(0) => Blank
	);
	
	-- Active the cell counter when display active
	Active <= not Blank;
	-- Concatenate ROM Address
	To_ROM <= RAM_Out & ROM_Address;
	-- Display pixel when the driver wanted to
	Color <= sw when ((Shift_Out = '1') and (Blank = '0')) else (others => '0');
	-- Mux for RAM Address (controlled by uC)
	To_RAM <= RAM_Address2 when (RAM_Controller(0) = '1') else RAM_Address1;
	-- Display RAM Address from the uC (DEBUG FUNCTION)
	Led <= RAM_Address2(7 DOWNTO 0);
	
end Behavioral;