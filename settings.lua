
local MOVETIMER = 0.3

return {
	-- pathfinder
	MOVETIMER = MOVETIMER,
	DEADENDTIMER = 0.1,
	moveTimer = MOVETIMER,
	timerReset = MOVETIMER,
	hypermode = false,
	pathfinder = "dfs",

	-- user
	moveSpeed = 350,
	paused = false,
	mazeImgPath = "mazes/maze.png",
	-- mazeImgPath = "mazes/maze40.png",
	-- mazeImgPath = "mazes/10-10maze.png",
	stepsPerFrame = 1,

	-- tiles
	boxSize = 16
}