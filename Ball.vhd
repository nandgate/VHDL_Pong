library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use pongConstants.ALL;

entity Ball is port (
	clk25: in  STD_LOGIC;
	hcnt: in cnt_t;
	vcnt: in cnt_t;
	paddlePos: in cnt_t;
	isBall: out boolean);
end Ball;	

architecture Behavioral of Ball is
signal xBall: cnt_t;
signal yBall: cnt_t;
signal xBallDir: bit;
signal yBallDir: bit;

begin
ball: process(clk25, vcnt, hcnt, paddlePos)
	impure function hitLeftBorder return boolean is
	begin
		return xBall <= BORDER_WIDTH;
	end hitLeftBorder;

	impure function hitRightBorder return boolean is
	begin
		return xBall + BALL_WIDTH >= H_PIXELS-BORDER_WIDTH-1;
	end hitRightBorder;

	impure function hitTopBorder return boolean is
	begin
		return yBall <= BORDER_WIDTH;
	end hitTopBorder;

	impure function hitPaddle return boolean is
	begin
		return xBall+BALL_WIDTH >= paddlePos and
				 xBall <= paddlePos+PADDLE_WIDTH and
				 yBall+BALL_HEIGHT >= PADDLE_Y_BEGIN and
				 yball < PADDLE_Y_BEGIN;
	end hitPaddle;
	
begin
	if rising_edge(clk25) and (vcnt = 0) and (hcnt = 0)then
		if hitLeftBorder then
			xBallDir <= '1';
			xBall <= BORDER_WIDTH + 1;
		elsif hitRightBorder then
			xBallDir <= '0';
			xBall <= H_PIXELS-BORDER_WIDTH-BALL_WIDTH - 2;
		else
			if xBallDir = '1' then
				xBall <= xBall + 1;
			else
				xBall <= xBall - 1;
			end if;
		end if;
		
		if hitTopBorder then
			yBallDir <= '1';
			yBall <= BORDER_WIDTH + 1;
		elsif hitPaddle then
			yBallDir <= not yBallDir;
			yBall <= PADDLE_Y_BEGIN - BALL_HEIGHT - 1;			
		else
			if yBall < V_LINES then
				if yBallDir = '1' then
					yBall <= yBall + 1;
				else 
					yBall <= yBall - 1;
				end if;
			else 
				yBall <= 20;
			end if;
		end if;
	end if;
end process;

isBall <=	vcnt >= yBall and						-- top
				vcnt <= yBall + BALL_HEIGHT and	-- bottom
				hcnt >= xBall and   					-- left
				hcnt <= xBall + BALL_WIDTH;		-- right
end Behavioral;

