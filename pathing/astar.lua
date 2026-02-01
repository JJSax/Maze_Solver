
local cfg = require "settings"
local OGAS = require "libraries.luatile.astar"
local minHeap = require "libraries.tablua.minHeap"
OGAS.MinHeap = minHeap

local JJStar = setmetatable({}, { __index = OGAS})
JJStar.__index = JJStar

function JJStar.create(grid, startTile, target)
	return setmetatable(OGAS.new(grid, startTile, target), JJStar)
end

function JJStar:exploreTile(tile)
	tile:setColor({0,1,1})
	cfg.timerReset = cfg.MOVETIMER
end

function JJStar:markDeadEnd(tile)
	-- tile.color = {.2, 0.22, 0.22}
	-- cfg.timerReset = cfg.DEADENDTIMER

	-- local current = tile
	-- while current and current ~= self.target and current ~= self.start do
		-- Mark the current cell as a dead end
		-- current.color = {.2, 0.22, 0.22}

		-- Move to the previous cell in the path
		-- local previous = current
		-- current = self.cameFrom[current]

		-- local neighbors = self:getUnvisitedNeighbors(current)
		-- local culledNeightbors = {}
		-- for _, n in pairs(neighbors) do
		-- 	if n ~= previous then
		-- 		table.insert(culledNeightbors, n)
		-- 	end
		-- end

		-- Stop marking if the current cell has other unexplored neighbors
		-- if #self:getUnvisitedNeighbors(current) > 1 then
		-- local neighbors = current:getNeighbors()
		-- if #neighbors > 2 then
		-- 	local hasUnvisitedNeighborInOpenList = false
		-- 	for _, neighbor in ipairs(neighbors) do
		-- 		if self.openSet[neighbor] then
		-- 			hasUnvisitedNeighborInOpenList = true
		-- 			break
		-- 		end
		-- 	end
		-- 	if not hasUnvisitedNeighborInOpenList then
		-- 		break
		-- 	end
		-- end
	-- end

end

return JJStar