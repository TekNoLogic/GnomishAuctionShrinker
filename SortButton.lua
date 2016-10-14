
local myname, ns = ...

local SORTS = {
	buyout     = {"duration", "quantity", "name", "level", "quality", "bid", "buyout"},
	buyout_rev = {     false,       true,  false,    true,     false, false,    false},
	quantity     = {"duration", "buyoutthenbid", "name", "level", "quality", "quantity"},
	quantity_rev = {     false,           false,  false,    true,     false,      false},
}
for _,column in pairs({"level", "duration", "seller", "bid", "quality"}) do
	local data = AuctionSort["list_"..column]
	local sort = {}
	local rev = {}
	for i,v in ipairs(data) do
		table.insert(sort, v.column)
		table.insert(rev, v.reverse)
	end
	SORTS[column] = sort
	SORTS[column.."_rev"] = rev
end


local function SortAuctions(self)
	-- change the sort as appropriate
	local existingSortColumn, existingSortReverse = GetAuctionSort("list", 1)
	local oppositeOrder = false
	if existingSortColumn and existingSortColumn == self.sortcolumn then
		oppositeOrder = not existingSortReverse
	end

	-- clear the existing sort.
	SortAuctionClearSort("list")

	local revs = SORTS[self.sortcolumn.."_rev"]
	for i,column in ipairs(SORTS[self.sortcolumn]) do -- set the columns
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
