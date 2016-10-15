
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

	local qualitysort = ns.CreateHeaderButton("Rarity", "quality")
	local levelsort = ns.CreateHeaderButton("Lvl", "level")
	local sellersort = ns.CreateHeaderButton("Seller", "seller")
	local durationsort = ns.CreateHeaderButton("Time", "duration")
	local bidsort = ns.CreateHeaderButton("Bid", "bid")

	local ilvlsort = ns.CreateHeaderButton("iLvl")
	local buyoutsort = ns.CreateHeaderButton("Buyout", "buyout")
	local unitsort = ns.CreateHeaderButton("Unit BO")
	local qtysort = ns.CreateHeaderButton("#", "quantity")
	ns.CreateHeaderButton = nil

	AnchorSort(qualitysort, row.icon, row.name, -TEXT_GAP - 2)
	AnchorSort(levelsort, row.min)
	AnchorSort(sellersort, row.owner)
	AnchorSort(durationsort, row.timeleft)
	AnchorSort(bidsort, row.bid)

	AnchorSort(ilvlsort, row.ilvl)
	AnchorSort(buyoutsort, row.buyout)
	AnchorSort(unitsort, row.unit)
	AnchorSort(qtysort, row.qty)

	local function UpdateArrow(butt)
		local primaryColumn, reversed = GetAuctionSort("list", 1)
		if butt.sortcolumn == primaryColumn then
			butt:SetSort(reversed and "DESC" or "ASC")
		else
			butt:SetSort()
		end
	end

	function ns.UpdateArrows()
		UpdateArrow(buyoutsort)
		UpdateArrow(qtysort)
	end

	ilvlsort:SetScript("OnClick", function(self)
		if GetNumAuctionItems("list") > 100 then return end -- Failsafe, don't let sorting be enabled when we have done an all-scan
		sortbyilvl = sortbyilvl == 1 and -1 or sortbyilvl == false and 1 or false
		if sortbyilvl then
			sortbyunit = false
			unitsort:SetSort()
			self:SetSort(sortbyilvl == -1 and "DESC" or "ASC")
		else
			self:SetSort()
		end
		wipe(sorttable)
		Update()
	end)

	unitsort:SetScript("OnClick", function(self)
		if GetNumAuctionItems("list") > 100 then return end -- Failsafe, don't let sorting be enabled when we have done an all-scan
		sortbyunit = not sortbyunit
		if sortbyunit then
			sortbyilvl = false
			ilvlsort:SetSort()
			self:SetSort("ASC")
		else
			self:SetSort()
		end
		wipe(sorttable)
		Update()
	end)
	unitsort:SetSort("ASC")
end
