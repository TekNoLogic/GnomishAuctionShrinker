
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
	self.qty:SetText()
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

	local buyout = ns.GetBuyout(self.index)
	if CanBuyout(self.index) then
		buybutt:Enable()
		AuctionFrame.buyoutPrice = buyout
	end
end


local function SetSelected(self)
	selected_index = self.index
	SetSelectedAuctionItem("list", self.index)
	for frame in pairs(rows) do RefreshSelected(frame) end
end


local function SetValue(self, index)
	self.index = index

	local name, _, count = GetAuctionItemInfo("list", index)
	local item_id = ns.GetAuctionItemID(index)

	if not (name and item_id) then return self:Disable() end

	for frame in pairs(children[self]) do frame:SetValue(index) end
	RefreshSelected(self)

	local _, _, _, _, _, _, _, stack = GetItemInfo(item_id)
	stack = stack or 1

	self.qty:SetText(stack > 1 and count)
	self:Enable()
end


function ns.CreateAuctionRow(parent)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(ROW_HEIGHT)
	row:SetScript("OnClick", OnClick)
	row:SetScript("OnMouseWheel", OnMouseWheel)
	row:EnableMouseWheel(true)
	row:Disable()

	row.SetSelected = SetSelected
	row.SetValue = SetValue

	row:SetHighlightTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
	row:GetHighlightTexture():SetTexCoord(0, 1, 0, 0.578125)

	rows[row] = true

	local kids = {}
	children[row] = kids

	local icon = ns.CreateAuctionIcon(row)
	icon:SetSize(ROW_HEIGHT-2, ROW_HEIGHT-2)
	icon:SetPoint("LEFT", row, TEXT_GAP, 0)
	row.icon = icon
	kids[icon] = true

	local name = ns.CreateAuctionName(row)
	name:SetSize(155, ROW_HEIGHT)
	name:SetPoint("LEFT", icon, "RIGHT", TEXT_GAP, 0)
	name:SetJustifyH("LEFT")
	row.name = name
	kids[name] = true

	local min = ns.CreateAuctionReqLevel(row)
	min:SetWidth(23)
	min:SetPoint("LEFT", name, "RIGHT", TEXT_GAP, 0)
	min:SetJustifyH("RIGHT")
	row.min = min
	kids[min] = true

	local ilvl = ns.CreateAuctionIlevel(row)
	ilvl:SetWidth(33)
	ilvl:SetPoint("LEFT", min, "RIGHT", TEXT_GAP, 0)
	ilvl:SetJustifyH("RIGHT")
	row.ilvl = ilvl
	kids[ilvl] = true

	local owner = ns.CreateAuctionSeller(row)
	owner:SetWidth(75) owner:SetHeight(ROW_HEIGHT)
	owner:SetPoint("LEFT", ilvl, "RIGHT", TEXT_GAP, 0)
	owner:SetJustifyH("RIGHT")
	row.owner = owner
	kids[owner] = true

	local timeleft = ns.CreateAuctionTimeLeft(row)
	timeleft:SetWidth(45)
	timeleft:SetPoint("LEFT", owner, "RIGHT", TEXT_GAP, 0)
	timeleft:SetJustifyH("RIGHT")
	row.timeleft = timeleft
	kids[timeleft] = true

	local bid = ns.CreateAuctionBid(row)
	bid:SetWidth(65)
	bid:SetPoint("LEFT", timeleft, "RIGHT", TEXT_GAP, 0)
	bid:SetJustifyH("RIGHT")
	row.bid = bid
	kids[bid] = true

	local buyout = ns.CreateAuctionBuyout(row)
	buyout:SetWidth(65)
	buyout:SetPoint("LEFT", bid, "RIGHT", TEXT_GAP, 0)
	buyout:SetJustifyH("RIGHT")
	row.buyout = buyout
	kids[buyout] = true

	local unit = ns.CreateAuctionUnitBuyout(row)
	unit:SetWidth(65)
	unit:SetPoint("LEFT", buyout, "RIGHT", TEXT_GAP, 0)
	unit:SetJustifyH("RIGHT")
	row.unit = unit
	kids[unit] = true

	local qty = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	qty:SetWidth(23)
	qty:SetPoint("LEFT", unit, "RIGHT", TEXT_GAP, 0)
	qty:SetJustifyH("RIGHT")
	row.qty = qty

	return row
end
