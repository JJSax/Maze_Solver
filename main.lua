local lg = love.graphics

local Tiles = require "libraries.luatile.grid"
local tiles

local canvas, mazedata, maze, startPoint
local mazeImage, mazeData, currentPath

local lineWidth = 2
local boxSize = 8-- includes walls
local pathColor = {1, 1, 1, 1}

function love.load()
	mazeImage = lg.newImage("maze.png")
	mazeData = love.image.newImageData("maze.png")

	-- Keep track of the current path
	currentPath = {}

	local dw, dh = mazeData:getDimensions()
    tiles = Tiles.new(require("tile").new, dw / boxSize, dh / boxSize)

	lg.setBackgroundColor(1,1,1)
end

function love.update(dt)
	-- Your pathfinding algorithm here, updating currentPath
	-- For simplicity, I'm just updating it randomly here
	if love.timer.getTime() % 2 < 1 then
		table.insert(currentPath, {x = math.random(1, mazeImage:getWidth()), y = math.random(1, mazeImage:getHeight())})
	else
		table.remove(currentPath)
	end
end

function love.draw()
    -- lg.draw(mazeImage, 0, 0)
	for cell, x, y in tiles:iterate() do
		cell:draw()
	end

	-- Visualize the current path
	-- for _, point in ipairs(currentPath) do
	-- 	mazeData:setPixel(point.x, point.y, 255, 0, 0) -- Red color for the path
	-- end

	-- Apply changes to the displayed image
	-- lg.clear()
	-- lg.draw(lg.newImage(mazeData))
end

function love.keypressed(key) end
function love.keyreleased(key) end
function love.mousepressed(x, y, button, istouch, presses) end
function love.mousereleased(x, y, button, istouch, presses) end
function love.mousemoved(x, y, dx, dy, istouch) end
function love.wheelmoved(x, y) end
function love.textinput(text) end