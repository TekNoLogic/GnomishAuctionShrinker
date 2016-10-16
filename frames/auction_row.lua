
local myname, ns = ...


local BUYOUT_LIMIT = 800 * 100 * 100 -- 800g
local NUM_ROWS, BOTTOM_GAP = 14, 25
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)
local TEXT_GAP = 4


local bidbutt, buybutt = BrowseBidButton, BrowseBuyoutButton

local scrollbar = BrowseScrollFrameScrollBar

local Update
local function OnMouseWheel(self, value) scrollbar:RealSetValue(scrollbar:GetValue() - value*10) end
local function OnClick(self)
	if IsAltKeyDown() then
		self:SetSelected()
		local _, _, _, _, _, _, _, _, _, buyout = GetAuctionItemInfo("list", self.index)

		if buyout > BUYOUT_LIMIT then
			AuctionFrame.buyoutPrice = buyout
			StaticPopup_Show("BUYOUT_AUCTION")
			BrowseBuyoutButton:Disable()
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


local children = {}
local function OnDisable(self)
	for frame in pairs(children[self]) do frame:SetValue() end
	self.index = nil
end


local function CanBid(index)
	local bid = ns.GetRequiredBid(index)
	if bid > MAXIMUM_BID_PRICE then return false end

	local _, _, _, _, _, _, _, _, _, _, _, is_high_bidder, _, seller =
		GetAuctionItemInfo("list", index)
	if is_high_bidder then return false end
	if seller == UnitName("player") then return false end
	if GetMoney() < bid then return false end

	return true
end


local function CanBuyout(index)
	local buyout = ns.GetBuyout(index)
	if buyout == 0 then return false end
	if GetMoney() < buyout then return false end

	local bid = ns.GetRequiredBid(index)
	if bid > buyout then return false end

	local _, _, _, _, _, _, _, _, _, _, high_bid, is_high_bidder =
		GetAuctionItemInfo("list", index)
	if is_high_bidder and (GetMoney() + high_bid) < buyout then return false end

	return true
end


local selected_index
local rows = {}
local function RefreshSelected(self)
	if selected_index ~= self.index then return self:UnlockHighlight() end

	self:LockHighlight()

	-- Set bid
	MoneyInputFrame_SetCopper(BrowseBidPrice, ns.GetRequiredBid(self.index))
	if CanBid(self.index) then bidbutt:Enable() end

	if CanBuyout(self.index) then
		local buyout = ns.GetBuyout(self.index)
		AuctionFrame.buyoutPrice = buyout
		buybutt:Enable()
	end
end


local function SetSelected(self)
	selected_index = self.index
	SetSelectedAuctionItem("list", self.index)
	for frame in pairs(rows) do RefreshSelected(frame) end
end


local function SetValue(self, index)
	self.index = index
	if not index then return self:Disable() end

	local name = GetAuctionItemInfo("list", index)
	local item_id = ns.GetAuctionItemID(index)

	if not (name and item_id) then return self:Disable() end

	self:Enable()

	for frame in pairs(children[self]) do frame:SetValue(index) end
	RefreshSelected(self)
end


local function AnchorCell(cell, column, row)
	cell:SetPoint("TOP", row)
	cell:SetPoint("BOTTOM", row)
	cell:SetPoint("LEFT", column, TEXT_GAP/2, 0)
	cell:SetPoint("RIGHT", column, -TEXT_GAP/2, 0)
end


function ns.CreateAuctionRow(parent, columns)
	local row = CreateFrame("Button", nil, parent)
	row:Disable()

	row:SetHeight(ROW_HEIGHT)
	row:SetScript("OnClick", OnClick)
	row:SetScript("OnDisable", OnDisable)
	row:SetScript("OnMouseWheel", OnMouseWheel)
	row:EnableMouseWheel(true)

	row.SetSelected = SetSelected
	row.SetValue = SetValue

	row:SetHighlightTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
	row:GetHighlightTexture():SetTexCoord(0, 1, 0, 0.578125)

	rows[row] = true

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
