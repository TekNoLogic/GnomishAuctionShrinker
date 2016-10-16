
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

	function ilvlsort:UpdateArrow()
		local sort
		if ns.sortbyilvl == -1 then sort = "DESC" end
		if ns.sortbyilvl == 1 then sort = "ASC" end
		self:SetSort(sort)
	end


	local sellersort = ns.CreateHeaderButton(header, "Seller", "seller")
	AnchorSort(sellersort, columns[4], header)


	local durationsort = ns.CreateHeaderButton(header, "Time", "duration")
	AnchorSort(durationsort, columns[5], header)


	local bidsort = ns.CreateHeaderButton(header, "Bid", "bid")
	AnchorSort(bidsort, columns[6], header)


	local buyoutsort = ns.CreateHeaderButton(header, "Buyout", "buyout")
	AnchorSort(buyoutsort, columns[7], header)


	local unitsort = ns.CreateHeaderButton(header, "Unit BO")
	AnchorSort(unitsort, columns[8], header)

	function unitsort:UpdateArrow()
		self:SetSort(ns.sortbyunit and "ASC")
	end


	local qtysort = ns.CreateHeaderButton(header, "#", "quantity")
	AnchorSort(qtysort, columns[9], header)


	ns.CreateHeaderButton = nil


	ilvlsort:SetScript("OnClick", function(self)
		-- Failsafe, don't let sorting be enabled when we have done an all-scan
		if GetNumAuctionItems("list") > 100 then return end

		if ns.sortbyilvl == 1 then
			ns.sortbyilvl = -1
			ns.sortbyunit = false
		elseif ns.sortbyilvl == false then
			ns.sortbyilvl = 1
			ns.sortbyunit = false
		else
			ns.sortbyilvl = false
		end

		self:UpdateArrow()
		unitsort:UpdateArrow()
		wipe(ns.sorttable)
		ns.Update()
	end)

	unitsort:SetScript("OnClick", function(self)
		-- Failsafe, don't let sorting be enabled when we have done an all-scan
		if GetNumAuctionItems("list") > 100 then return end

		ns.sortbyunit = not ns.sortbyunit
		if ns.sortbyunit then ns.sortbyilvl = false end

		self:UpdateArrow()
		ilvlsort:UpdateArrow()
		wipe(ns.sorttable)
		ns.Update()
	end)
end
