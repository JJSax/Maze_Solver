
local OGDFS = require "libraries.luatile.dfs"

local JJDFS = setmetatable({}, { __index = OGDFS})
JJDFS.__index = JJDFS

function JJDFS.create(grid, startTile)
	return setmetatable(OGDFS.new(grid, startTile), JJDFS)
end

function JJDFS:markDeadEnd(tile)
	tile.color = {.3, 0.12, 0.12}
end

function JJDFS:exploreTile(tile)
	tile.color = {0,1,1}
end

return JJDFS