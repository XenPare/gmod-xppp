local tag = "XPPP Spawnmenu"
local cfg = XPPP.CFG

hook.Add("PopulateContent", tag, function()
	for k, v in pairs(spawnmenu.GetPropTable()) do
		for _k, _v in pairs(v.contents) do
			if _v.model and (XPPP.BlockedModels[_v.model:lower()] or cfg.CustomBlockedModels[_v.model:lower()]) then
				spawnmenu.GetPropTable()[k].contents[_k] = nil
			end
		end
	end
end)

hook.Add("PreReloadToolsMenu", tag, function()
	local tools = weapons.GetStored("gmod_tool").Tool
	for name in pairs(tools) do
		if XPPP.BlockedTools[name] or cfg.CustomBlockedTools[name] then
			tools[name].AddToMenu = false
		end
	end
end)

hook.Add("PopulateToolMenu", tag, function()
	local tabs = spawnmenu.GetToolMenu("Main")
	for tab in ipairs(tabs) do
		if #tabs[tab] == 0 then
			tabs[tab] = nil
		end
	end
end)