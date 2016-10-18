
local myname, ns = ...


local butt = BrowseBuyoutButton
local function OnShow(self)
	local self = self:GetParent()
	if self.which == "BUYOUT_AUCTION" and self:IsShown() then
		butt:Disable()
	end
end


for i=1,STATICPOPUP_NUMDIALOGS do
	_G["StaticPopup"..i]:HookScript("OnShow", OnShow)
end


ns.RegisterCallback(butt, "SELECTION_CHANGED", function(self, message, index)
	if not index then return self:Disable() end

	if ns.CanBuyout(index) then
		self:Enable()
		AuctionFrame.buyoutPrice = ns.GetBuyout(index)
	else
		self:Disable()
	end
end)
