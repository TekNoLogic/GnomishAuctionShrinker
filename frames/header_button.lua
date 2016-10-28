
local myname, ns = ...


local columns = {}
local function UpdateArrow(self)
	if not columns[self] then return end

	local column, reversed = GetAuctionSort("list", 1)
	if column == "quality" then reversed = not reversed end
	if columns[self] == column then
		self:SetSort(reversed and "DESC" or "ASC")
	else
		self:SetSort()
	end
end


local function OnClick(self)
	if not columns[self] then return end
	ns.SortAuctions(columns[self])
end


local function OnShow(self)
	self:UpdateArrow()
end


local function OnQuerySent(self)
	self:UpdateArrow()
	self:Disable()
end


local function OnQueryComplete(self, message, all_scan)
	if all_scan then return end
	if columns[self] then self:Enable() end
end


function ns.CreateHeaderButton(parent, text, column)
	local butt = ns.CreateColumnHeader(parent)
	columns[butt] = column

	butt:SetText(text)

	butt.UpdateArrow = UpdateArrow

	butt:SetScript("OnClick", OnClick)
	butt:SetScript("OnShow", OnShow)

	ns.RegisterCallback(butt, "_AUCTION_QUERY_SENT", OnQuerySent)
	ns.RegisterCallback(butt, "_AUCTION_QUERY_COMPLETE", OnQueryComplete)

	butt:UpdateArrow()

	if not column then butt:Disable() end

	return butt
end
