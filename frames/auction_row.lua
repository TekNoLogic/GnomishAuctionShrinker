
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
		HandleModifiedItemClick(self.link)
	else
		if GetCVarBool("auctionDisplayOnCharacter") then DressUpItemLink(self.link) end
		self:SetSelected()
		CloseAuctionStaticPopups() -- Close any auction related popups
	end
end


local children = {}
local function OnDisable(self)
	for frame in pairs(children[self]) do frame:SetValue() end
	self.min:SetText()
	self.owner:SetText()
	self.qty:SetText()
	self.index = nil
	self.link = nil
end


local selected_index
local rows = {}
local function RefreshSelected(self)
	if selected_index ~= self.index then return self:UnlockHighlight() end

	self:LockHighlight()

	-- Set bid
	MoneyInputFrame_SetCopper(BrowseBidPrice, ns.GetRequiredBid(self.index))
	if not highBidder and owner ~= UnitName("player") and GetMoney() >= MoneyInputFrame_GetCopper(BrowseBidPrice) and MoneyInputFrame_GetCopper(BrowseBidPrice) <= MAXIMUM_BID_PRICE then bidbutt:Enable() end

	if buyoutPrice > 0 and buyoutPrice >= minBid then
		if GetMoney() >= buyoutPrice or (highBidder and GetMoney()+bidAmount >= buyoutPrice) then
			buybutt:Enable()
			AuctionFrame.buyoutPrice = buyoutPrice
		end
	end
end


local function SetSelected(self)
	selected_index = self.index
	SetSelectedAuctionItem("list", self.index)
	for frame in pairs(rows) do RefreshSelected(frame) end
end


local function SetValue(self, index)
	self.index = index

	for frame in pairs(children[self]) do frame:SetValue(index) end
	RefreshSelected(self)

	local name, texture, count, quality, canUse, level, levelColHeader, minBid,
				minIncrement, buyoutPrice, bidAmount, highBidder, bidderFullName, owner,
				ownerFullName, saleStatus, itemId, hasAllInfo = GetAuctionItemInfo("list", index)
	local displayedBid = bidAmount == 0 and minBid or bidAmount
	if displayedBid == buyoutPrice then displayedBid = nil end
	local required_bid = bidAmount == 0 and minBid or bidAmount + minIncrement

	-- Lie about our buyout price
	if required_bid >= MAXIMUM_BID_PRICE then buyoutPrice = required_bid end


	if not (name and itemId) then return self:Disable() end

	local color = ITEM_QUALITY_COLORS[quality] or ITEM_QUALITY_COLORS[1]
	local link = GetAuctionItemLink("list", index)
	local _, _, _, _, _, _, _, maxStack = GetItemInfo(itemId)
	maxStack = maxStack or 1

	self.link = link
	self.required_bid = required_bid

	self.min:SetText(level ~= 1 and level)
	self.owner:SetText(owner)
	self.qty:SetText(maxStack > 1 and count)
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

	local min = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	min:SetWidth(23)
	min:SetPoint("LEFT", name, "RIGHT", TEXT_GAP, 0)
	min:SetJustifyH("RIGHT")
	row.min = min

	local ilvl = ns.CreateAuctionIlevel(row)
	ilvl:SetWidth(33)
	ilvl:SetPoint("LEFT", min, "RIGHT", TEXT_GAP, 0)
	ilvl:SetJustifyH("RIGHT")
	row.ilvl = ilvl
	kids[ilvl] = true

	local owner = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	owner:SetWidth(75) owner:SetHeight(ROW_HEIGHT)
	owner:SetPoint("LEFT", ilvl, "RIGHT", TEXT_GAP, 0)
	owner:SetJustifyH("RIGHT")
	row.owner = owner

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
