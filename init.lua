
local myname, ns = ...


function ns.OnLoad()
  for i,v in pairs(ns) do
    if i:match("^Create") then ns[i] = nil end
  end
end