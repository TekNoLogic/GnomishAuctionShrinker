
local myname, ns = ...


local dirty = false
local sortbyunit = true
local sortbyilvl = false
local sorttable = {}


local function UnitPriceSorter(a,b)
	local _, _, counta, _, _, _, _, _, _, buyouta = GetAuctionItemInfo("list", a)
	local _, _, countb, _, _, _, _, _, _, buyoutb = GetAuctionItemInfo("list", b)
	if not buyouta then return false end
	if not buyoutb then return true end
	return buyouta/counta < buyoutb/countb
end


local function ItemlevelSorter(a,b)
	if not a or not b then return false end
	if not b then return true end

	local linka = GetAuctionItemLink("list", a)
	if not linka then return false end
	local _, _, _, iLevela = GetItemInfo(linka)

	local linkb = GetAuctionItemLink("list", b)
	if not linkb then return true end
	local _, _, _, iLevelb = GetItemInfo(linkb)

	if iLevela == iLevelb then return UnitSort(a,b) end
	if sortbyilvl == 1 then
		return (iLevela or 0) < (iLevelb or 0)
	else
		return (iLevela or 0) > (iLevelb or 0)
	end
end


local function FetchSortedList(sorter)
	if not dirty and next(sorttable) then return sorttable end

	wipe(sorttable)
	dirty = false

	for i=1,GetNumAuctionItems("list") do table.insert(sorttable, i) end
	table.sort(sorttable, sorter)

	return sorttable
end


function ns.GetUnitPriceSort()
	return sortbyunit
end


function ns.GetItemlevelSort()
	return sortbyilvl
end


function ns.ToggleUnitPriceSort()
	-- Failsafe, don't let sorting be enabled when we have done an all-scan
	if GetNumAuctionItems("list") > 100 then return end

	sortbyunit = not sortbyunit
	if sortbyunit then sortbyilvl = false end

	dirty = true

	ns.SendMessage("ANCILLARY_SORT_CHANGED")
end


function ns.ToggleItemlevelSort()
	-- Failsafe, don't let sorting be enabled when we have done an all-scan
	if GetNumAuctionItems("list") > 100 then return end

	if sortbyilvl == 1 then
		sortbyilvl = -1
		sortbyunit = false
	elseif sortbyilvl == false then
		sortbyilvl = 1
		sortbyunit = false
	else
		sortbyilvl = false
	end

	dirty = true

	ns.SendMessage("ANCILLARY_SORT_CHANGED")
end


function ns.MarkSortDirty()
	dirty = true
end


function ns.GetSortedResults()
	if sortbyunit then return FetchSortedList(UnitPriceSorter) end
	if sortbyilvl then return FetchSortedList(ItemlevelSorter) end
end


ns.RegisterCallback({}, "AUCTION_QUERY_SENT", function(self, message, all_scan)
	if all_scan then sortbyunit, sortbyilvl = false, false end
	dirty = true
end)
