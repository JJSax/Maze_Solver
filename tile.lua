local cfg = require "settings"
local common = require "common"
local lt = require "libraries.luatile.tile"
local bit = require "bit"

local Walls = require "walls"

---@class Tile : LTTile
---@field vx number World x coordinate.
---@field vy number World y coordinate.
---@field walls integer The list from top and clockwise if it has a wall
local tile = setmetatable({}, {__index = lt})
tile.__index = tile
local boxSize = cfg.boxSize -- includes walls

function tile.new(x, y)
	local mazeData = common.imageData
	local self = setmetatable(lt.new(x, y), tile)

	-- set relative visual coordinates.
	self.vx = (x - 1) * boxSize
	self.vy = (y - 1) * boxSize

	local walls = 0
	local bor = bit.bor

	if mazeData:getPixel(self.vx + 3 + 1, self.vy + 1) ~= 1 then
		walls = bor(walls, Walls.TOP)
	end

	if mazeData:getPixel(self.vx + boxSize + 1, self.vy + 3 + 1) ~= 1 then
		walls = bor(walls, Walls.RIGHT)
	end

	if mazeData:getPixel(self.vx + 3 + 1, self.vy + boxSize + 1) ~= 1 then
		walls = bor(walls, Walls.BOTTOM)
	end

	if mazeData:getPixel(self.vx + 1, self.vy + 3 + 1) ~= 1 then
		walls = bor(walls, Walls.LEFT)
	end

	self.walls = walls

	return self
end

local dirs = common.dirMap
local function withWall(grid, cur, offset)
	local v = grid:isValidCell(cur.x + dirs[offset].x, cur.y + dirs[offset].y)
	if v and not Walls.has(cur.walls, 2^(offset-1)) then
		return v
	end
	return nil
end
---@deprecated Will move to a new Grid variant
function tile:getNeighbors(grid)
	local out = {}
	for i = 1, 4 do
		local c = withWall(grid, self, i)
		if c then table.insert(out, c) end
	end
	return out
end

function tile:setColor(color)
	assert(not (color[1] == 0 and color[2] == 0 and color[3] == 0))

	local img = common.imageData
	local px = (self.x - 1) * boxSize + 1
	local py = (self.y - 1) * boxSize + 1

	for y = 0, boxSize - 1 do
		for x = 0, boxSize - 1 do
			local r, g, b, a = img:getPixel(px + x, py + y)

			-- walls are black, leave them
			if r ~= 0 or g ~= 0 or b ~= 0 then
				img:setPixel(px + x, py + y, color[1], color[2], color[3], a)
			end
		end
	end

	common.refreshImageData = true
end

return tile