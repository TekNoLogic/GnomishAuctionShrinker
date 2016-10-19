
local myname, ns = ...


local NUM_ROWS
local noop = function() end


function ns.CreateScrollBar(parent, scrollframe, num_rows)
	NUM_ROWS = num_rows

	local scrollbar = BrowseScrollFrameScrollBar

	scrollbar.RealSetValue = scrollbar.SetValue
	scrollbar.RealSetMinMaxValues = scrollbar.SetMinMaxValues
	scrollbar.RealSetValueStep = scrollbar.SetValueStep
	scrollbar.SetValue = noop
	scrollbar.SetMinMaxValues = noop
	scrollbar.SetValueStep = noop


	scrollbar:SetScript("OnValueChanged", function(self, value, ...)
		ns.SendMessage("SCROLL_VALUE_CHANGE", value)
	end)

	scrollbar:SetScript("OnShow", function()
		local num, total = GetNumAuctionItems("list")
		if total > 0 then
			if num-NUM_ROWS <= 0 then
				scrollbar:Disable()
			else
				scrollbar:Enable()
				scrollbar:RealSetMinMaxValues(0, num-NUM_ROWS)
				scrollbar:RealSetValueStep(1)
			end
		end
	end)


	ns.RegisterCallback(scrollbar, "AUCTION_QUERY_SENT", function(self)
		self:RealSetValue(0)
	end)


	ns.CreateScrollButton(scrollbar, "UP", NUM_ROWS)
	ns.CreateScrollButton(scrollbar, "DOWN", NUM_ROWS)

	return scrollbar
end
