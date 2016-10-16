
local myname, ns = ...


local BUYOUT_LIMIT = 800 * 100 * 100 -- 800g
local NUM_ROWS, BOTTOM_GAP = 14, 25
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)


local function AnchorSort(butt, column)
	butt:SetPoint("TOP")
	butt:SetPoint("LEFT", column, "LEFT", -3, 0)
	butt:SetPoint("RIGHT", column, "RIGHT")
end


function ns.CreateHeader(parent, row)
	local header = CreateFrame("Frame", nil, parent)
	header:SetHeight(19)
	header:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 2)
	header:SetPoint("RIGHT")


	local qualitysort = ns.CreateHeaderButton(header, "Item", "quality")
	qualitysort:SetPoint("TOP")
	qualitysort:SetPoint("LEFT", row.icon, "LEFT", -6, 0)
	qualitysort:SetPoint("RIGHT", row.name, "RIGHT")


	local levelsort = ns.CreateHeaderButton(header, "Lvl", "level")
	AnchorSort(levelsort, row.min)


	local ilvlsort = ns.CreateHeaderButton(header, "iLvl")
	AnchorSort(ilvlsort, row.ilvl)

	function ilvlsort:UpdateArrow()
		local sort
		if ns.sortbyilvl == -1 then sort = "DESC" end
		if ns.sortbyilvl == 1 then sort = "ASC" end
		self:SetSort(sort)
	end


	local sellersort = ns.CreateHeaderButton(header, "Seller", "seller")
	AnchorSort(sellersort, row.owner)


	local durationsort = ns.CreateHeaderButton(header, "Time", "duration")
	AnchorSort(durationsort, row.timeleft)


	local bidsort = ns.CreateHeaderButton(header, "Bid", "bid")
	AnchorSort(bidsort, row.bid)


	local buyoutsort = ns.CreateHeaderButton(header, "Buyout", "buyout")
	AnchorSort(buyoutsort, row.buyout)


	local unitsort = ns.CreateHeaderButton(header, "Unit BO")
	AnchorSort(unitsort, row.unit)

	function unitsort:UpdateArrow()
		self:SetSort(ns.sortbyunit and "ASC")
	end


	local qtysort = ns.CreateHeaderButton(header, "#", "quantity")
	AnchorSort(qtysort, row.qty)


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
