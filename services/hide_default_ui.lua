
local myname, ns = ...


local function Hide(frame)
	frame:Hide()
	frame.Show = frame.Hide
end


for i=1,8 do Hide(_G["BrowseButton"..i]) end

Hide(BrowseCurrentBidSort)
Hide(BrowseDurationSort)
Hide(BrowseHighBidderSort)
Hide(BrowseLevelSort)
Hide(BrowseNextPageButton)
Hide(BrowsePrevPageButton)
Hide(BrowseQualitySort)
Hide(BrowseScrollFrameScrollBar)
Hide(BrowseScrollFrameScrollBarScrollDownButton)
Hide(BrowseScrollFrameScrollBarScrollUpButton)
Hide(BrowseSearchCountText)

-- Disable updates on default panel
AuctionFrameBrowse:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
