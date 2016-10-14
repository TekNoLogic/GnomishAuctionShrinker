
local myname, ns = ...


local HEIGHT = 19
local TEXTURE = "Interface\\FriendsFrame\\WhoFrame-ColumnTabs"
local HIGHLIGHT = "Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight"


local sorts = {}
local function GetSort(self)
	return sorts[self]
end


local arrows = {}
local function SetSort(self, sort)
	local arrow = arrows[self]
	sorts[self] = sort

	if sort == "ASC" then
		arrow:Show()
		arrow:SetTexCoord(0, 9/16, 0, 1)
	elseif sort == "DESC" then
		arrow:Show()
		arrow:SetTexCoord(0, 9/16, 1, 0)
	else
		arrow:Hide()
	end
end


local function OnClick(self)
	local sort = sorts[self]
	if sort == "ASC" then
		self:SetSort("DESC")
	else
		self:SetSort("ASC")
	end
end


function ns.NewColumnHeader(parent)
	local butt = CreateFrame("Button", nil, parent)
	butt:SetHeight(HEIGHT)

	butt:SetNormalFontObject(GameFontHighlightSmall)
	butt:SetText(" ") -- Force fontstring to generate

	local fs = butt:GetFontString()
	fs:ClearAllPoints()
	fs:SetPoint("LEFT", butt, "LEFT", 8, 0)

	local left = butt:CreateTexture(nil, "BACKGROUND")
	left:SetWidth(5)
	left:SetPoint("TOPLEFT")
	left:SetPoint("BOTTOMLEFT")
	left:SetTexture(TEXTURE)
	left:SetTexCoord(0, 5/64, 0, 38/64)

	local right = butt:CreateTexture(nil, "BACKGROUND")
	right:SetWidth(4)
	right:SetPoint("TOPRIGHT")
	right:SetPoint("BOTTOMRIGHT")
	right:SetTexture(TEXTURE)
	right:SetTexCoord(58/64, 62/64, 0, 38/64)

	local middle = butt:CreateTexture(nil, "BACKGROUND")
	middle:SetPoint("TOPLEFT", left, "TOPRIGHT")
	middle:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT")
	middle:SetTexture(TEXTURE)
	middle:SetTexCoord(5/64, 58/64, 0, 38/64)

	local arrow = butt:CreateTexture()
	arrow:ClearAllPoints()
	arrow:SetPoint("LEFT", fs, "RIGHT", 0, -2)
	arrow:SetSize(9, 8)
	arrow:SetTexture("Interface\\Buttons\\UI-SortArrow")
	arrow:SetTexCoord(0, 9/16, 0, 1)
	arrow:Hide()
	arrows[butt] = arrow

	butt:SetHighlightTexture(HIGHLIGHT, "ADD")
	local highlight = butt:GetHighlightTexture()
	highlight:ClearAllPoints()
	highlight:SetPoint("LEFT")
	highlight:SetPoint("RIGHT")
	highlight:SetHeight(24)

	butt.GetSort = GetSort
	butt.SetSort = SetSort
	butt:SetScript("OnClick", OnClick)

	return butt
end
