
local myname, ns = ...

local sorts = {
	buyout     = {"duration", "quantity", "name", "level", "quality", "bid", "buyout"},
	buyout_rev = {     false,       true,  false,    true,     false, false,    false},
	quantity     = {"duration", "buyoutthenbid", "name", "level", "quality", "quantity"},
	quantity_rev = {     false,           false,  false,    true,     false,      false},
}


local function SortAuctions(self)
	local existingSortColumn, existingSortReverse = GetAuctionSort("list", 1) -- change the sort as appropriate
	local oppositeOrder = false
	if existingSortColumn and existingSortColumn == self.sortcolumn then oppositeOrder = not existingSortReverse end

	SortAuctionClearSort("list") -- clear the existing sort.

	local revs = sorts[self.sortcolumn.."_rev"]
	for i,column in ipairs(sorts[self.sortcolumn]) do -- set the columns
		local reverse = revs[i]
		if i == #revs and existingSortColumn and existingSortColumn == self.sortcolumn and (not not existingSortReverse) == reverse then reverse = not reverse end
		SortAuctionSetSort("list", column, reverse)
	end

	AuctionFrameBrowse_Search() -- apply the sort
end


function ns.MakeSortButton(text, sortcolumn)
	local butt = ns.NewColumnHeader(AuctionFrameBrowse)
	butt:SetText(text)

	butt.sortcolumn = sortcolumn
	if sortcolumn then butt:SetScript("OnClick", SortAuctions) end

	return butt
end
