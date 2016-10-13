
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local item_id = ns.GetAuctionItemID(index)
	local _, _, _, _, _, _, _, stack = GetItemInfo(item_id)
	self:SetText(stack and stack > 1 and count)
end


function ns.CreateAuctionQty(parent)
	local qty = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	qty.SetValue = SetValue
	return qty
end
