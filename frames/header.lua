
local myname, ns = ...


local BUYOUT_LIMIT = 800 * 100 * 100 -- 800g
local NUM_ROWS, BOTTOM_GAP = 14, 25
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)
local TEXT_GAP = 4
local noop = function() end


local function AnchorSort(butt, left, right, loffset)
	right, loffset = right or left, loffset or (-TEXT_GAP/2 - 1)
	butt:ClearAllPoints()
	butt:SetPoint("TOP", AuctionFrameBrowse, "TOP", 0, -82)
	butt:SetPoint("LEFT", left, "LEFT", loffset, 0)
	butt:SetPoint("RIGHT", right, "RIGHT")
	butt.SetWidth = noop
end


function ns.CreateHeader(row)
	local header = CreateFrame("Frame", nil, AuctionFrameBrowse)
	header:SetPoint("TOP", 0, -82)

	local qualitysort = ns.CreateHeaderButton("Item", "quality")
	local levelsort = ns.CreateHeaderButton("Lvl", "level")
	local ilvlsort = ns.CreateHeaderButton("iLvl")
	local sellersort = ns.CreateHeaderButton("Seller", "seller")
	local durationsort = ns.CreateHeaderButton("Time", "duration")
	local bidsort = ns.CreateHeaderButton("Bid", "bid")
	local buyoutsort = ns.CreateHeaderButton("Buyout", "buyout")
	local unitsort = ns.CreateHeaderButton("Unit BO")
	local qtysort = ns.CreateHeaderButton("#", "quantity")
	ns.CreateHeaderButton = nil

	AnchorSort(qualitysort, row.icon, row.name, -TEXT_GAP - 2)
	AnchorSort(levelsort, row.min)
	AnchorSort(ilvlsort, row.ilvl)
	AnchorSort(sellersort, row.owner)
	AnchorSort(durationsort, row.timeleft)
	AnchorSort(bidsort, row.bid)
	AnchorSort(buyoutsort, row.buyout)
	AnchorSort(unitsort, row.unit)
	AnchorSort(qtysort, row.qty)

	function ilvlsort:UpdateArrow()
		local sort
		if ns.sortbyilvl == -1 then sort = "DESC" end
		if ns.sortbyilvl == 1 then sort = "ASC" end
		self:SetSort(sort)
	end

	function unitsort:UpdateArrow()
		self:SetSort(ns.sortbyunit and "ASC")
	end

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
		wipe(sorttable)
		Update()
	end)

	unitsort:SetScript("OnClick", function(self)
		-- Failsafe, don't let sorting be enabled when we have done an all-scan
		if GetNumAuctionItems("list") > 100 then return end

		ns.sortbyunit = not ns.sortbyunit
		if ns.sortbyunit then ns.sortbyilvl = false end

		self:UpdateArrow()
		ilvlsort:UpdateArrow()
		wipe(sorttable)
		Update()
	end)
end
