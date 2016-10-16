
local myname, ns = ...


local COLUMN_WIDTHS = {181, 27, 37, 79, 49, 69, 69, 69, 27}


function ns.CreateColumns(parent)
	local columns = {}

	for i,width in ipairs(COLUMN_WIDTHS) do
		local column = CreateFrame("Frame", nil, parent)
		column:SetSize(width, 1)
		if i == 1 then
			column:SetPoint("LEFT")
		else
			column:SetPoint("LEFT", columns[i-1], "RIGHT")
		end
		columns[i] = column
	end

	return columns
end
