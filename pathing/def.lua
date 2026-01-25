--------------------------
---- dead end filling ----
--------------------------

-- local HERE = (...):gsub('%.[^%.]+$', '')
local cfg = require "settings"
local Pathfinder = require "libraries.luatile.pathfinder"

local def = setmetatable({}, { __index = Pathfinder })
def.__index = def
def._VERSION = "0.1.1"


---Create the def
function def.create(grid, startTile, target)
	local self = setmetatable(Pathfinder.new(grid, startTile, target), def)
	return self
end

-- function def:nextPosSearch()
-- 	local x, y = self.currentTile.x, self.currentTile.y
-- 	if x > #self.grid.tiles then
-- 		x = 1
-- 		y = y + 1
-- 	end
-- 	if y > #self.grid.tiles[1] then
-- 		return self.grid(1, 1)
-- 	end

-- 	self.currentTile.x = x + 1
-- 	return self.currentTile
-- end

function def:markDeadEnd(tile)
	tile.deadEnd = true
	tile.color = { .2, 0.22, 0.22 }
	cfg.timerReset = cfg.DEADENDTIMER
end

local dirMap = {
	{x = 0, y = -1},
	{x = 1, y = 0},
	{x = 0, y = 1},
	{x = -1, y = 0}
}

local function constructPath(self)
	local currentTile = self.start
	local path = {self.start}
	local inPath = {[self.start] = true}
	repeat
		for i, isWall in ipairs(currentTile.walls) do
			if not isWall then
				local dir = dirMap[i]
				local nxt = self.grid:isValidCell(currentTile.x + dir.x, currentTile.y + dir.y)
				if nxt and not inPath[nxt] and not self.visited[nxt] then
					table.insert(path, nxt)
					inPath[nxt] = true
					currentTile = nxt
					break
				end
			end
		end
	until currentTile == self.target
	return path
end

---Runs Single step through the def
function def:step()
	local nextMark = {}
	for x, v in ipairs(self.grid.tiles) do
		for y, tile in ipairs(v) do
			if self.visited[tile] then
				goto continue
			end
			local open = 0
			for dir, wall in ipairs(tile.walls) do
				if not wall then
					local isValid = self.grid:isValidCell(x + dirMap[dir].x, y + dirMap[dir].y)
					if not isValid or not self.grid(x + dirMap[dir].x, y + dirMap[dir].y).deadEnd then
						open = open + 1
					end
				end
			end
			if open <= 1 then
				table.insert(nextMark, {x = x, y = y})
			end
		    ::continue::
		end
	end

	for _, v in ipairs(nextMark) do
		local tile = self.grid(v.x, v.y)
		self:markDeadEnd(tile)
		self.visited[tile] = true
	end

	if #nextMark == 0 then
		self.complete = true
		self.path = constructPath(self)
	end
end

function def:step()

end

return def
