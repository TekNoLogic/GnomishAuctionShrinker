
local myname, ns = ...


local BUYOUT_LIMIT = 800 * 100 * 100 -- 800g
local NUM_ROWS, BOTTOM_GAP = 14, 25
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)


local function AnchorSort(butt, column, row)
	butt:SetPoint("TOP", row)
	butt:SetPoint("BOTTOM", row)
	butt:SetPoint("LEFT", column)
	butt:SetPoint("RIGHT", column)
end


function ns.CreateHeader(parent, columns)
	local header = CreateFrame("Frame", nil, parent)
	header:SetHeight(19)
	header:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 2)
	header:SetPoint("RIGHT")


	local qualitysort = ns.CreateHeaderButton(header, "Item", "quality")
	AnchorSort(qualitysort, columns[1], header)


	local levelsort = ns.CreateHeaderButton(header, "Lvl", "level")
	AnchorSort(levelsort, columns[2], header)


	local ilvlsort = ns.CreateHeaderButton(header, "iLvl")
	AnchorSort(ilvlsort, columns[3], header)


	local sellersort = ns.CreateHeaderButton(header, "Seller", "seller")
	AnchorSort(sellersort, columns[4], header)


	local durationsort = ns.CreateHeaderButton(header, "Time", "duration")
	AnchorSort(durationsort, columns[5], header)


	local bidsort = ns.CreateHeaderButton(header, "Bid")
	AnchorSort(bidsort, columns[6], header)


	local buyoutsort = ns.CreateHeaderButton(header, "Buyout", "buyout")
	AnchorSort(buyoutsort, columns[7], header)


	local unitsort = ns.CreateHeaderButton(header, "Unit BO", "unitprice")
	AnchorSort(unitsort, columns[8], header)


	local qtysort = ns.CreateHeaderButton(header, "#", "quantity")
	AnchorSort(qtysort, columns[9], header)
end
