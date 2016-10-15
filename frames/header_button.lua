
local myname, ns = ...


local columns = {}
local function OnClick(self)
	ns.SortAuctions(columns[self])
end


local buttons = {}
function ns.CreateHeaderButton(text, column)
	local butt = ns.NewColumnHeader(AuctionFrameBrowse)
	butt:SetText(text)

	columns[butt] = column
	if column then butt:SetScript("OnClick", OnClick) end

	buttons[butt] = true

	return butt
end


local all_scan
local enabler = CreateFrame("Frame")
enabler:Hide()

enabler:SetScript("OnShow", function(self)
	for butt in pairs(buttons) do butt:Disable() end
	if all_scan then self:Hide() end
end)

enabler:SetScript("OnUpdate", function(self)
	if not CanSendAuctionQuery("list") then return end

	for butt in pairs(buttons) do butt:Enable() end
	self:Hide()
end)

hooksecurefunc("QueryAuctionItems", function(_, _, _, _, _, _, get_all)
	all_scan = get_all
	enabler:Show()
end)
