library IEEE;
use IEEE.STD_LOGIC_1164.all;

package pongConstants is
subtype cnt_t is integer range 0 to 1023;

-- 640 x 480 @ 60hz screen, pixel frequency: 25.175MHz
-- Timing specs can be found at: http://tinyvga.com/vga-timing/640x480@60Hz/
-- Note we have a 25MHz clock on the dev board, therefore
-- the timing of all signals will be 0.7% off.
constant H_PIXELS: integer := 640;
constant H_SYNC_BEGIN: integer := H_PIXELS + 16;
constant H_SYNC_END: integer := H_SYNC_BEGIN + 96;
constant H_TOTAL: integer := H_SYNC_END + 48;

constant V_LINES: integer := 480;
constant V_SYNC_BEGIN: integer := V_LINES + 10;
constant V_SYNC_END: integer := V_SYNC_BEGIN + 2;
constant V_TOTAL: integer := V_SYNC_END + 33;
  
constant BORDER_WIDTH: integer := 10;
constant PADDLE_WIDTH: integer := 64;
constant PADDLE_Y_BEGIN: integer := V_LINES-80;	
constant PADDLE_Y_END: integer := V_LINES-76;
constant PADDLE_SPEED: integer := 2;

constant GOAL_Y_BEGIN: integer := V_LINES-60;
constant GOAL_Y_END: integer := V_LINES-58;

constant BALL_WIDTH: integer := 8;
constant BALL_HEIGHT: integer := 8;

end pongConstants;
