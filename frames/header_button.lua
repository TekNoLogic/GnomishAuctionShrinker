
local myname, ns = ...


local columns = {}
local function OnClick(self)
	ns.SortAuctions(columns[self])
end


function ns.CreateHeaderButton(text, column)
	local butt = ns.NewColumnHeader(AuctionFrameBrowse)
	butt:SetText(text)

	columns[butt] = column
	if column then butt:SetScript("OnClick", OnClick) end

	return butt
end
