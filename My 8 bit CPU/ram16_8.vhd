----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:07:44 08/22/2017 
-- Design Name: 
-- Module Name:    ram16_8 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: Copied from ram code provided on Death By Logic Blog, thank you!
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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
entity ram16_8 is
	Generic (
		DATA_WIDTH		: integer := 8;
		ADDRESS_WIDTH	: integer := 4
	);
	Port ( 
		ram_clk : in  STD_LOGIC;
      Reset 	: in  STD_LOGIC;
		DataIn 	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		Address	: in  STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
		WriteEn	: in  STD_LOGIC;
		Enable 	: in  STD_LOGIC;
		DataOut 	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
	);
end ram16_8;
 
architecture Behavioral of ram16_8 is
	type Memory_Array is array ((2 ** ADDRESS_WIDTH) - 1 downto 0) of STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0); 
	signal Memory : Memory_Array;
begin
 
	-- Read process
	process (ram_clk)
	begin
		if rising_edge(ram_clk) then
			if Reset = '1' then
				-- Clear DataOut on Reset
				DataOut <= (others => '0');
			elsif Enable = '1' then
				if WriteEn = '0' then
					-- If WriteEn then pass through DIn
					DataOut <= DataIn;
				else
					-- Otherwise Read Memory
					DataOut <= Memory(to_integer(unsigned(Address)));
				end if;
			end if;
		end if;
	end process;
 
	-- Write process
	process (ram_clk)
	begin
		if rising_edge(ram_clk) then
			if Reset = '1' then
				-- Clear Memory on Reset
				for i in Memory'Range loop
					Memory(i) <= (others => '0');
				end loop;
			elsif Enable = '1' then
				if WriteEn = '1' then
					-- Store DataIn to Current Memory Address
					Memory(to_integer(unsigned(Address))) <= DataIn;
				end if;
			end if;
		end if;
	end process;
end Behavioral;