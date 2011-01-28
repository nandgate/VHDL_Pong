library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use pongConstants.ALL;

entity Paddle is port (
	clk25: in  STD_LOGIC;
	hcnt: in cnt_t;
	vcnt: in cnt_t;
	leftBtn: in STD_LOGIC;
	rightBtn: in STD_LOGIC;
	paddlePos: inout cnt_t;
	isPaddle: out boolean
);
end paddle;

architecture Behavioral of Paddle is
begin
paddle: process(clk25, vcnt, hcnt, leftBtn, rightBtn, paddlePos)
	impure function moveLeft return boolean is 
	begin
		return leftBtn = '1' and 
				 paddlePos > BORDER_WIDTH;
	end moveLeft;

	impure function moveRight return boolean is
	begin
		return rightBtn = '1' and 
		       paddlePos+PADDLE_WIDTH < H_PIXELS-BORDER_WIDTH-1;
	end moveRight;

begin
	if rising_edge(clk25) and (vcnt = 0) and (hcnt = 0)then
		if moveLeft then
			paddlePos <= paddlePos - PADDLE_SPEED;
		elsif moveRight then
			paddlePos <= paddlePos + PADDLE_SPEED;
		end if;
	end if;
end process;

drawPaddle: process(hcnt, vcnt, paddlePos)
begin
	isPaddle <= vcnt >= PADDLE_Y_BEGIN and				-- top
					vcnt <= PADDLE_Y_END and				-- bottom
					hcnt >= paddlePos and   				-- left
					hcnt <= paddlePos + PADDLE_WIDTH;	-- right
end process;
end Behavioral;

