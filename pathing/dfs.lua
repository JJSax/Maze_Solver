
local OGDFS = require "libraries.luatile.dfs"
local cfg = require "settings"

local JJDFS = setmetatable({}, { __index = OGDFS})
JJDFS.__index = JJDFS

function JJDFS.create(grid, startTile, target)
	return setmetatable(OGDFS.new(grid, startTile, target), JJDFS)
end

function JJDFS:markDeadEnd(tile)
	tile:setColor({ .2, 0.22, 0.22 })
	cfg.timerReset = cfg.DEADENDTIMER
end

function JJDFS:exploreTile(tile)
	cfg.timerReset = cfg.MOVETIMER
	tile:setColor({ 0, 1, 1 })
end

return JJDFS