
local myname, ns = ...


local callbacks = {}
function ns.RegisterCallback(self, message, func)
	if not callbacks[message] then callbacks[message] = {} end
	callbacks[message][self] = func
end


function ns.SendMessage(message, ...)
	if not callbacks[message] then return end

	for self,func in pairs(callbacks[message]) do
		func(self, message, ...)
	end
end
