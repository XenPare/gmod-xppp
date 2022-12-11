surface.CreateFont("xppp", {
	font = "Roboto Condensed",
	size = ScreenScale(12),
	weight = 300,
	antialias = true,
	extended = true
})

surface.CreateFont("xppp_shadow", {
	font = "Roboto Condensed",
	size = ScreenScale(12),
	blursize = 3,
	weight = 300,
	antialias = true,
	extended = true
})

local clr_shadow = ColorAlpha(color_black, 230)
local clr_green = HSVToColor(155, 1, 1)
local clr_red = HSVToColor(0, 1, 1)

local pl, tr_ent, ownerid, owner, txt, clr
hook.Add("HUDPaint", "XPPP HUD", function()
	pl = LocalPlayer()

	tr_ent = pl:GetEyeTrace().Entity
	if not IsValid(tr_ent) then
		return
	end

	ownerid = tr_ent:GetNWString("XPPPOwnerID")
	if ownerid == "" then
		return
	end

	owner = player.GetBySteamID(ownerid)
	if IsValid(owner) then
		txt = owner:Name()
		clr = (owner == pl or pl:IsAdmin()) and clr_green or clr_red
	else
		txt = ownerid
		clr = pl:IsAdmin() and clr_green or clr_red
	end

	draw.SimpleText(txt, "xppp_shadow", 30, ScrH() / 2 - 1, clr_shadow)
	draw.SimpleText(txt, "xppp_shadow", 34, ScrH() / 2 + 1, clr_shadow)
	draw.SimpleText(txt, "xppp", 32, ScrH() / 2, clr)
end)