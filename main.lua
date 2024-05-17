local lg = love.graphics

local Tiles = require "libraries.luatile.grid"
local tiles

local currentPath
local MOVETIMER = 2
local moveTimer = MOVETIMER

local boxSize = 8-- includes walls
local pathColor = { 1, 1, 1, 1 }
local moveSpeed = 150
local offset = {x = 0, y = 0}

function love.load()
	local mazeData = love.image.newImageData("maze.png")

	-- Keep track of the current path
	currentPath = {}

	local dw, dh = mazeData:getDimensions()
	tiles = Tiles.new(require("tile").new, dw / boxSize, dh / boxSize)
	for tx = 1, #tiles.tiles do
		if not tiles(tx, 1).walls[1] then
			currentPath[1] = tiles(tx, 1)
			break
		end

	end

	lg.setBackgroundColor(1,1,1)
end

function love.update(dt)
	-- Your pathfinding algorithm here, updating currentPath
	-- For simplicity, I'm just updating it randomly here
	if love.timer.getTime() % 2 < 1 then
		-- table.insert(currentPath, {x = math.random(1, mazeImage:getWidth()), y = math.random(1, mazeImage:getHeight())})
	else
		-- table.remove(currentPath)
	end

	if love.keyboard.isDown("w") then
		offset.y = offset.y + moveSpeed * dt
	end
	if love.keyboard.isDown("a") then
		offset.x = offset.x + moveSpeed * dt
	end
	if love.keyboard.isDown("s") then
		offset.y = offset.y - moveSpeed * dt
	end
	if love.keyboard.isDown("d") then
		offset.x = offset.x - moveSpeed * dt
	end
end

function love.draw()
	lg.push("all")
	lg.translate(offset.x, offset.y)

	local DBG = 0
    for cell, x, y in tiles:iterate() do
        local tx, ty = lg.transformPoint(cell.vx, cell.vy)
        if tx + boxSize > 0 and tx < lg.getWidth()
		and ty + boxSize > 0 and ty < lg.getHeight() then
			DBG = DBG + 1
			cell:draw()
		end
	end

	-- Apply changes to the displayed image
    lg.pop()
	lg.setColor(0,0,0)
	lg.print(DBG)
end

function love.keypressed(key) end
function love.keyreleased(key) end
function love.mousepressed(x, y, button, istouch, presses) end
function love.mousereleased(x, y, button, istouch, presses) end
function love.mousemoved(x, y, dx, dy, istouch) end
function love.wheelmoved(x, y) end
function love.textinput(text) end