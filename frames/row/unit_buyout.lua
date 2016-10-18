
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local buyout = ns.GetBuyout(index)

	if buyout > 0 then
		local _, _, count = GetAuctionItemInfo("list", index)
		local item_id = ns.GetAuctionItemID(index)
		local _, _, _, _, _, _, _, stack = GetItemInfo(item_id)
		if stack and stack > 1 then
			return self:SetText(ns.GS(buyout/count))
		end
	end

	self:SetText("----")
end


function ns.CreateAuctionUnitBuyout(parent)
	local unit = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	unit.SetValue = SetValue
	return unit
end
