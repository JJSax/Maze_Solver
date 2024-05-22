local lg = love.graphics
local cfg = require "settings"

local Tiles = require "libraries.luatile.init"
local grid, path

local boxSize = cfg.boxSize -- includes walls
local moveSpeed = cfg.moveSpeed
local camera = {x = -800, y = 0, scale = 1}
local pathPos

function love.load()
	local mazeData = love.image.newImageData(cfg.mazeImgPath)

	local dw, dh = mazeData:getDimensions()
	local mw, mh = math.floor(dw / boxSize), math.floor(dh / boxSize)
	grid = Tiles.new(require("tile"), mw, mh, true)
	grid.width = mw
	grid.height = mh
	local start, finish
	local af, bf = false, false
	for tx = 1, #grid.tiles do
		if not af and not grid(tx, 1).walls[1] then
			start = grid(tx, 1)
			af = true
		end

		if not bf and not grid(tx, #grid.tiles[1]).walls[3] then
			finish = grid(tx, mh)
			bf = true
		end

		if af and bf then break end
	end
	camera.x = lg.getWidth() /2 - start.vx
	camera.y = lg.getHeight()/2 - start.vy

	path = require("pathing.dfs").create(grid, start, finish)

	grid.path = path

	lg.setBackgroundColor(1,1,1)
end

function love.update(dt)
	cfg.moveTimer = cfg.moveTimer - dt
	if cfg.moveTimer < 0 and path.complete then
		cfg.moveTimer = 0.1
		pathPos = pathPos + 1
		if pathPos > #path.path then
			pathPos = 1
		end
	end

	if cfg.moveTimer < 0 and not cfg.paused and not path.complete then
		local div = love.keyboard.isDown("space") and 4 or 1
		if cfg.hypermode then
			div = div * 10
		end
		cfg.moveTimer = cfg.timerReset / div
		for _ = 1, cfg.stepsPerFrame do
			path:step()
		end
		-- path:run()
		if path.complete then
			pathPos = 1
		end
	end

	if love.keyboard.isDown("w") then
		camera.y = camera.y + moveSpeed * dt
	end
	if love.keyboard.isDown("a") then
		camera.x = camera.x + moveSpeed * dt
	end
	if love.keyboard.isDown("s") then
		camera.y = camera.y - moveSpeed * dt
	end
	if love.keyboard.isDown("d") then
		camera.x = camera.x - moveSpeed * dt
	end
end

-- This function returns a new scale value based on the input delta and current scale
-- It ensures the scale stays within reasonable limits.
local function adjustScale(currentScale, delta, minScale, maxScale)
	-- Set default min and max scales if not provided
	minScale = minScale or 0.1
	maxScale = maxScale or 5.0

	-- Adjust scale by a factor based on the delta
	local factor = 1.1 -- Adjust this factor for smoother or more aggressive scaling
	if delta > 0 then
		currentScale = currentScale * factor
	elseif delta < 0 then
		currentScale = currentScale / factor
	end

	currentScale = math.max(minScale, math.min(currentScale, maxScale))

	return currentScale
end

function love.draw()
	lg.push("all")
	lg.translate(camera.x, camera.y)
	lg.scale(camera.scale)

	local DBG = 0
	for cell, x, y in grid:iterate() do
		local tx, ty = lg.transformPoint(cell.vx, cell.vy)
		if  tx + boxSize * camera.scale > 0 and tx < lg.getWidth()
		and ty + boxSize * camera.scale > 0 and ty < lg.getHeight() then
			DBG = DBG + 1
			cell:draw()
		end
	end

	if path.complete then
		lg.setColor(1,1,1, 0.8)

		lg.rectangle("fill", path.path[pathPos].vx, path.path[pathPos].vy, cfg.boxSize, cfg.boxSize)
	end

	lg.pop()
	lg.setColor(0,0,0)
	-- lg.print(DBG)
	-- lg.print(path.currentTile.x .. ": ".. path.currentTile.y)
	if path.complete then
		lg.print(path.path[pathPos].x .. ": ".. path.path[pathPos].y)
	end
end

function love.keypressed(key)
	if key == "p" then
		cfg.paused = not cfg.paused
	elseif key == "h" then
		-- hypermode
		cfg.hypermode = not cfg.hypermode
	elseif key == "up" then
		cfg.stepsPerFrame = cfg.stepsPerFrame + 1
	elseif key == "down" then
		cfg.stepsPerFrame = cfg.stepsPerFrame - 1
		if cfg.stepsPerFrame < 1 then cfg.stepsPerFrame = 1 end
	end
end
function love.keyreleased(key) end
function love.mousepressed(x, y, button, istouch, presses) end
function love.mousereleased(x, y, button, istouch, presses) end
function love.mousemoved(x, y, dx, dy, istouch) end
function love.wheelmoved(x, y)
	if y == 0 then return end

	local oldScale = camera.scale
	camera.scale = adjustScale(camera.scale, y, 0.1, 5.0)
	-- Adjust camera position to keep the center of the screen in view
	local mx, my = love.mouse.getPosition()
	local dx = mx / love.graphics.getWidth() - 0.5
	local dy = my / love.graphics.getHeight() - 0.5
	camera.x = camera.x + dx * (1 / oldScale - 1 / camera.scale) * love.graphics.getWidth()
	camera.y = camera.y + dy * (1 / oldScale - 1 / camera.scale) * love.graphics.getHeight()
end
function love.textinput(text) end