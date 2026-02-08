
local geometry = require "geometry"

local ui = {}
ui.__index = ui

local lg = love.graphics
local font = lg.newFont(28)

local function new()
	local self = setmetatable({}, ui)

	self.height = 100

	local aWidth = 175
	local aHeight = 50

	self.buttons = {
		algorithm = {
			x = 0.2,
			-- y = 0.5,
			width = aWidth,
			height = aHeight,
			text = "Algorithm",
			color = { 0.6, 0.6, 0.6, 1 }
		},
		genMaze = {
			x = 0.8,
			-- y = 0.5,
			width = aWidth,
			height = aHeight,
			text = "New Maze",
			color = { 0.6, 0.6, 0.6, 1 }
		},
		run = {
			x = 0.5,
			-- y = 0.5,
			width = 200,
			height = 75,
			text = "Run",
			color = { 0.7, 0.8, 0.7, 1 }
		}
	}

	return self
end

local function getButtonXCenter(button)
	return button.x * lg.getWidth() - button.width / 2
end

function ui:update(dt)

end

function ui:draw()
	lg.push("all")
	lg.setFont(font)
	lg.setColor(0.4, 0.4, 0.4, 1)
	lg.rectangle("fill", 0, lg.getHeight() - self.height, lg.getWidth(), self.height)

	local ch = lg.getHeight() - self.height / 2
	lg.push("all")
	for k, button in pairs(self.buttons) do
		local bx = getButtonXCenter(button)

		lg.setColor(button.color)
		lg.rectangle("fill", bx, ch - button.height/2, button.width, button.height)
		lg.setColor(1, 1, 1)
		lg.print(button.text, bx + button.width/2 - font:getWidth(button.text)/2, ch - font:getHeight()/2)

		local mx, my = love.mouse.getPosition()
		if geometry.inRect(mx, my, bx, ch - button.height/2, button.width, button.height) then
			lg.setColor(0, 0, 0, 0.1)
			lg.rectangle("fill", bx, ch - button.height / 2, button.width, button.height)
		end
	end
	lg.pop()


	lg.pop()
end

return new()
