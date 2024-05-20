local lg = love.graphics

local Tiles = require "libraries.luatile.grid"
local grid
local path

local MOVETIMER = 0.3
local moveTimer = MOVETIMER

local boxSize = 16-- includes walls
local moveSpeed = 350
local offset = {x = -600, y = 0}

function love.load()
	local mazeData = love.image.newImageData("maze.png")

	local dw, dh = mazeData:getDimensions()
	local start
	grid = Tiles.new(require("tile"), math.floor(dw / boxSize), math.floor(dh / boxSize), true)
	for tx = 1, #grid.tiles do
		if not grid(tx, 1).walls[1] then
			start = grid(tx, 1)
			break
		end
	end

	path = require ("dfs").create(grid, start)

	grid.path = path

	lg.setBackgroundColor(1,1,1)
end

function love.update(dt)
	-- Your pathfinding algorithm here, updating currentPath
	-- For simplicity, I'm just updating it randomly here
	moveTimer = moveTimer - dt
	if moveTimer < 0 then
		moveTimer = MOVETIMER
		path:step()
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
	for cell, x, y in grid:iterate() do
		local tx, ty = lg.transformPoint(cell.vx, cell.vy)
		if tx + boxSize > 0 and tx < lg.getWidth()
		and ty + boxSize > 0 and ty < lg.getHeight() then
			DBG = DBG + 1
			cell:draw()
		end
	end
	lg.pop()
	lg.setColor(0,0,0)
	-- lg.print(DBG)
	lg.print(path.currentTile.x .. ": ".. path.currentTile.y)
end

function love.keypressed(key) end
function love.keyreleased(key) end
function love.mousepressed(x, y, button, istouch, presses) end
function love.mousereleased(x, y, button, istouch, presses) end
function love.mousemoved(x, y, dx, dy, istouch) end
function love.wheelmoved(x, y) end
function love.textinput(text) end