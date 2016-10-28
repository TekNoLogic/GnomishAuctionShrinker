
local myname, ns = ...


local BOTTOM_GAP = 25
local NUM_ROWS = 14
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)


local rows = {}
local offset = 0
local function UpdateRows()
	for i,row in ipairs(rows) do row:SetValue(offset + i) end
end


local function OnQuerySent(self, mesage, all_scan)
	if not all_scan then return end
	for _,row in pairs(rows) do row:Hide() end
end


local function OnValueChanged(self, value)
	offset = value
	UpdateRows()
end


local dirty
local function UpdateScrollbar(self)
	if dirty then self:SetValue(0) end
	dirty = false

	local num_results = GetNumAuctionItems("list")
	self:SetMinMaxValues(0, math.max(0, num_results - NUM_ROWS))
end


local function ResetScrollbar(self)
	dirty = true
end


function ns.CreateScrollFrame(parent, columns)
	local frame = CreateFrame("Frame", nil, parent)


	for i=1,NUM_ROWS do
		local row = ns.CreateAuctionRow(frame, columns)
		row:SetHeight(ROW_HEIGHT)
		row:SetPoint("LEFT")
		row:SetPoint("RIGHT")
		if i == 1 then row:SetPoint("TOP")
		else row:SetPoint("TOP", rows[i-1], "BOTTOM") end
		rows[i] = row
	end


	local scrollbar = ns.CreateScrollBar(frame)
	scrollbar:SetPoint("TOP", 0, -20)
	scrollbar:SetPoint("BOTTOM", 0, 18)
	scrollbar:SetPoint("LEFT", frame, "RIGHT", 9, 0)
	scrollbar:SetValueStep(7)
	scrollbar:SetStepsPerPage(2)
	scrollbar:AttachOnMouseWheel(frame)

	scrollbar.OnValueChanged = OnValueChanged


	frame:SetScript("OnShow", UpdateRows)
	scrollbar:SetScript("OnShow", UpdateScrollbar)


	ns.RegisterCallback(frame, "_AUCTION_ITEM_LIST_UPDATE", UpdateRows)
	ns.RegisterCallback(frame, "_AUCTION_QUERY_SENT", OnQuerySent)
	ns.RegisterCallback(scrollbar, "_AUCTION_ITEM_LIST_UPDATE", UpdateScrollbar)
	ns.RegisterCallback(scrollbar, "_AUCTION_QUERY_SENT", ResetScrollbar)


	return frame
end
