
local myname, ns = ...


local function OnShow(self)
	local self = self:GetParent()
	if self.which == "BUYOUT_AUCTION" and self:IsShown() then
		BrowseBuyoutButton:Disable()
	end
end


for i=1,STATICPOPUP_NUMDIALOGS do
	_G["StaticPopup"..i]:HookScript("OnShow", OnShow)
end


ns.RegisterCallback(BrowseBuyoutButton, "SELECTION_CHANGED", function(self, message, index)
	if not index then return self:Disable() end
	self:SetEnabled(ns.CanBuyout(index))
end)
