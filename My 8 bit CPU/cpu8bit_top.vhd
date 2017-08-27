----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:40:37 08/22/2017 
-- Design Name: 
-- Module Name:    cpu8bit_top - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu8bit_top is
    Generic (
		DATA_WIDTH		: integer := 8;
		ADDRESS_WIDTH	: integer := 4
	  );
	 Port ( clk : in  STD_LOGIC;
			  sseg : out STD_LOGIC_VECTOR(7 downto 0);
			  an : out STD_LOGIC_VECTOR(3 downto 0);
			  led : out STD_LOGIC_VECTOR(7 downto 0)
			 );
end cpu8bit_top;

architecture Behavioral of cpu8bit_top is
	
	--------------------------------------------------
	--------------------------------------------------
	-- Clock Signals
	--------------------------------------------------
	--------------------------------------------------
	signal MAN_STEP : std_logic;
	signal CLK_SEL  : std_logic := '1';
	signal CLK_HLT  : std_logic;
	signal SLOW_CLK : std_logic;  
	
	--------------------------------------------------
	--------------------------------------------------
	-- A register signals
	--------------------------------------------------
	--------------------------------------------------
	signal AREG_IN     : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal AREG_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal A_CLR       : std_logic := '0';
	signal A_IN        : std_logic;
   signal A_OUT 		 : std_logic;
	
	--------------------------------------------------
	--------------------------------------------------
	-- B register signals
	--------------------------------------------------
	--------------------------------------------------
	signal BREG_IN     : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal BREG_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal B_CLR       : std_logic := '0';
	signal B_IN			 : std_logic;
	signal B_OUT       : std_logic;
	
	--------------------------------------------------
	-- C register signals
	--------------------------------------------------
	--------------------------------------------------
	signal CREG_IN     : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal CREG_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal C_CLR       : std_logic := '0';
	signal C_IN			 : std_logic;
	signal C_OUT       : std_logic;
	--------------------------------------------------
	--------------------------------------------------
	-- Output register signals
	--------------------------------------------------
	--------------------------------------------------
	signal OREG_IN     : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal OREG_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal O_CLR       : std_logic := '0';
	signal O_IN			 : std_logic;
	signal O_OUT       : std_logic;
	
	---------------------------------------------------
   ---------------------------------------------------
	-- IR signals
	---------------------------------------------------
	---------------------------------------------------
   signal INSREG_IN  : std_logic_vector(12 downto 0);
	signal INSREG_OUT : std_logic_vector(12 downto 0); 
	signal IR_CLR     : std_logic := '0';
	signal IR_IN      : std_logic;
	signal IR_OUT     : std_logic;
	
	---------------------------------------------------
	---------------------------------------------------
	-- ALU signals
	---------------------------------------------------
	---------------------------------------------------
	signal ALU_OUTPUT  : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal ALU_ENABLE  : std_logic;
	signal ALU_OP      : std_logic_vector (3 downto 0);
	
	---------------------------------------------------
	---------------------------------------------------
	-- RAM signals
   ---------------------------------------------------
	---------------------------------------------------
	signal RAM_RST : std_logic;
	signal MAR_IN  : std_logic_vector (ADDRESS_WIDTH-1 downto 0);
	signal RAM_IN  : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal RAM_OUT : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal RAM_RD  : std_logic;
	signal RAM_WR  : std_logic;
	signal RAM_EN  : std_logic;
	
	---------------------------------------------------
	---------------------------------------------------
	-- PC signals
	---------------------------------------------------
	---------------------------------------------------
	signal PC_RST  : std_logic;
	signal PC_CLR  : std_logic;
	signal JMP_EN  : std_logic;
	signal PC_EN   : std_logic := '1';
	signal PC_SP   : std_logic := '1';
	signal JUMP    : std_logic_vector (ADDRESS_WIDTH-1 downto 0);
	signal PC_OUT  : std_logic_VECTOR (ADDRESS_WIDTH-1 downto 0);
	
	---------------------------------------------------
	---------------------------------------------------
	-- SSEG unit
	---------------------------------------------------
	---------------------------------------------------
   signal SSEG_RST: std_logic;
   signal DIG3, DIG2, DIG1, DIG0: std_logic_vector(3 downto 0);
   signal SSEG_DP: std_logic_vector(3 downto 0);
	signal SSEG_OUTPUT : std_logic_vector(7 downto 0);
	
	signal gen : STD_LOGIC_VECTOR(7 downto 0);
	
	
	--------------------------------------------------
	--------------------------------------------------
	-- ROM signals
	--------------------------------------------------
	--------------------------------------------------
	signal ROM_ADDR : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
	signal ROM_OUT  : std_logic_vector(12 downto 0);
	
	--------------------------------------------------
	--------------------------------------------------
	-- Disp MUX signals
	--------------------------------------------

begin
	 --------------------------------------
	 --------------------------------------
	 -- Clock
	 --------------------------------------
	 --------------------------------------
    clock_unit : entity work.cpu_clock
	 port map( 
	      clk       => clk,
			man_pulse => MAN_STEP,
			sel       => CLK_SEL,
         hlt       => CLK_HLT,
         clk_out   => SLOW_CLK
		);

	 --------------------------------------
	 --------------------------------------
	 -- Registers
	 --------------------------------------
	 --------------------------------------
	 
	 --------------------------------------
	 -- Register A
	 --------------------------------------
	 registera : entity work.register_gen
	 port map(
			   input        => AREG_IN,
			   output       => AREG_OUT,
		      register_clk => SLOW_CLK,
			   clr          => A_CLR,
			   load         => A_IN,
			   enable       => A_OUT
		);
		
	 --------------------------------------
	 -- Register B
	 --------------------------------------
	 registerb : entity work.register_gen
	 port map(
			input        => BREG_IN,
			output       => BREG_OUT,
		   register_clk => SLOW_CLK,
			clr          => B_CLR,
			load         => B_IN,
			enable       => B_OUT
	);
	
	 --------------------------------------
	 -- Register C
	 --------------------------------------
	 registerc : entity work.register_gen
	 port map(
			input        => CREG_IN,
			output       => CREG_OUT,
		   register_clk => SLOW_CLK,
			clr          => C_CLR,
			load         => C_IN,
			enable       => C_OUT
	);
	
	---------------------------------------
	-- Output Register
	---------------------------------------
	registero : entity work.register_gen
	port map(
		  input         => OREG_IN,
			output       => OREG_OUT,
		   register_clk => SLOW_CLK,
			clr          => O_CLR,
			load         => O_IN,
			enable       => O_OUT
	);
	
	---------------------------------------
	-- Instruction Register
	---------------------------------------
	ir_unit : entity work.ir_reg
	port map(
		  input        => INSREG_IN,
		  output       => INSREG_OUT,
		  register_clk => SLOW_CLK,
		  clr          => IR_CLR,
		  load         => IR_IN,
		  enable       => IR_OUT
	);
	
	----------------------------------------
	----------------------------------------
	-- Arithmetic and Logic Unit
	----------------------------------------
	----------------------------------------
	alu_unit : entity work.alu
	port map(
		  in_a       => AREG_OUT,
	     in_b       => BREG_OUT,
		  result     => ALU_OUTPUT,
		  alu_enable => ALU_ENABLE,
		  sel        => ALU_OP
	);
	
	----------------------------------------
	----------------------------------------
	-- Random Access Memory Unit
	----------------------------------------
	----------------------------------------
	ram_unit : entity work.ram16_8
	port map(
		  ram_clk   => SLOW_CLK,
        Reset     => RAM_RST,
	     DataIn    => RAM_IN,
	     Address   => MAR_IN,
	     WriteEn   => RAM_WR,
	     Enable    => RAM_EN,
	     DataOut   => RAM_OUT
	);
	
	
	------------------------------------------
	------------------------------------------
	-- Program Counter Unit
	------------------------------------------
	------------------------------------------
	program_counter_unit : entity work.program_counter
	port map(
		     clk     => SLOW_CLK,
			  reset   => PC_RST,
           syn_clr => PC_CLR,
			  load    => JMP_EN,
			  en      => PC_EN,
			  up      => PC_SP,
           d       => JUMP,
           q       => PC_OUT
	);
	
	
	--------------------------------------------
	--------------------------------------------
	-- Seven Segment Unit
	--------------------------------------------
	--------------------------------------------
	seven_seg_unit: entity work.disp_hex_mux
	port map(
			clk   => clk,
			reset => SSEG_RST,
			hex3  => DIG3,
			hex2  => DIG2,
			hex1  => DIG1,
			hex0  => DIG0,
			dp_in => SSEG_DP,
			an    => an,
         sseg  => sseg
   );
	
	
	---------------------------------------------
	---------------------------------------------
	-- ROM Unit
	---------------------------------------------
	---------------------------------------------
	rom_unit : entity work.rom_8bit
	port map(
	     addr => ROM_ADDR,
		  M => ROM_OUT
	);
	
	
	---------------------------------------------------
	---------------------------------------------------
	---------------------------------------------------
	-- CPU Control Unit
	---------------------------------------------------
	---------------------------------------------------
	---------------------------------------------------
	-- display contents of output register
	led  <= OREG_OUT;
	DIG0 <= OREG_OUT;	

	
	process (SLOW_CLK, AREG_IN, A_IN, gen, INSREG_IN, MAR_IN)
	
	begin
		if SLOW_CLK'event and SLOW_CLK = '1' then
				-- set memory address to program counter
				ROM_ADDR <= PC_OUT;
				
				-- read data at memory address and put it in IR
				INSREG_IN <= ROM_OUT;
				IR_IN  <= '1';
				IR_OUT <= '1';
				
			
				OREG_IN <= ALU_OUTPUT;					 		-- put ALU data into OREG
					
				-- 1
				-- No Operation instruction	         NOP
				if INSREG_OUT(12 downto 8) =    "00000" then	-- do nothing
				
				-- 2
				-- load A instruction	               LDA
				elsif INSREG_OUT(12 downto 8) = "00001" then
					O_CLR <= '0';
					AREG_IN <= INSREG_OUT(7 downto 0);        -- put lower bits into A register
					A_IN  <= '1';                             -- load it into A register
					A_OUT <= '1';                             -- output it to bus
				
				-- 3
				-- load C instruction				      LDC
				elsif INSREG_OUT(12 downto 8) = "00010" then
					CREG_IN <= INSREG_OUT(7 downto 0);        -- put lower bits into A register
					C_IN  <= '1';                             -- load it into A register
					C_OUT <= '1';                             -- output it to bus
			
				-- 4
				-- add instruction		              	ADD
				elsif INSREG_OUT(12 downto 8) = "00011" then
					O_CLR <= '0';								
					ALU_ENABLE <= '1';
					A_OUT <= '1';
					ALU_OP <= "0001";							      -- set ALU add
					BREG_IN <= INSREG_OUT(7 downto 0);	      -- put lower bits in B register
					B_IN <= '1';                              -- load it into B register
					B_OUT <= '1';                             -- output it to BUS
				
				-- 5
				-- subtract instruction					   SUB
				elsif INSREG_OUT(12 downto 8) = "00100" then
					O_CLR <= '0';								
					ALU_ENABLE <= '1';
					A_OUT <= '1';
					ALU_OP <= "0010";							      -- set ALU subtract
					BREG_IN <= INSREG_OUT(7 downto 0);	      -- put lower bits in B register
					B_IN <= '1';                              -- load it into B register
					B_OUT <= '1';                             -- output it to BUS
				
				-- 6
				-- NOT instruction					      NOT
				elsif INSREG_OUT(12 downto 8) = "00101" then
					ALU_OP <= "0100";							      -- set ALU NOT
					AREG_IN <= INSREG_OUT(7 downto 0);	      -- put lower bits in A register
					A_IN <= '1';                              -- load it into A register
					A_OUT <= '1';                             -- output it to BUS
					B_OUT <= '0';								      -- turn off B register
					
				-- 7
				-- AND instruction					      AND
				elsif INSREG_OUT(12 downto 8) = "00110" then
					ALU_OP <= "0101";							      -- set ALU AND
					BREG_IN <= INSREG_OUT(7 downto 0);	      -- put lower bits in B register
					B_IN <= '1';                              -- load it into B register
					B_OUT <= '1';                             -- output it to BUS
				
				--8
				-- OR instruction					         OR
				elsif INSREG_OUT(12 downto 8) = "00111" then
					ALU_OP <= "0110";							  		-- set ALU OR
					BREG_IN <= INSREG_OUT(7 downto 0);	  		-- put lower bits in B register
					B_IN <= '1';                          		-- load it into B register
					B_OUT <= '1';                         		-- output it to BUS
				
				-- 9
				-- XOR instruction					      XOR
				elsif INSREG_OUT(12 downto 8) = "01000" then
					ALU_OP <= "0111";							  		-- set ALU XOR
					BREG_IN <= INSREG_OUT(7 downto 0);	  		-- put lower bits in B register
					B_IN <= '1';                          		-- load it into B register
					B_OUT <= '1';                         		-- output it to BUS
				
				-- 10
				-- output instruction	               OUT
				elsif INSREG_OUT(12 downto 8) = "01001" then
					O_CLR <= '1';
					O_IN <= '1';								 		-- load into OREG
					O_OUT <= '1';								 		-- output it to bus
				
				
				-- 11
				-- store A to ram			               STA
				elsif INSREG_OUT(12 downto 8) = "01010" then
					RAM_EN <= '1';								 		-- enable RAM
				   RAM_WR <= '1';								 		-- enable write to RAM
					MAR_IN <= INSREG_OUT(7 downto 4);	 		-- set RAM memory address to location specified
					RAM_IN <= AREG_OUT;					    		-- store data at memory address	
				
				-- 12
				-- load RAM address to A               MOV
				elsif INSREG_OUT(12 downto 8) = "01011" then
					O_OUT  <= '0';
					RAM_EN <= '1';								 		-- enable RAM
					RAM_WR <= '0';								 		-- enable read from RAM
					MAR_IN <= INSREG_OUT(7 downto 4);	 		-- set RAM memory address to location specified
					AREG_IN <= RAM_OUT;					    		-- read data at memory address to AREG
				
				-- 13
				-- move C to A			                  MCA
				elsif INSREG_OUT(12 downto 8) = "01100" then
					C_OUT <= '1';								 		-- set C output
					AREG_IN <= CREG_OUT;					    		-- copy C to A
		
				-- 14
				-- store Output to ram			         STO
				elsif INSREG_OUT(12 downto 8) = "01101" then
					ALU_ENABLE <= '1';						 		-- put ALU data on BUS
					OREG_IN <= ALU_OUTPUT;					 		-- put ALU data into OREG
					O_IN <= '1';								 		-- load into OREG
					O_OUT <= '1';								 		-- output it to bus
					
					RAM_EN <= '1';								 		-- enable RAM
				   RAM_WR <= '1';								 		-- enable write to RAM
					MAR_IN <= INSREG_OUT(3 downto 0);	 		-- set RAM memory address to location specified
					RAM_IN <= OREG_OUT;					    		-- store data at memory address	
				
				-- 15
				-- store C to ram			               STC
				elsif INSREG_OUT(12 downto 8) = "01110" then
					RAM_EN <= '1';								 		-- enable RAM
				   RAM_WR <= '1';								 		-- enable write to RAM
					MAR_IN <= INSREG_OUT(7 downto 4);	 		-- set RAM memory address to location specified
					RAM_IN <= CREG_OUT;					    		-- store data at memory address	
			
				-- 16
				-- JUMP to Address		               JMP
				elsif INSREG_OUT(12 downto 8) = "10000" then
					JMP_EN <= '1';										-- JUMP enable
					JUMP   <= INSREG_OUT(3 downto 0);			-- Load Jump Location
					JMP_EN <= '0';
					PC_EN <= '1';

				-- 17
				-- clear A		              				CLA
				elsif INSREG_OUT(12 downto 8) = "10001" then
					O_OUT <='0';
					AREG_IN <= (others => '0');         		-- set AREG input to 0 
					A_IN  <= '1';                       		-- load it into A register
					A_OUT <= '1';                       		-- output it to bus
				
				-- 18
				-- clear C		              				 CLC
				elsif INSREG_OUT(12 downto 8) = "10000" then
					CREG_IN <= (others => '0');         		-- set CREG input to 0 
					C_IN  <= '1';                       		-- load it into C register
					C_OUT <= '1';                       		-- output it to bus
					
				-- 19
				-- multiply instruction					    MUL
				elsif INSREG_OUT(12 downto 8) = "10010" then
					ALU_OP <= "0010";							      -- set ALU subtract
					BREG_IN <= INSREG_OUT(7 downto 0);	      -- put lower bits in B register
					B_IN <= '1';                              -- load it into B register
					B_OUT <= '1';                             -- output it to BUS
				
				-- 20
				-- Halt			              				 HLT
				elsif INSREG_OUT(12 downto 8) = "11111" then
				
				end if;
			
	end if;
end process;
	
	
end Behavioral;

