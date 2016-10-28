
local myname, ns = ...


function ns.FormatGold(cash)
	if (cash or 0) <= 0 then return "----" end

	cash = math.ceil(cash)
	if cash > 5000 then return ns.GS(cash) end
	return ns.GSC(cash)
end
