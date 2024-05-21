
local cfg = require "settings"
local OGDFS = require "libraries.luatile.bfs"

local JJBFS = setmetatable({}, { __index = OGDFS})
JJBFS.__index = JJBFS

function JJBFS.create(grid, startTile, target)
	return setmetatable(OGDFS.new(grid, startTile, target), JJBFS)
end

function JJBFS:exploreTile(tile)
	tile.color = {0,1,1}
	cfg.timerReset = cfg.MOVETIMER
end

return JJBFS