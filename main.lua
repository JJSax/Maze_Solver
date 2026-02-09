
assert(love and love.graphics, "This code requires the LÖVE framework to run.") -- https://www.love2d.org/

--todo: gen maze on demand.
--todo: add UI

local lg = love.graphics
local cfg = require "settings"
local common = require "common"
local ui = require "ui"

local boxSize = cfg.boxSize -- includes walls
local moveSpeed = cfg.moveSpeed
local camera = {x = -800, y = 0, scale = 1}
local pathPos

function love.load()
	local start = common.generateMaze()
	camera.x = lg.getWidth() /2 - start.vx
	camera.y = lg.getHeight()/2 - start.vy

	lg.setBackgroundColor(1,1,1)
end

function love.update(dt)
	if common.run then
		cfg.moveTimer = cfg.moveTimer - dt
	end

	if cfg.moveTimer < 0 and common.path.complete then
		cfg.moveTimer = 0.1
		pathPos = pathPos + 1
		if pathPos > #common.path.path then
			pathPos = 1
		end
		common.path.currentTile = common.path.path[pathPos]
	end

	if cfg.moveTimer < 0 and not cfg.paused and not common.path.complete then
		local div = love.keyboard.isDown("space") and 4 or 1
		if cfg.hypermode then
			div = div * 10
		end
		cfg.moveTimer = cfg.timerReset / div
		for _ = 1, cfg.stepsPerFrame do
			common.path:step()
		end
		-- path:run()
		if common.path.complete then
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

	common.refreshImage()

	-- update UI (runs tweens and handles UI state)
	ui:update(dt)

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
	lg.setColor(1, 1, 1, 1)
	--fix some lines in maze appearing larger.
	--! I think it's an issue where the image is being drawn at a fractional position for some reason with scaling
	lg.draw(common.image, -1, -1)

	do -- Draw the current tile; prevents checking on every tile
		local cur = common.path.currentTile
		lg.setColor(1, 0.5, 0.5, 1)
		lg.rectangle("fill", cur.vx , cur.vy , boxSize, boxSize)
	end

	if common.path.complete then
		lg.setColor(1,1,1, 0.8)
		lg.rectangle("fill", common.path.path[pathPos].vx, common.path.path[pathPos].vy, cfg.boxSize, cfg.boxSize)
	end

	lg.pop()
	lg.setColor(0,0,0)
	if common.path.complete then
		lg.print(common.path.path[pathPos].x .. ": ".. common.path.path[pathPos].y)
	end

	ui:draw()
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
	elseif key == "r" then
		common.generateMaze(true)
	end
end
function love.keyreleased(key) end
function love.mousepressed(x, y, button, istouch, presses)
	ui:mousepressed(x, y, button)
end
function love.mousereleased(x, y, button, istouch, presses) end
function love.mousemoved(x, y, dx, dy, istouch) end
function love.wheelmoved(x, y)
	if y == 0 then return end

	local oldScale = camera.scale
	local mx, my = love.mouse.getPosition()
	-- Convert mouse screen coords to world coords before scaling
	local worldX = (mx - camera.x) / oldScale
	local worldY = (my - camera.y) / oldScale

	-- Update scale
	camera.scale = adjustScale(camera.scale, y, 0.1, 5.0)

	-- Reposition camera so the world point under the mouse remains under the mouse
	camera.x = mx - worldX * camera.scale
	camera.y = my - worldY * camera.scale
end
function love.textinput(text) end