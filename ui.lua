
local geometry = require "geometry"
local common = require "common"

local ui = {}
ui.__index = ui

local lg = love.graphics
local font = lg.newFont(28)

local function getPathingOptions()
	local out = {}
	for i, v in ipairs(love.filesystem.getDirectoryItems("pathing")) do
		local stripped = v:gsub("%.lua", "")
		table.insert(out, stripped)
	end
	return out
end

local function run(button)
	local text = {[true] = "Play", [false] = "Pause"}
	button.toggled = not button.toggled
	button.text = text[button.toggled]

	common.run = button.toggled
end

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
			color = { 0.6, 0.6, 0.6, 1 },
			menuOptions = getPathingOptions(),
			callback = function(n) end
		},
		genMaze = {
			x = 0.8,
			-- y = 0.5,
			width = aWidth,
			height = aHeight,
			text = "New Maze",
			color = { 0.6, 0.6, 0.6, 1 },
			callback = function(n) end
		},
		run = {
			x = 0.5,
			-- y = 0.5,
			width = 200,
			height = 75,
			text = "Pause",
			color = { 0.7, 0.8, 0.7, 1 },
			toggled = false,
			callback = run
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
end

function ui:mousepressed(x, y, b)
	if b ~= 1 then return end
	local ch = lg.getHeight() - self.height / 2
	for k, button in pairs(self.buttons) do
		local bx = getButtonXCenter(button)
		local mx, my = love.mouse.getPosition()
		if geometry.inRect(mx, my, bx, ch - button.height / 2, button.width, button.height) then
			button.callback(button)
			print(button.text)
		end
	end
end

return new()
