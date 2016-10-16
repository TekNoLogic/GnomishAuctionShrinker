
local myname, ns = ...


local buttons = {}
local columns = {}
local function UpdateArrow(self)
	local column, reversed = GetAuctionSort("list", 1)
	if column == "quality" then reversed = not reversed end
	if columns[self] == column then
		self:SetSort(reversed and "DESC" or "ASC")
	else
		self:SetSort()
	end
end


local function OnClick(self)
	ns.SortAuctions(columns[self])
end


local function OnShow(self)
	self:UpdateArrow()
end


function ns.CreateHeaderButton(parent, text, column)
	local butt = ns.NewColumnHeader(parent)
	butt:SetText(text)

	butt.UpdateArrow = UpdateArrow
	butt:SetScript("OnShow", OnShow)

	columns[butt] = column
	if column then
		butt:SetScript("OnClick", OnClick)
		butt:UpdateArrow()
	end

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
	for butt in pairs(buttons) do butt:UpdateArrow() end
	all_scan = get_all
	enabler:Show()
end)
