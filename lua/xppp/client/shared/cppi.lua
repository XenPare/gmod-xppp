CPPI = {}

local plMeta = FindMetaTable("Player")
local entMeta = FindMetaTable("Entity")

function CPPI:GetName()
	return "XenPare Prop Protection"
end

function CPPI:GetVersion()
	return "1.0.0"
end

function CPPI:GetInterfaceVersion()
	return "1.0.0"
end

function CPPI:GetNameFromUID(uid)
	local name = ""
	for _, pl in ipairs(player.GetAll()) do
		if pl:UserID() == uid then
			name = pl:Name()
			break
		end
		if pl:SteamID() == uid then
			name = pl:Name()
			break
		end
	end
	return name
end

function plMeta:CPPIGetFriends()
	return {}
end

function entMeta:CPPIGetOwner()
	return self:GetNWEntity("XPPPOwner")
end

if SERVER then
	function entMeta:CPPISetOwner(pl)
		self:GetNWEntity("XPPPOwner", pl)
	end

	function entMeta:CPPISetOwnerUID(uid)
		local sid = ""
		for _, pl in ipairs(player.GetAll()) do
			if pl:UserID() == uid then
				sid = pl:SteamID()
				break
			end
		end
		self:SetNWString("XPPPOwnerID", sid)
	end

	local function canUse(ent, pl)
		local owner = ent:GetNWEntity("XPPPOwner")
		local ownerid = ent:GetNWString("XPPPOwnerID")
		if pl:IsAdmin() then
			return IsValid(owner) or ownerid ~= ""
		else
			return IsValid(owner) and owner == pl
		end
		return true
	end

	function entMeta:CPPICanTool(pl)
		return canUse(self, pl)
	end

	function entMeta:CPPICanPhysgun(pl)
		return canUse(self, pl)
	end

	function entMeta:CPPICanPickup(pl)
		return canUse(self, pl)
	end

	function entMeta:CPPICanPunt(pl)
		return XPPP.CFG.GravGunPuntsEnabled
	end
end