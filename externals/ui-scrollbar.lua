
local myname, ns = ...


local BACKDROP = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 12,
	insets = { left = 0, right = 0, top = 5, bottom = 5 }
}


local function Decrement(self)
	self:SetValue(self:GetValue() - self:GetValueStep())
end


local function Increment(self)
	self:SetValue(self:GetValue() + self:GetValueStep())
end


local function OnMouseWheel(self, wheel_value)
	if wheel_value < 0 then Increment(self) else Decrement(self) end
end


local proxies = {}
local function OnMouseWheelProxy(self, ...)
	return OnMouseWheel(proxies[self], ...)
end


local function AttachOnMouseWheel(self, frame)
	proxies[frame] = self
	frame:SetScript("OnMouseWheel", OnMouseWheelProxy)
	frame:EnableMouseWheel(true)
end


local function OnClickUp(self)
	self:GetParent():Decrement()
end


local function OnClickDown(self)
	self:GetParent():Increment()
end


local function Sound()
	PlaySound("UChatScrollButton")
end


local ups, downs = {}, {}
local function UpdateUpDown(self, value)
	local up, down = ups[self], downs[self]
	local min, max = self:GetMinMaxValues()
	if value == min then up:Disable() else up:Enable() end
	if value == max then down:Disable() else down:Enable() end
end


local function OnMinMaxChanged(self, min, max, ...)
	local value = self:GetValue()

	if value > max then
		value = max
		self:SetValue(value)
	end
	if value < min then
		value = min
		self:SetValue(value)
	end

	UpdateUpDown(self, value)

	if self.OnMinMaxChanged then return self:OnMinMaxChanged(min, max, ...) end
end


local function OnValueChanged(self, value, ...)
	UpdateUpDown(self, value)
	if self.OnValueChanged then return self:OnValueChanged(value, ...) end
end


local OriginalSetScript
local function SetScript(self, script, handler)
	local existing = self:GetScript(script)
	if existing then error("Cannot override ".. script) end
	OriginalSetScript(self, script, handler)
end


function ns.CreateScrollBar(parent)
	local slider = CreateFrame("Slider", nil, parent)
	slider:SetWidth(16)

	OriginalSetScript = slider.SetScript
	slider.SetScript = SetScript
	slider.Decrement = Decrement
	slider.Increment = Increment
	slider.OnMouseWheel = OnMouseWheel
	slider.AttachOnMouseWheel = AttachOnMouseWheel

	slider:EnableMouseWheel(true)
	slider:SetScript("OnMouseWheel", OnMouseWheel)

	local up = CreateFrame("Button", nil, slider)
	up:SetPoint("BOTTOM", slider, "TOP")
	up:SetSize(16, 16)
	up:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
	up:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
	up:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
	up:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight")

	up:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	up:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	up:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	up:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	up:GetHighlightTexture():SetBlendMode("ADD")

	up:SetScript("OnClick", OnClickUp)
	up:SetScript("PostClick", Sound)

	ups[slider] = up

	local down = CreateFrame("Button", nil, slider)
	down:SetPoint("TOP", slider, "BOTTOM")
	down:SetSize(16, 16)
	down:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
	down:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
	down:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
	down:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight")

	down:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	down:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	down:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	down:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	down:GetHighlightTexture():SetBlendMode("ADD")

	down:SetScript("OnClick", OnClickDown)
	down:SetScript("PostClick", Sound)

	downs[slider] = down

	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	local thumb = slider:GetThumbTexture()
	thumb:SetSize(16, 24)
	thumb:SetTexCoord(1/4, 3/4, 1/8, 7/8)

	slider:SetScript("OnMinMaxChanged", OnMinMaxChanged)
	slider:SetScript("OnValueChanged", OnValueChanged)

	slider:SetMinMaxValues(0, 0)
	slider:SetValueStep(1)
	slider:SetValue(0)

	local border = CreateFrame("Frame", nil, slider)
	border:SetPoint("TOPLEFT", up, -5, 5)
	border:SetPoint("BOTTOMRIGHT", down, 5, -3)
	border:SetBackdrop(BACKDROP)
	local color = TOOLTIP_DEFAULT_COLOR
	border:SetBackdropBorderColor(color.r, color.g, color.b, 0.5)

	return slider, up, down, border
end
