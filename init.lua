
local myname, ns = ...


ns.RegisterCallback("_THIS_ADDON_LOADED", function()
  ns.CreatePanel()

  for i,v in pairs(ns) do
    if i:match("^Create") then ns[i] = nil end
  end
end)
