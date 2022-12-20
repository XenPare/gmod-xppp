--[[
	Clear disconnected props
]]

concommand.Add("xppc_clear_disconnected", function(pl)
	if IsValid(pl) and not pl:IsAdmin() then
		return
	end

	for _, e in ipairs(ents.GetAll()) do
		local sid = e:GetNWString("XPPPOwnerID")
		if sid ~= "" and not IsValid(e:GetNWEntity("XPPPOwner")) then
			local tname = "XPPP Remove Props of " .. sid
			if timer.Exists(tname) then
				timer.Remove(tname)
			end
			e:Remove()
		end
	end
end)

--[[
	Clear players' props and other stuff
]]

concommand.Add("xppc_clear_all", function(pl)
	if IsValid(pl) and not pl:IsAdmin() then
		return
	end

	for _, e in ipairs(ents.GetAll()) do
		local sid = e:GetNWString("XPPPOwnerID")
		if sid ~= "" then
			local tname = "XPPP Remove Props of " .. sid
			if timer.Exists(tname) then
				timer.Remove(tname)
			end
			e:Remove()
		end
	end
end)