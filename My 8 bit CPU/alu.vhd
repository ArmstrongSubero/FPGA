----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:01 08/22/2017 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
	 generic (N : integer := 8);
    Port ( in_a : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in_b : in  STD_LOGIC_VECTOR (N-1 downto 0);
           result : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  alu_enable : in STD_LOGIC;
           sel : in  STD_LOGIC_VECTOR(3 downto 0));
end alu;

architecture Behavioral of alu is

begin
	process(in_a, in_b, alu_enable, sel)
	
	variable output: STD_LOGIC_VECTOR(N-1 downto 0);
	
	begin
	   -- if enable is 0 set bits to unimplemented
		if alu_enable = '0' then
			result <= (others => 'Z');
		else
			case sel is
				when "0000" =>				-- pass a
					output := in_a;
				when "0001" =>				-- a + b
					output := in_a + in_b;
				when "0010" =>				-- a - b
					output := in_a - in_b;
				when "0011" =>				-- b - a
					output := in_b - in_a;
				when "0100" =>				-- NOT
					output := not in_a;
				when "0101" =>				-- AND
					output := in_a and in_b;
				when "0110" =>				-- OR
					output := in_a or in_b;
				when "0111" =>				-- XOR
					output := in_a xor in_b;
				when "1000" =>				-- MUL
					output := in_a * in_b;
				when others =>
					output := in_a;
		end case;
	end if;
	
	
	result <= output;

	end process;
			
end Behavioral;

