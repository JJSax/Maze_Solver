local lg = love.graphics

local canvas, mazedata, maze, startPoint

local lineWidth = 2
local boxSize -- includes walls
local pathColor = {1, 1, 1, 1}

local function drawCanvas()
	local scale = 0.5
	lg.setCanvas(canvas)
	lg.draw(maze, 0, 0, 0, scale)
	lg.setCanvas()
	mazedata = canvas:newImageData()
end

function love.load()
	love.window.setMode(1200, 1000)
	maze = lg.newImage("maze.png")
	local mw, mh = maze:getDimensions()
	local scale = 0.5
	canvas = lg.newCanvas(mw * scale, mh * scale)

	drawCanvas()



	for i = 1, mazedata:getWidth() - 1 do
		local r, g, b = mazedata:getPixel(i, 1)
		if r + g + b == 3 then
			startPoint = i
			boxSize = 1 -- account for wall pixel
			for i = i, i + 1000 do
				local r, g, b = mazedata:getPixel(i, 1)
				boxSize = boxSize + 1
				if r+g+b < 3 or boxSize > mw then
					break
				end
			end
			break
		end
	end

	-- print(mazedata:getPixel(0, 5))
	-- print(mazedata:getPixel(1, 5))
	-- print(mazedata:getPixel(2, 5))
    -- print(mazedata:getPixel(3, 5))
	-- print(boxSize)
end

function love.update(dt)

end

function love.draw()
	lg.setColor(1,1,1)
	lg.draw(canvas)


	lg.setCanvas(canvas)
	lg.setColor(math.random(), math.random(), math.random())
	lg.points(math.random(0, 600), math.random(0, 600))
	lg.setCanvas()
	-- mazedata:setPixel(math.random(0, 600), math.random(0, 600), math.random(), math.random(), math.random())
	-- drawCanvas()
end

function love.keypressed(key) end
function love.keyreleased(key) end
function love.mousepressed(x, y, button, istouch, presses) end
function love.mousereleased(x, y, button, istouch, presses) end
function love.mousemoved(x, y, dx, dy, istouch) end
function love.wheelmoved(x, y) end
function love.textinput(text) end