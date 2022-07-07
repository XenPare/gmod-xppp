local tag = "XPPP APG"
local cfg = XPPP.CFG

--[[
	OnPhysgunReload
		* Unfreeze protection
]]

hook.Add("OnPhysgunReload", tag, function()
	return false
end)

--[[
	PlayerSpawnProp
		* Distance and blocked model protection
]]

hook.Add("PlayerSpawnProp", tag, function(pl, mdl)
	local pos = pl:GetEyeTrace().HitPos
	if not pl:Alive() or pos:DistToSqr(pl:GetPos()) > 592900 then
		return false
	end

	if cfg.CustomBlockedModels[mdl:lower()] or cfg.CustomBlockedModels[mdl] then
		pl:ChatPrint("This model is blocked!")
		return false
	end

	if cfg.PresetsEnabled and XPPP.BlockedModels[mdl:lower()] then
		return false
	end
end)

--[[
	PhysgunPickup
		* Touch protection
]]

local function unFreeze(ent)
	if ent:GetCollisionGroup() ~= COLLISION_GROUP_NONE then
		return
	end

	ent.LastColor = ent:GetColor()
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
	ent:SetColor(ColorAlpha(color_black, 200))
	ent.XPPPCanUse = false -- thirdparty
end

hook.Add("PhysgunPickup", tag, function(pl, ent)
	local owner = ent:GetNWEntity("XPPPOwner")
	local ownerid = ent:GetNWString("XPPPOwnerID")

	if pl:IsAdmin() then
		if IsValid(owner) or ownerid ~= "" then
			unFreeze(ent)
		else
			return false
		end
	else
		if IsValid(owner) and owner == pl then
			unFreeze(ent)
		else
			return false
		end
	end
end)

--[[
	PhysgunDrop
		* Drop protection
]]

hook.Add("PhysgunDrop", tag, function(pl, ent)
	local owner = ent:GetNWEntity("XPPPOwner")
	local ownerid = ent:GetNWString("XPPPOwnerID")
	local phys = ent:GetPhysicsObject()

	if pl:IsAdmin() then
		if IsValid(owner) or ownerid ~= "" then
			if IsValid(phys) then
				phys:EnableMotion(false)
			end
		else
			return false
		end
	else
		if IsValid(owner) and owner == pl then
			if IsValid(phys) then
				phys:EnableMotion(false)
			end
		else
			return false
		end
	end
end)

--[[
	EntityTakeDamage
		* Damage protection
]]

hook.Add("EntityTakeDamage", tag, function(target, dmg)
	if (dmg:IsDamageType(DMG_CRUSH) or dmg:IsDamageType(DMG_VEHICLE)) and (IsValid(target) and (target:IsPlayer() or target:GetClass():find("prop_"))) then
		return true
	end
end)

--[[
	PlayerSpawnedProp
		* Spawn protection
]]

local blocking = cfg.CustomSpawnBlockingEntities
local function isBlocked(ent)
	local center = ent:LocalToWorld(ent:OBBCenter())
	local bRadius = ent:BoundingRadius()
	for _, v in next, ents.FindInSphere(center, bRadius) do
		local isLivingPlayer = v:IsPlayer() and v:Alive()
		if isLivingPlayer or blocking[v:GetClass()] or XPPP.BlockingEntities[v:GetClass()] then
			local pos = v:GetPos()
			local trace = {start = pos, endpos = pos, filter = v}
			local tr = util.TraceEntity(trace, v)
			if tr.Entity == ent then
				return true
			end
		end
	end
	return false
end

hook.Add("PlayerSpawnedProp", tag, function(pl, mdl, ent)
	if isBlocked(ent) then
		ent.LastColor = ent:GetColor()
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
		ent:SetColor(ColorAlpha(color_black, 200))
		ent.XPPPCanUse = false -- thirdparty
	else
		ent.XPPPCanUse = true -- thirdparty
	end

	-- disable motion
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	-- set owner
	ent:SetNWEntity("XPPPOwner", pl)
	ent:SetNWString("XPPPOwnerID", pl:SteamID())
end)

--[[
	PlayerSpawnedRagdoll
		* Ragdoll spawn protection
]]

hook.Add("PlayerSpawnedRagdoll", tag, function(pl, mdl, ent)
	ent:SetNWEntity("XPPPOwner", pl)
	ent:SetNWString("XPPPOwnerID", pl:SteamID())
end)

--[[
	PlayerSpawnedEffect
		* Effect spawn protection
]]

hook.Add("PlayerSpawnedEffect", tag, function(pl, mdl, ent)
	ent:SetNWEntity("XPPPOwner", pl)
	ent:SetNWString("XPPPOwnerID", pl:SteamID())
end)

--[[
	PlayerSpawnedSENT
		* Entity spawn protection
]]

hook.Add("PlayerSpawnedSENT", tag, function(pl, ent)
	ent:SetNWEntity("XPPPOwner", pl)
	ent:SetNWString("XPPPOwnerID", pl:SteamID())
end)

--[[
	PlayerSpawnedVehicle
		* Vehicle spawn protection
]]

hook.Add("PlayerSpawnedVehicle", tag, function(pl, ent)
	ent:SetNWEntity("XPPPOwner", pl)
	ent:SetNWString("XPPPOwnerID", pl:SteamID())
end)

--[[
	PlayerSpawnedNPC
		* NPC spawn protection
]]

hook.Add("PlayerSpawnedNPC", tag, function(pl, ent)
	ent:SetNWEntity("XPPPOwner", pl)
	ent:SetNWString("XPPPOwnerID", pl:SteamID())
end)

--[[
	OnPhysgunFreeze
		* Freeze protection
]]

hook.Add("OnPhysgunFreeze", tag, function(_, phys, ent, pl)
	if IsValid(pl) and IsValid(ent) and not isBlocked(ent) then
		ent:SetCollisionGroup(COLLISION_GROUP_NONE)
		ent:SetRenderMode(RENDERMODE_NORMAL)
		ent:SetColor(ent.LastColor or color_white)
		ent.XPPPCanUse = true -- thirdparty
	end
end)

--[[
	CanTool
		* Tool protection
]]

hook.Add("CanTool", tag, function(pl, tr, toolname)
	if XPPP.BlockedTools[toolname] or cfg.CustomBlockedTools[toolname] then
		return false
	end

	local ent = tr.Entity
	if not IsValid(ent) then
		return
	end

	if ent:GetNWString("XPPPOwnerID") == "" then
		return false
	end

	local owner = ent:GetNWEntity("XPPPOwner")
	local ownerid = ent:GetNWString("XPPPOwnerID")

	if pl:IsAdmin() then
		return IsValid(owner) or ownerid ~= ""
	else
		return IsValid(owner) and owner == pl
	end
end)

--[[
	PlayerDisconnected
		* Remove abandoned ents
]]

hook.Add("PlayerDisconnected", tag, function(pl)
	local sid = pl:SteamID()
	timer.Create("XPPP Remove Props of " .. sid, cfg.DisconnectedRemovalTimer, 1, function()
		for _, e in ipairs(ents.GetAll()) do
			if e:GetNWString("XPPPOwnerID") == sid then
				e:Remove()
			end
		end
	end)
end)

--[[
	PlayerInitialSpawn
		* Stop the timer and give ownership back
]]

hook.Add("PlayerInitialSpawn", tag, function(pl)
	local sid = pl:SteamID()

	local tname = "XPPP Remove Props of " .. sid
	if timer.Exists(tname) then
		timer.Remove(tname)
	end

	for _, e in ipairs(ents.GetAll()) do
		if e:GetNWString("XPPPOwnerID") == sid then
			e:SetNWEntity("XPPPOwner", pl)
		end
	end
end)