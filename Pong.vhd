library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use pongConstants.ALL;

entity Pong is port(
	clk50: in  STD_LOGIC;
	leftBtn: in STD_LOGIC;
	rightBtn: in STD_LOGIC;
   vgaHS: out  STD_LOGIC;
   vgaVS: out  STD_LOGIC;
   vgaR: out  STD_LOGIC;
   vgaG: out  STD_LOGIC;
   vgaB: out  STD_LOGIC);
end Pong;

architecture Behavioral of Pong is
	component VGA port (
		clk25 : in  STD_LOGIC;
		hcnt : inout cnt_t;
		vcnt : inout cnt_t;
      hSync : out	STD_LOGIC;
      vSync : out STD_LOGIC;
		blanking: out boolean
	);
	end component;	

	component paddle port (
		clk25: in  STD_LOGIC;
		hcnt: in cnt_t;
		vcnt: in cnt_t;
		leftBtn: in STD_LOGIC;
		rightBtn: in STD_LOGIC;
		paddlePos: inout cnt_t;
		isPaddle: out boolean
	);
	end component;

	component ball port (
		clk25: in  STD_LOGIC;
		hcnt: in cnt_t;
		vcnt: in cnt_t;
		paddlePos: in cnt_t;
		isBall: out boolean
	);
	end component;
	
	signal clk25: STD_LOGIC;
	signal hcnt: cnt_t;
	signal vcnt: cnt_t;
	signal blanking: boolean;
	signal paddlePos: cnt_t;
	signal isPaddle: boolean;
	signal isBall: boolean;

begin
	video: VGA port map (clk25, hcnt, vcnt, vgaHS, vgaVS, blanking);
	user: Paddle port map (clk25, hcnt, vcnt, leftBtn, rightBtn, paddlePos, isPaddle);
	orb: Ball port map (clk25, hcnt, vcnt, paddlePos, isBall);
	
	genClk25: process(clk50)
	begin
		if rising_edge(clk50) then
			clk25 <= not clk25;
		end if;
	end process;

	render: process(blanking, isPaddle, isBall)
		impure function isBorder return boolean is
		begin
			return vcnt < BORDER_WIDTH or						-- top border
					 hcnt < BORDER_WIDTH or   					-- left border
					 hcnt > H_PIXELS - BORDER_WIDTH - 1;	-- right border 
		end isBorder;

		impure function isGoalLine return boolean is
		begin
			return vcnt >= GOAL_Y_BEGIN and
					 vcnt <= GOAL_Y_END and
					 hcnt mod 4 /= 0;
		end isGoalLine;
		
	begin
		if blanking then
			vgaR <= '0';
			vgaG <= '0';
			vgaB <= '0';
		elsif isBorder then
			vgaR <= '1';
			vgaG <= '1';
			vgaB <= '1';		
		elsif isPaddle then
			vgaR <= '0';
			vgaG <= '1';
			vgaB <= '1';
		elsif isBall then
			vgaR <= '1';
			vgaG <= '0';
			vgaB <= '0';
		elsif isGoalLine then
			vgaR <= '0';
			vgaG <= '1';
			vgaB <= '0';
		else
			vgaR <= '0';
			vgaG <= '0';
			vgaB <= '0';
		end if;
	end process;
end Behavioral;

