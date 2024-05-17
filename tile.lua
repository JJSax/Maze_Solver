
local tile = {}
tile.__index = tile
local boxSize = 8-- includes walls

local lg = love.graphics

-- local mazeImage = lg.newImage("maze.png")
local mazeData = love.image.newImageData("maze.png")

function tile.new(grid, x, y)
	local self = setmetatable({}, tile)

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

return tile