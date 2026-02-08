local geometry = require "geometry"
local common = require "common"
local cfg = require "settings"
table.unpack = unpack or table.unpack

local ui = {}
ui.__index = ui

local lg = love.graphics
local font = lg.newFont(28)

local contextMenu = nil
local contextFont = lg.newFont(18)
local height = 100

local function getButtonXLeft(button)
	return button.x * lg.getWidth() - button.width / 2
end

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

local function selectAlgorithm(button)
	local bx = getButtonXLeft(button)
	local ch = lg.getHeight() - height / 2
	local h = contextFont:getHeight() * (#button.menuOptions + 1)
	contextMenu = {
		options = button.menuOptions,
		x = bx,
		y = ch - button.height / 2 - h,
		width = button.width,
		height = h
	}
end

local function new()
	local self = setmetatable({}, ui)

	height = 100

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
			callback = selectAlgorithm
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

function ui:update(dt)

end

function ui:draw()
	lg.push("all")
	lg.setFont(font)
	lg.setColor(0.4, 0.4, 0.4, 1)
	lg.rectangle("fill", 0, lg.getHeight() - height, lg.getWidth(), height)

	local ch = lg.getHeight() - height / 2
	for k, button in pairs(self.buttons) do
		local bx = getButtonXLeft(button)

		lg.setColor(button.color)
		lg.rectangle("fill", bx, ch - button.height/2, button.width, button.height)
		lg.setColor(1, 1, 1)
		lg.print(button.text, bx + button.width/2 - font:getWidth(button.text)/2, ch - font:getHeight()/2)

		local mx, my = love.mouse.getPosition()
		if not contextMenu and geometry.inRect(mx, my, bx, ch - button.height/2, button.width, button.height) then
			lg.setColor(0, 0, 0, 0.1)
			lg.rectangle("fill", bx, ch - button.height / 2, button.width, button.height)
		end
	end

	if contextMenu then
		lg.setColor(0.8, 0.8, 0.8, 1)
		lg.rectangle("fill", contextMenu.x, contextMenu.y, contextMenu.width, contextMenu.height)
		local padding = 4  -- or whatever padding you want
		lg.setColor(1, 1, 1)
		for i, option in ipairs(contextMenu.options) do

			-- check if mouse if over option
			local mx, my = love.mouse.getPosition()
			local rect = { contextMenu.x, contextMenu.y + (i - 1) * (contextFont:getHeight() + padding) + padding, contextMenu.width, contextFont:getHeight() }
			if geometry.inRect(mx, my, table.unpack(rect)) then
				lg.setColor(0, 0, 0, 0.1)
				lg.rectangle("fill", table.unpack(rect))
				lg.setColor(1, 1, 1)
			end

			local y = contextMenu.y + (i - 1) * (contextFont:getHeight() + padding)
			lg.print(option, contextMenu.x + 10, y)
		end
	end

	lg.pop()
end

function ui:mousepressed(x, y, b)
	if b ~= 1 then return end

	-- when there is a context menu, check if the click is in bounds and if not, make context menu nil
	if contextMenu then
		if not geometry.inRect(x, y, contextMenu.x, contextMenu.y, contextMenu.width, contextMenu.height) then
			contextMenu = nil
			return
		end

		local padding = 4
		for i, option in ipairs(contextMenu.options) do
			local rect = { contextMenu.x, contextMenu.y + (i - 1) * (contextFont:getHeight() + padding) + padding, contextMenu.width, contextFont:getHeight() }
			if geometry.inRect(x, y, table.unpack(rect)) then
				cfg.pathfinder = option
				common.generateMaze(true)
				contextMenu = nil
				return
			end
		end
	end

	local ch = lg.getHeight() - height / 2
	for k, button in pairs(self.buttons) do
		local bx = getButtonXLeft(button)
		local mx, my = love.mouse.getPosition()
		if geometry.inRect(mx, my, bx, ch - button.height / 2, button.width, button.height) then
			button.callback(button)
			print(button.text)
		end
	end
end

return new()
