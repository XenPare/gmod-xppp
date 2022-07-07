CPPI = {}

local pl = FindMetaTable("Player")
local ent = FindMetaTable("Entity")

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

function pl:CPPIGetFriends()
	return {}
end

function ent:CPPIGetOwner()
	return self:GetNWEntity("XPPPOwner")
end

if SERVER then
	function ent:CPPISetOwner(pl)
		self:GetNWEntity("XPPPOwner", pl)
	end

	function ent:CPPISetOwnerUID(uid)
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

	function ent:CPPICanTool(pl)
		return canUse(self, pl)
	end

	function ent:CPPICanPhysgun(pl)
		return canUse(self, pl)
	end

	function ent:CPPICanPickup(pl)
		return canUse(self, pl)
	end

	function ent:CPPICanPunt(pl)
		return XPPP.CFG.GravGunPuntsEnabled
	end
end