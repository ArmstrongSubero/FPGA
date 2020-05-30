----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:24:48 08/22/2017 
-- Design Name: 
-- Module Name:    program_counter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity program_counter is
	 generic(N: integer := 4);
    Port ( clk, reset : in  STD_LOGIC;
           syn_clr, load, en, up : in  STD_LOGIC;
           d : in  STD_LOGIC_VECTOR (N-1 downto 0);
           max_tick, min_tick : out  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR (N-1 downto 0));
end program_counter;

architecture Behavioral of program_counter is
	signal r_reg: unsigned(N-1 downto 0);
	signal r_next: unsigned(N-1 downto 0);

begin
	--register
	process(clk, reset)
	begin
		if(reset='1') then
			r_reg <= (others=>'0');
		elsif (clk'event and clk = '1') then
			r_reg <= r_next;
		end if;
	end process;
	
	-- next state logic
	r_next <= (others => '0') when syn_clr = '1' else
		unsigned(d) when load = '1' else
		r_reg + 1 when en = '1' and up='1' else
		r_reg - 1 when en = '1' and up='0' else
		r_reg;
	
	-- output logic
	q <= std_logic_vector(r_reg);

	
end Behavioral;
	