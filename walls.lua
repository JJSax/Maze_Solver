local Walls = {
	TOP = 1, -- 0001
	RIGHT = 2, -- 0010
	BOTTOM = 4, -- 0100
	LEFT = 8 -- 1000
}

---Check to see if the mask (the tile wall) has the wall
---@param mask integer tile wall
---@param wall integer The wall to check / the bit to check [1,2,4,8]
---@return boolean
function Walls.has(mask, wall)
	return bit.band(mask, wall) ~= 0
end

return Walls