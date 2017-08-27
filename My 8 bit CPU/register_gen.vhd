----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:44 08/22/2017 
-- Design Name: 
-- Module Name:    register - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_gen is
	 generic (N : integer := 8);
    Port ( input : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output : out  STD_LOGIC_VECTOR (N-1 downto 0);
           register_clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           load : in  STD_LOGIC;
           enable : in  STD_LOGIC);
end register_gen;

architecture Behavioral of register_gen is
		signal tmp : std_logic_vector(N-1 downto 0);

begin
	process(register_clk, clr, input, enable, tmp)
	begin
	   -- if clear enabled clear register
		if clr = '1' then
			tmp <= (others => '0');
			
		-- else store input to temporary variable
		elsif register_clk'event and register_clk = '1' then
			if load = '1' then
				tmp <= input;
			end if;
		end if;
		
		-- if not enabled set output as unimplemented
		if enable = '0' then
			output <= (others => 'Z');
			
		-- else output data to bus
		else
			output <= tmp;
		end if;
	end process;
end Behavioral;

