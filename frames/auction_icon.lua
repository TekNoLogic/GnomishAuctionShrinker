
local myname, ns = ...


local function ShowBatlePetTooltip(has_cooldown, species_id, ...)
	if species_id and species_id > 0 then
		BattlePetToolTip_Show(species_id, ...)
		return true
	end
end


local indexes = {}
local function OnEnter(self)
	local index = indexes[self]
	if not index then return end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

	if ShowBatlePetTooltip(GameTooltip:SetAuctionItem("list", index)) then
		return
	end

	GameTooltip_ShowCompareItem()

	if IsModifiedClick("DRESSUP") then
		ShowInspectCursor()
	else
		ResetCursor()
	end
end


local function SetValue(self, index)
	indexes[self] = index
	if not index then return self:SetNormalTexture(nil) end

	local _, icon = GetAuctionItemInfo("list", index)
	self:SetNormalTexture(icon)
end


function ns.CreateAuctionIcon(parent)
	local icon = CreateFrame("Button", nil, parent)
	icon:SetScript("OnEnter", OnEnter)
	icon:SetScript("OnLeave", GameTooltip_Hide)
	icon.SetValue = SetValue
	return icon
end
