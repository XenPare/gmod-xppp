XPPP.CFG = XPPP.CFG or {}

--[[
	Other
]]

-- how long the server will be waiting for the comeback of the owner
-- number
XPPP.CFG.DisconnectedRemovalTimer = 180

-- if darkrp and sandbox will use different blocked lists
-- true/false
XPPP.CFG.PresetsEnabled = true

-- if anti prop grief will be enabled
-- true/false
XPPP.CFG.APGEnabled = true

-- if hud should draw
-- true/false
XPPP.CFG.HUDEnabled = true

-- custom blocked models
-- use lower
-- ["models/example.mdl"] = true
XPPP.CFG.CustomBlockedModels = {}

-- custom blocked tools
-- use lower
-- ["exampletool"] = true
XPPP.CFG.CustomBlockedTools = {}

-- custom entities that will prevent players from freezing props in themselves
-- use lower
-- ["ent_example"] = true
XPPP.CFG.CustomSpawnBlockingEntities = {}

--[[
	Gravity Gun
]]

-- if players can punt entities with gravgun
-- true/false
XPPP.CFG.GravGunPuntsEnabled = true

-- custom entities that won't be punted away with gravgun
-- use lower
-- ["ent_example"] = true
XPPP.CFG.CustomGravgunBlockedEntities = {}
