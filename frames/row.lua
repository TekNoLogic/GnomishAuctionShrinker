
local myname, ns = ...


local BUYOUT_LIMIT = 800 * 100 * 100 -- 800g
local PADDING = 2


local function OnClick(self)
	if IsAltKeyDown() then
		self:SetSelected()
		local _, _, _, _, _, _, _, _, _, buyout = GetAuctionItemInfo("list", self.index)

		if buyout > BUYOUT_LIMIT then
			AuctionFrame.buyoutPrice = buyout
			StaticPopup_Show("BUYOUT_AUCTION")
			return
		end

		PlaceAuctionBid("list", self.index, buyout)
		CloseAuctionStaticPopups()
	elseif IsModifiedClick() then
		HandleModifiedItemClick(GetAuctionItemLink("list", self.index))
	else
		if GetCVarBool("auctionDisplayOnCharacter") then
			DressUpItemLink(GetAuctionItemLink("list", self.index))
		end
		self:SetSelected()
		CloseAuctionStaticPopups() -- Close any auction related popups
	end
end


local function OnHide(self)
	self.index = nil
end


local function OnQuerySent(self, all_scan)
	if all_scan then self:Disable() end
end


local function OnSelectionChanged(self, message, index)
	if index and index == self.index then
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end
end


local function SetSelected(self)
	SetSelectedAuctionItem("list", self.index)
end


local children = {}
local function SetValue(self, index)
	if not index then return self:Hide() end

	self.index = index
	for frame in pairs(children[self]) do frame:SetValue(index) end

	local name = GetAuctionItemInfo("list", index)
	local item_id = ns.GetAuctionItemID(index)

	if not (name and item_id) then return self:Hide() end

	OnSelectionChanged(self, nil, ns.GetSelectedAuction())
	self:Enable()
	self:Show()
end


local function AnchorCell(cell, column, row)
	cell:SetPoint("TOP", row)
	cell:SetPoint("BOTTOM", row)
	cell:SetPoint("LEFT", column, PADDING, 0)
	cell:SetPoint("RIGHT", column, -PADDING, 0)
end


function ns.CreateAuctionRow(parent, columns)
	local row = CreateFrame("Button", nil, parent)
	row:Disable()

	row:SetScript("OnClick", OnClick)
	row:SetScript("OnHide", OnHide)

	row.SetSelected = SetSelected
	row.SetValue = SetValue

	row:SetHighlightTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
	row:GetHighlightTexture():SetTexCoord(0, 1, 0, 0.578125)

	ns.RegisterCallback(row, "_AUCTION_QUERY_SENT", OnQuerySent)
	ns.RegisterCallback(row, "_SELECTION_CHANGED", OnSelectionChanged)

	local kids = {}
	children[row] = kids

	local item = ns.CreateAuctionItem(row)
	AnchorCell(item, columns[1], row)
	row.item = item
	kids[item] = true

	local min = ns.CreateAuctionReqLevel(row)
	AnchorCell(min, columns[2], row)
	min:SetJustifyH("RIGHT")
	row.min = min
	kids[min] = true

	local ilvl = ns.CreateAuctionIlevel(row)
	AnchorCell(ilvl, columns[3], row)
	ilvl:SetJustifyH("RIGHT")
	row.ilvl = ilvl
	kids[ilvl] = true

	local owner = ns.CreateAuctionSeller(row)
	AnchorCell(owner, columns[4], row)
	owner:SetJustifyH("RIGHT")
	row.owner = owner
	kids[owner] = true

	local timeleft = ns.CreateAuctionTimeLeft(row)
	AnchorCell(timeleft, columns[5], row)
	timeleft:SetJustifyH("RIGHT")
	row.timeleft = timeleft
	kids[timeleft] = true

	local bid = ns.CreateAuctionBid(row)
	AnchorCell(bid, columns[6], row)
	bid:SetJustifyH("RIGHT")
	row.bid = bid
	kids[bid] = true

	local buyout = ns.CreateAuctionBuyout(row)
	AnchorCell(buyout, columns[7], row)
	buyout:SetJustifyH("RIGHT")
	row.buyout = buyout
	kids[buyout] = true

	local unit = ns.CreateAuctionUnitBuyout(row)
	AnchorCell(unit, columns[8], row)
	unit:SetJustifyH("RIGHT")
	row.unit = unit
	kids[unit] = true

	local qty = ns.CreateAuctionQty(row)
	AnchorCell(qty, columns[9], row)
	qty:SetJustifyH("RIGHT")
	row.qty = qty
	kids[qty] = true

	return row
end
