
local myname, ns = ...


ns.item_colors = setmetatable({}, {
	__index = function(t,i)
		if i and i > 0 then
			local r, g, b, hex = GetItemQualityColor(i)
			local color = {r = r, g = g, b = b, hex = hex}
			t[i] = color
			return color
		end
	end
})
