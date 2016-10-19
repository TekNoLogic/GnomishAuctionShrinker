
local myname, ns = ...


local BOTTOM_GAP = 25
local NUM_ROWS = 14
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)


local rows = {}
local offset = 0
local function Update()
	local sorted = ns.GetSortedResults()
	for i,row in ipairs(rows) do
		local index = sorted and sorted[offset + i] or (offset + i)
		row:SetValue(index)
	end
end


local function SetOffset(value)
	offset = value
	Update()
end


function ns.CreateScrollFrame(parent, columns)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetAllPoints()

	frame.SetOffset = SetOffset
	frame.Update = Update

	frame:SetScript("OnEvent", function()
		ns.MarkSortDirty()
		Update()
	end)
	frame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")

	frame:SetScript("OnShow", Update)

	ns.RegisterCallback(frame, "ANCILLARY_SORT_CHANGED", Update)
	ns.RegisterCallback(frame, "AUCTION_QUERY_SENT", function(self, message, all_scan)
		if all_scan then
			self:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
		else
			self:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
		end
	end)


	for i=1,NUM_ROWS do
		local row = ns.CreateAuctionRow(frame, columns)
		row:SetHeight(ROW_HEIGHT)
		row:SetPoint("LEFT")
		row:SetPoint("RIGHT")
		if i == 1 then row:SetPoint("TOP")
		else row:SetPoint("TOP", rows[i-1], "BOTTOM") end
		rows[i] = row
	end

	return frame
end
