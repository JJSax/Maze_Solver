
assert(love and love.graphics and love.image, "This module requires Love2D")

local cfg = require "settings"

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

return common