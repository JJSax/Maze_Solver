local cfg = require "settings"
local lt = require "libraries.luatile.tile"

---@class Tile : LTTile
---@field vx number World x coordinate.
---@field vy number World y coordinate.
---@field walls table<number, boolean> The list from top and clockwise if it has a wall
---@field color table The color
local tile = setmetatable({}, {__index = lt})
tile.__index = tile
local boxSize = cfg.boxSize -- includes walls

local lg = love.graphics
local mazeData = love.image.newImageData(cfg.mazeImgPath)

function tile.new(grid, x, y)
	local self = setmetatable(lt.new(grid, x, y), tile)

	-- set relative visual coordinates.
	self.vx = (x - 1) * boxSize
	self.vy = (y - 1) * boxSize

	self.walls = { -- top, right, bottom, left
		mazeData:getPixel(
			self.vx + 3 + 1,
			self.vy + 1
		) ~= 1,
		mazeData:getPixel(
			self.vx + boxSize + 1,
			self.vy + 3 + 1
		) ~= 1,
		mazeData:getPixel(
			self.vx + 3 + 1,
			self.vy + boxSize + 1
		) ~= 1,
		mazeData:getPixel(
			self.vx + 1,
			self.vy + 3 + 1
		) ~= 1
	}

	return self
end

function tile:draw()
	if self.color then
		lg.setColor(self.color)
		lg.rectangle("fill", self.vx, self.vy, boxSize, boxSize)
	end

	lg.setColor(0, 0, 0, 1) -- only lines
	-- Define the four corners of the cell
	local top = {x = self.vx, y = self.vy}
	local right = {x = self.vx + boxSize, y = self.vy}
	local bottom = {x = self.vx + boxSize, y = self.vy + boxSize}
	local left = {x = self.vx, y = self.vy + boxSize}

	local sides = {top, right, bottom, left}

	for i, v in ipairs(sides) do
		if self.walls[i] then
			local n = sides[i + 1]
			if not n then n = sides[1] end
			lg.line(v.x, v.y, n.x, n.y)
		end
	end

end

local dirs = {
	{ 0,-1},
	{ 1, 0},
	{ 0, 1},
	{-1, 0}
}
local function withWall(cur, offset)
	local v = cur.grid:isValidCell(cur.x + dirs[offset][1], cur.y + dirs[offset][2])
	if v and not cur.walls[offset] then
		return v
	end
	return nil
end
function tile:getNeighbors()
	local out = {}
	for i = 1, 4 do
		local c = withWall(self, i)
		if c then table.insert(out, c) end
	end
	return out
end

return tile