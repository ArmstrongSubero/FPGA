----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:10:27 08/26/2017 
-- Design Name: 
-- Module Name:    rom_8bit - Behavioral 
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

entity rom_8bit is
    Port ( addr : in  STD_LOGIC_VECTOR (3 downto 0);
           M : out  STD_LOGIC_VECTOR (12 downto 0));
end rom_8bit;

architecture Behavioral of rom_8bit is
	constant data0: STD_LOGIC_VECTOR(12 downto 0) := "0000100000001";    -- LDA 1     load 1 to a
	constant data1: STD_LOGIC_VECTOR(12 downto 0) := "0001100000010";    -- ADD 2     add 2 (a = 3)
	constant data2: STD_LOGIC_VECTOR(12 downto 0) := "0010000000001";		-- SUB 1     sub 1 (a = 2)
	constant data3: STD_LOGIC_VECTOR(12 downto 0) := "01101--------";		-- STO 0x00  store output to RAM
   constant data4: STD_LOGIC_VECTOR(12 downto 0) := "01011--------";	 	-- MOV 0x00  load ram location to A 
	constant data5: STD_LOGIC_VECTOR(12 downto 0) := "0001100000001";		-- ADD 1
	constant data6: STD_LOGIC_VECTOR(12 downto 0) := "0100100000000";		-- OUT	 
	constant data7: STD_LOGIC_VECTOR(12 downto 0) := "1000000000101";		-- JMP 5


	type rom_array is array (NATURAL range<>) of STD_LOGIC_VECTOR ( 12 downto 0);
	
	constant rom: rom_array := (
		data0, data1, data2, data3, 
		data4, data5, data6, data7
	);

begin
	process(addr)
	variable j: integer;
	begin
		j := conv_integer(addr);
		M <= rom(j);
	end process;
end Behavioral;

