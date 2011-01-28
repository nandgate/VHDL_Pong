library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use pongConstants.ALL;

entity VGA is port (
	clk25: in  STD_LOGIC;
	hcnt: inout cnt_t;
	vcnt: inout cnt_t;
   hSync: out	STD_LOGIC;
   vSync: out STD_LOGIC;
	blanking: out boolean
);
end VGA;

architecture Behavioral of VGA is
begin

genSync: process(clk25,hcnt,vcnt)
begin
	-- Advance the horizontal 
	if rising_edge(clk25) then
		if hcnt < H_TOTAL then
			hcnt <= hcnt + 1;
		else
			hcnt <= 0;
		end if;
	end if;
	
	-- Generate the HSYNC pulse
	if hcnt < H_SYNC_BEGIN theN
		-- Pixels and front porch
		hSync <= '1';
	elsif hcnt < H_SYNC_END then
		-- HSYNC pulse
		hSync <= '0';
	else
		-- Back porch
		hSync <= '1';
	end if;

	-- Advance the vertical
	if rising_edge(clk25) and hcnt = 0 then
		if vcnt < V_TOTAL then 
			vcnt <= vcnt + 1;
		else
			vcnt <= 0;
		end if;
	end if;
	
	-- Generate the VSYNC pulse
	if vcnt < V_SYNC_BEGIN then
		-- Lines and front porch
		vSync <= '1';
	elsif vcnt < V_SYNC_END then
		-- VSYNC pulse
		vSync <= '0';
	else
		-- Back porch
		vSync <= '1';
	end if;
	
	-- Generate blanking
	blanking <= (vcnt >= V_LINES) or (hcnt >= H_PIXELS);
end process;
end Behavioral;