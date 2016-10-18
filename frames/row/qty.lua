
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local item_id = ns.GetAuctionItemID(index)
	local _, _, _, _, _, _, _, stack = GetItemInfo(item_id)
	if not stack or stack == 1 then return self:SetText() end

	local _, _, count = GetAuctionItemInfo("list", index)
	self:SetText(count)
end


function ns.CreateAuctionQty(parent)
	local qty = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	qty.SetValue = SetValue
	return qty
end
