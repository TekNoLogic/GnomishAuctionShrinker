
local myname, ns = ...


local function Hide(frame)
	frame:Hide()
	frame.Show = frame.Hide
end


for i=1,8 do Hide(_G["BrowseButton"..i]) end

Hide(BrowseQualitySort)
Hide(BrowseLevelSort)
Hide(BrowseHighBidderSort)
Hide(BrowseDurationSort)
Hide(BrowseCurrentBidSort)


-- Disable updates on default panel
AuctionFrameBrowse:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
