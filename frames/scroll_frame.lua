
local myname, ns = ...


local BOTTOM_GAP = 25
local NUM_ROWS = 14
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)


local rows = {}
local offset = 0
local function UpdateRows()
	local sorted = ns.GetSortedResults()
	for i,row in ipairs(rows) do
		local index = sorted and sorted[offset + i] or (offset + i)
		row:SetValue(index)
	end
end


local function OnListUpdate()
	ns.MarkSortDirty()
	UpdateRows()
end


local function OnValueChanged(self, value, ...)
	offset = value
	UpdateRows()
end


local function UpdateScrollbar(self)
	local num, total = GetNumAuctionItems("list")
	if total > 0 then
		if num-NUM_ROWS <= 0 then
			self:Disable()
		else
			self:Enable()
			self:SetMinMaxValues(0, num-NUM_ROWS)
		end
	end
end


local function ResetScrollbar(self)
	self:SetValue(0)
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
	scrollbar:SetValueStep(10)


	frame:EnableMouseWheel(true)
	frame:SetScript("OnMouseWheel", function(self, value)
		scrollbar:OnMouseWheel(value)
	end)

	frame:SetScript("OnShow", UpdateRows)
	scrollbar:SetScript("OnShow", UpdateScrollbar)
	scrollbar:SetScript("OnValueChanged", OnValueChanged)

	ns.RegisterCallback(frame, "ANCILLARY_SORT_CHANGED", UpdateRows)
	ns.RegisterCallback(frame, "AUCTION_ITEM_LIST_UPDATE", OnListUpdate)
	ns.RegisterCallback(scrollbar, "AUCTION_ITEM_LIST_UPDATE", UpdateScrollbar)
	ns.RegisterCallback(scrollbar, "AUCTION_QUERY_SENT", ResetScrollbar)


	return frame
end
