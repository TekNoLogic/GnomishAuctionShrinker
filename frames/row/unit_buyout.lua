
local myname, ns = ...


local function GetUnitBuyout(index)
	local buyout = ns.GetBuyout(index)
	if buyout == 0 then return end

	local _, _, count = GetAuctionItemInfo("list", index)
	return buyout/count
end


local function SetValue(self, index)
	if not index then return self:SetText() end

	local buyout = GetUnitBuyout(index)
	return self:SetText(ns.FormatGold(buyout))
end


function ns.CreateAuctionUnitBuyout(parent)
	local unit = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	unit.SetValue = SetValue
	return unit
end
