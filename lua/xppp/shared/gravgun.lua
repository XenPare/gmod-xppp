local cfg = XPPP.CFG
local custom_blocked = cfg.CustomGravgunBlockedEntities
hook.Add("GravGunPunt", "XPPP GravGunPunt", function(pl, ent)
	if not cfg.GravGunPuntsEnabled then
		return false
	end

	if custom_blocked[ent:GetClass()] then
		return false
	end
end)