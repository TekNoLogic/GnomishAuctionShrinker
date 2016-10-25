
local myname, ns = ...


local WHICHES = {
	BID_AUCTION = true,
	BUYOUT_AUCTION = true,
}
local function OnShow(self)
	if self.which and WHICHES[self.which] and self:IsShown() then
		ns.SendMessage("_DIALOG_SHOWN")
	end
end


for i=1,STATICPOPUP_NUMDIALOGS do
	_G["StaticPopup"..i]:HookScript("OnShow", OnShow)
end
