
local myname, ns = ...


local frames = {}
function ns.MixinPendingQuery(frame)
	frames[frame] = true
end


local all_scan
local watcher = CreateFrame("Frame")
watcher:Hide()


watcher:SetScript("OnUpdate", function(self)
	if not CanSendAuctionQuery("list") then return end

	for frame in pairs(frames) do
		if frame.OnQueryComplete then frame:OnQueryComplete(all_scan) end
	end
	self:Hide()
end)


hooksecurefunc("QueryAuctionItems", function(_, _, _, _, _, _, get_all)
	all_scan = get_all
	for frame in pairs(frames) do
		if frame.OnQuerySent then frame:OnQuerySent(all_scan) end
	end
	if not all_scan then watcher:Show() end
end)
