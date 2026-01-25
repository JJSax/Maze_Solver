--------------------------
---- dead end filling ----
--------------------------

-- local HERE = (...):gsub('%.[^%.]+$', '')
local cfg = require "settings"
local Pathfinder = require "libraries.luatile.pathfinder"

local def = setmetatable({}, { __index = Pathfinder })
def.__index = def
def._VERSION = "0.2.0"

local dirMap = {
	{ x = 0,  y = -1 },
	{ x = 1,  y = 0 },
	{ x = 0,  y = 1 },
	{ x = -1, y = 0 }
}

---Create the def
function def.create(grid, startTile, target)
	local self = setmetatable(Pathfinder.new(grid, startTile, target), def)

	local singlePaths = {}
	for x, v in ipairs(self.grid.tiles) do
		for y, tile in ipairs(v) do
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
				table.insert(singlePaths, tile)
			end
		end
	end

	self.list = singlePaths
	return self
end

function def:markDeadEnd(tile)
	tile.deadEnd = true
	tile.color = { .2, 0.22, 0.22 }
end

function def:exploreTile(tile)
	tile.color = { 0, 1, 1 }
	cfg.timerReset = cfg.MOVETIMER
end

local function constructPath(self)
	local currentTile = self.start
	local path = {self.start}
	local inPath = {[self.start] = true}
	repeat
		for i, tile in ipairs(currentTile:getNeighbors()) do
			if not inPath[tile] and not tile.deadEnd then
				currentTile = tile
				table.insert(path, currentTile)
				inPath[tile] = true
				self:exploreTile(tile)
				break
			end
		end
	until currentTile == self.target
	self.complete = true
	self.path = path
	return path
end

function def:step()
	local nList = {}
	for i, tile in ipairs(self.list) do
		-- mark current tile as dead end
		if tile ~= self.start and tile ~= self.target then
			self:markDeadEnd(tile)
		end

		-- look at adjacent tiles for tiles that will have 0 ways to go after this tile is marked as a dead end
		for _, adjTile in ipairs(tile:getNeighbors()) do
			-- local adjTile = self.grid(tile.x + dirMap[dir].x, tile.y + dirMap[dir].y)
			local options = 0
			for _, d in ipairs(adjTile:getNeighbors()) do
				if not d.deadEnd then
					options = options + 1
				end
			end

			if options == 1 and tile ~= self.start and tile ~= self.target then
				-- if it will be a dead end, add it to self.list
				table.insert(nList, adjTile)
			end
		end
		self.list = nList
	end
	cfg.timerReset = cfg.DEADENDTIMER

	if #self.list == 0 then
		constructPath(self)
	end
end

return def
