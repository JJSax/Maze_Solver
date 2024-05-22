
local MOVETIMER = 0.3

return {
	-- pathfinder
	MOVETIMER = MOVETIMER,
	DEADENDTIMER = 0.1,
	moveTimer = MOVETIMER,
	timerReset = MOVETIMER,
	hypermode = false,

	-- user
	moveSpeed = 350,
	paused = false,
	mazeImgPath = "mazes/maze.png",

	-- tiles
	boxSize = 16
}