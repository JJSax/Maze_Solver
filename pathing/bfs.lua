
local cfg = require "settings"
local OGDFS = require "libraries.luatile.bfs"

local JJBFS = setmetatable({}, { __index = OGDFS})
JJBFS.__index = JJBFS

function JJBFS.create(grid, startTile, target)
	return setmetatable(OGDFS.new(grid, startTile, target), JJBFS)
end

function JJBFS:exploreTile(tile)
	tile:setColor({0,1,1})
	cfg.timerReset = cfg.MOVETIMER
end

function JJBFS:markDeadEnd(tile)
	tile:setColor({.2, 0.22, 0.22})
	cfg.timerReset = cfg.DEADENDTIMER
end

return JJBFS