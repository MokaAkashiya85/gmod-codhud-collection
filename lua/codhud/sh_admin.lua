---- [ SHARED CONVARS & FRIENDLY FIRE ] ----

CreateConVar("codhud_score_limit", "75", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sets the score limit for the HUD, measured in kills.")
CreateConVar("codhud_time_limit", "10", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sets the match time limit, measured in minutes.")
CreateConVar("codhud_matchstart_timer", "10", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sets the match start timer.")
CreateConVar("codhud_friendly_fire", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "If 0, players on the same faction cannot damage each other.")

if SERVER then
    hook.Add("PlayerShouldTakeDamage", "CoDHUD_FactionFriendlyFire", function(victim, attacker)
        if GetConVar("codhud_friendly_fire"):GetBool() then return end
        if not IsValid(attacker) or not attacker:IsPlayer() then return end
        if victim == attacker then return end

        if victim:GetNW2String("CoDHUD_Faction", "rangers") == attacker:GetNW2String("CoDHUD_Faction", "rangers") then
            return false
        end
    end)
end

CreateConVar("codhud_game", "mw2", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Which CoD game factions and UI should utilize.")

if SERVER then
	util.AddNetworkString("CoDHUD_SetGame")

	net.Receive("CoDHUD_SetGame", function(len, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		local game = net.ReadString()

		if CoDHUD_RoundStarting or CoDHUD_RoundEnding then
			print("[CoDHUD] Blocked game change!")
			net.Start("CoDHUD_KillfeedMessage")
			net.WriteString("CoDHUD.System.RestrictType.NotNow")
			net.Send(ply)
			return
		end

		RunConsoleCommand("codhud_game", game)
	end)
end

if SERVER then
    util.AddNetworkString("CoDHUD_SetConVar")

    local editableConVars = {
        codhud_enable_roundend = true,
        codhud_enable_roundend_startnext = true,
        codhud_friendly_fire = true,
        codhud_score_limit = true,
        codhud_time_limit = true,
        codhud_matchstart_timer = true,
        codhud_autobalance_on_roundstart = true,
        codhud_restrictfactions = true,
        codhud_selected_gamemode = true,
        codhud_autofaction_limit = true
    }

    net.Receive("CoDHUD_SetConVar", function(_, ply)
        if not IsValid(ply) or not ply:IsAdmin() then return end

        local cvar = net.ReadString()
        local value = net.ReadString()

        if not editableConVars[cvar] then return end

        local cv = GetConVar(cvar)
        if not cv then return end

		-- local valtext = cv:GetBool() and "CoDHUD.System.Disabled" or "CoDHUD.System.Enabled"

		net.Start("CoDHUD_KillfeedMessage")
			net.WriteString("CoDHUD.System.CVChanged")
			net.WriteString(cvar)
			net.WriteString(value)
		net.Broadcast()
		
        RunConsoleCommand(cvar, value)
    end)
end

function CoDHUD_SetServerConVar(cvar, value)
    net.Start("CoDHUD_SetConVar")
        net.WriteString(cvar)
        net.WriteString(tostring(value))
    net.SendToServer()
end