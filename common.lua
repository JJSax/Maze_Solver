
assert(love and love.graphics and love.image, "This module requires Love2D")

local cfg = require "settings"
local Tiles      = require "libraries.luatile.init" -- https://github.com/JJSax/lautile
local Walls      = require "walls"

local common = {}

common.imageData = love.image.newImageData(cfg.mazeImgPath)
common.image = love.graphics.newImage(common.imageData)
common.image:setFilter("nearest", "nearest") -- pixel-perfect

common.refreshImageData = false -- Set to true to refresh image data from file at end of frame

function common.refreshImage()
	if common.refreshImageData then
		common.image:replacePixels(common.imageData)
	end
	common.refreshImageData = false
end

common.dirMap = {
	{ x = 0,  y = -1 },
	{ x = 1,  y = 0 },
	{ x = 0,  y = 1 },
	{ x = -1, y = 0 }
}

function common.generateMaze(reload)
	if reload == true then
		common.imageData = love.image.newImageData(cfg.mazeImgPath)
		common.image = love.graphics.newImage(common.imageData)
	end

	local dw, dh = common.imageData:getDimensions()
	local mw, mh = math.floor(dw / cfg.boxSize), math.floor(dh / cfg.boxSize)

	common.grid = Tiles.new(require("tile"), mw, mh, true)
	local start, finish
	local af, bf = false, false
	for tx = 1, #common.grid.tiles do
		if not af and not Walls.has(common.grid(tx, 1).walls, Walls.TOP) then
			start = common.grid(tx, 1)
			af = true
		end

		if not bf and not Walls.has(common.grid(tx, #common.grid.tiles[1]).walls, Walls.BOTTOM) then
			finish = common.grid(tx, mh)
			bf = true
		end

		if af and bf then break end
	end

	if cfg.pathfinder then
		common.path = require("pathing."..cfg.pathfinder).create(common.grid, start, finish)
	end

	return start
end

return common