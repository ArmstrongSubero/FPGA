----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Armstrong Subero
-- 
-- Create Date:    02:30:47 05/30/2020 
-- Design Name: 
-- Module Name:    led_switch - Behavioral 
-- Project Name: 
-- Target Devices: XC3S50A
-- Tool versions:  ISE 14.7
-- Description:    Uses the Elbert V2 Hardware, turns on the
--                 LEDs on the board using pushbuttons
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_switch is
    Port ( Switch_One : in  STD_LOGIC;
           Switch_Two : in  STD_LOGIC;
           LED_One : out  STD_LOGIC;
           LED_Two : out  STD_LOGIC);
end led_switch;

architecture Behavioral of led_switch is

begin
  -- Assign LED one to switch one
  LED_One <= NOT Switch_One;
  
  -- Assign LED two to swtich two
  LED_Two <= NOT Switch_Two;

end Behavioral;

