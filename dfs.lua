
local cfg = require "settings"
local OGDFS = require "libraries.luatile.dfs"

local JJDFS = setmetatable({}, { __index = OGDFS})
JJDFS.__index = JJDFS

function JJDFS.create(grid, startTile, target)
	return setmetatable(OGDFS.new(grid, startTile, target), JJDFS)
end

function JJDFS:markDeadEnd(tile)
	tile.color = {.2, 0.22, 0.22}
	cfg.timerReset = cfg.DEADENDTIMER
end

function JJDFS:exploreTile(tile)
	tile.color = {0,1,1}
	cfg.timerReset = cfg.MOVETIMER
end

-- function JJDFS:isTarget(tile)
-- 	return tile == self.target
-- end

return JJDFS