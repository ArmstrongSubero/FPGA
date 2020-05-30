----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:41:29 08/21/2017 
-- Design Name: 
-- Module Name:    cpu_clock - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_clock is
    Port ( clk : in  STD_LOGIC;
			  man_pulse: in STD_LOGIC;
			  sel : in STD_LOGIC;
           hlt : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end cpu_clock;

architecture Behavioral of cpu_clock is
 
   -- signal for counter
	signal q: std_logic_vector(23 downto 0);
	
	-- signal for debounce circuit
	signal temp: std_logic_vector(6 downto 0);
	signal notButton : std_logic;
	
	-- signal for mux out
	signal mon: std_logic;
	
	-- signal for intermediate clk
	signal inter : std_logic;
	

begin
   -------------------------------------------------
	-- create astable clock by dividing clock input
	-------------------------------------------------
	astable: process(clk)
	begin
		if clk'event and clk = '1' then
			q <= q + 1;
		end if;
	end process;
	 
	--------------------------------------------------
	-- create monostable (manual) clock
	--------------------------------------------------
	monostable: process(clk)
	begin
		if clk'event and clk = '1' then
			temp(0) <= notButton;
			temp(1) <= temp(0);
			temp(2) <= temp(1);
			temp(3) <= temp(2);
			temp(4) <= temp(3);
			temp(5) <= temp(4);
			temp(6) <= temp(5);
		end if;
	end process;
	
   mon <= ((((((temp(0) and temp(1)) and temp(2)) and temp(3)) and temp(4)) and temp(5)) and temp(6));
	notButton <= not man_pulse;
	
	---------------------------------------------
	-- instantiate mux to switch between clocks
	---------------------------------------------
	mux21_unit: entity work.mux21a
		port map(
			a => mon,     -- manual clock
         b => q(21),   -- 1.44 Hz clock
         s => sel,
         y => inter
	);
	
	-----------------------------------
	-- output clock process
	-----------------------------------
	output_clock: process(inter, hlt)
	begin
	   -- if halt button not pressed run clock
		if hlt = '0' then
			clk_out <= inter;
		-- else halt clock
		else
			clk_out <= '0';
		end if;
	end process;
 	 
	 
end Behavioral;

