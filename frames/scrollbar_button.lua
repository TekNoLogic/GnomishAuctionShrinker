
local myname, ns = ...


local NUM_ROWS


local directions = {}
local scrollbar
local function OnClick(self)
	local direction = directions[self]
	local step = 10
	if direction == "UP" then step = -10 end
	scrollbar:RealSetValue(scrollbar:GetValue() + step)
	PlaySound("UChatScrollButton")
end


local function OnScrollValueChanged(self, value)
	local direction = directions[self]
	local min, max = scrollbar:GetMinMaxValues()
	local test_value = max
	if direction == "UP" then test_value = min end
	butt:SetEnabled(value ~= test_value)
end


local function OnShow(self)
	local num, total = GetNumAuctionItems("list")
	if total > 0 and num >= NUM_ROWS then self:Disable() end
end


function ns.CreateScrollButton(parent, direction, num_rows)
	NUM_ROWS = num_rows
	scrollbar = parent

	local butt
	if direction == "UP" then
		butt = BrowseScrollFrameScrollBarScrollUpButton
	else
		butt = BrowseScrollFrameScrollBarScrollDownButton
	end
	directions[butt] = direction

	butt:SetScript("OnClick", OnClick)
	butt:SetScript("OnShow", OnShow)

	ns.RegisterCallback(butt, "SCROLL_VALUE_CHANGE", OnScrollValueChanged)

	return butt
end
