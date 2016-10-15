
local myname, ns = ...


local SORTS = {
	buyout     = {
		"duration", false,
		"quantity",  true,
		"name",     false,
		"level",     true,
		"quality",  false,
		"bid",      false,
		"buyout",   false,
	},
	quantity = {
		"duration",      false,
		"buyoutthenbid", false,
		"name",          false,
		"level",          true,
		"quality",       false,
		"quantity",      false,
	},
}
for _,column in pairs({"level", "duration", "seller", "bid", "quality"}) do
	local data = AuctionSort["list_"..column]
	local sort = {}
	for i,v in ipairs(data) do
		table.insert(sort, v.column)
		table.insert(sort, v.reverse)
	end
	SORTS[column] = sort
end


local function ApplySort(invert, column, reverse, ...)
	local last_pair = select("#", ...) == 0

	if last_pair and invert then reverse = not reverse end
	SortAuctionSetSort("list", column, reverse)

	if not last_pair then return ApplySort(invert, ...) end
end


function ns.SortAuctions(column)
	local sort = SORTS[column]

	-- Determine if we need to invert the sort
	local sorted_column, sorted_reverse = GetAuctionSort("list", 1)
	local invert = false
	if sorted_column and sorted_column == column then
		-- If the last column is sorted in the defined direction, we need to invert
		invert = (not not sorted_reverse) == sort[#sort]
	end

	SortAuctionClearSort("list")

	ApplySort(invert, unpack(sort))
	AuctionFrameBrowse_Search()
end
