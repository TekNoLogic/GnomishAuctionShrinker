
local myname, ns = ...


function ns.CreateHeader(parent, columns)
	local header = CreateFrame("Frame", nil, parent)
	header:SetHeight(19)
	header:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 2)
	header:SetPoint("RIGHT")


	local i = 1
	local function Make(name, sort)
		local butt = ns.CreateHeaderButton(header, name, sort)

		butt:SetPoint("TOP", header)
		butt:SetPoint("BOTTOM", header)
		butt:SetPoint("LEFT", columns[i])
		butt:SetPoint("RIGHT", columns[i])

		i = i + 1
	end

	Make("Item", "quality")
	Make("Lvl", "level")
	Make("iLvl")
	Make("Seller", "seller")
	Make("Time", "duration")
	Make("Bid")
	Make("Buyout", "buyout")
	Make("Unit BO", "unitprice")
	Make("#", "quantity")
end
