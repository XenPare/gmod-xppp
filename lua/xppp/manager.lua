local cfg = XPPP.CFG

--[[
	CPPI
]]

AddCSLuaFile("shared/cppi.lua")
include("shared/cppi.lua")

--[[
	HUD
]]

if cfg.HUDEnabled then
	AddCSLuaFile("client/hud.lua")
	if CLIENT then
		include("client/hud.lua")
	end
end

--[[
	Gravity Gun
]]

AddCSLuaFile("shared/gravgun.lua")
include("shared/gravgun.lua")

--[[
	Commands
]]

if SERVER then
	include("server/cmds.lua")
end

--[[
	APG
]]

if cfg.APGEnabled then
	if SERVER then
		include("server/apg.lua")
	end
end

--[[
	Presets
]]

XPPP.BlockedModels = {}
XPPP.BlockedTools = {}
XPPP.BlockingEntities = {}

if cfg.PresetsEnabled then
	local gm = engine.ActiveGamemode()

	local fs = file.Find("xppp/presets/*", "LUA")
	for _, fl in ipairs(fs) do
		AddCSLuaFile("presets/" .. fl)
	end

	-- load blocked stuff
	local tbl = include("presets/" .. gm .. ".lua") or {}
	if not table.IsEmpty(tbl) then
		-- add blocked models
		if tbl.models then
			XPPP.BlockedModels = tbl.models
		end

		-- add blocked tools
		if tbl.tools then
			XPPP.BlockedTools = tbl.tools
		end

		-- add blocking entities
		if tbl.blockingents then
			XPPP.BlockingEntities = tbl.blockingents
		end

		AddCSLuaFile("client/spawnmenu.lua")
		if CLIENT then
			include("client/spawnmenu.lua")
		end
	end
end