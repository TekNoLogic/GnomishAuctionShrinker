
local myname, ns = ...


local TIMEFRAMES = {"<30m", "30m-2h", "2-12hr", ">12hr"}
local function SetValue(self, index)
	if not index then return self:SetText(nil) end

	local duration = GetAuctionItemTimeLeft("list", index)
	self:SetText(TIMEFRAMES[duration])
end


function ns.CreateItemTimeLeft(parent)
	local time = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	time.SetValue = SetValue
	return time
end
