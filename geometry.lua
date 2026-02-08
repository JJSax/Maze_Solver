local geometry = {}

function geometry.inRect(x, y, bx, by, bw, bh)
	return x > bx and x < bx + bw and y > by and y < by + bh
end

return geometry