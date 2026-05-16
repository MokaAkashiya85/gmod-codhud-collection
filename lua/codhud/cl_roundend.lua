---- [ CLIENT ROUND END ] ----

-- ============================================================
--  Config & Helpers
-- ============================================================
local CFG = {
    DURATION         = 15.0,
    BW_FADE_TIME     = 1.0,

    MUSIC_DELAY      = 0.0,
    VOICE_DELAY      = 3.0,
	POINTS_DELAY     = 4.0,
	SCOREBOARD_DELAY = 6.0,

    BONUS_X          = 960,
    BONUS_Y          = 720,

    ICON_FADE_TIME   = 1.0,
}

local function CoDHUD_GetDMPlacements()
    local players = {}

    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) then
            table.insert(players, {
                ply = p,
                score = math.max(0, p:Frags())
            })
        end
    end

	table.sort(players, function(a, b)
		if a.score == b.score then
			return a.ply:Nick() < b.ply:Nick()
		end

		return a.score > b.score
	end)

    return players
end

-- ============================================================
--  Match Bonus
-- ============================================================
local function CalcMatchBonus(kills)
    kills = math.Clamp(kills, 0, 75)
    if kills == 0 then return math.random(100, 130) end
    local base = math.floor(100 + (kills / 75) ^ 2 * 2400)
    return math.Clamp(base + math.random(-50, 100), 100, 2500)
end

-- ============================================================
--  State
-- ============================================================
local re_active       = false
local re_lock_time    = 0
local re_bw           = 0

_G.CoDHUD_IsRoundEnding = _G.CoDHUD_IsRoundEnding or false

local re_match_bonus  = 0

-- Write-in states
local ws_result = ""
local ws_limit = ""

local re_result_glow  = Color(255, 255, 255)

local re_mvlock = false
local re_locked_ang = nil

-- ============================================================
--  Cleanup
-- ============================================================
local function RE_End()
    re_active    = false
    re_mvlock    = false
    re_locked_ang = nil
    re_bw        = 0
    RunConsoleCommand("-showscores")
    timer.Remove("MW2_RE_Music")
    timer.Remove("MW2_RE_Voice")
    timer.Remove("MW2_RE_Board")
    timer.Remove("MW2_RE_Done")
	timer.Remove("CoDHUD_SuspenseTimer")
	_G.CoDHUD_IsRoundEnding = false
	if GetConVar("codhud_enable_roundend_startnext"):GetBool() then return end
	_G.CoDHUD_RoundActiveCL = false
	_G.CoDHUD_ActiveGamemodeCL	= "dm"
end

-- ============================================================
--  Net receive (Timer removed as requested)
-- ============================================================
net.Receive("CoDHUD_RoundEnd", function()
    local winnerFac = net.ReadString()
    local loserFac  = net.ReadString()
    local winnerSc  = net.ReadInt(32)
    local loserSc   = net.ReadInt(32)
	local forcedEnd	= net.ReadBool()

	-- prevent suspense music from interfering with spawn theme
	timer.Remove("CoDHUD_SuspenseTimer")

	local hud = CoDHUD[CoDHUD_GetHUDType()]
	local voicefile = hud and hud.VoiceCallouts or {}

	local str = CoDHUD[CoDHUD_GetHUDType()].TextStrings

	if _G.CoDHUD_MedalSystem then _G.CoDHUD_MedalSystem.Clear() end -- Clears kill messages

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

	local gm = CoDHUD_ActiveGamemodeCL or "war"
	local isDM = (gm == "dm")

    local localFac  = ply:GetNW2String("CoDHUD_Faction", "rangers")
    if localFac == "" then localFac = cookie.GetString("CoDHUD_SelectedFaction", "rangers") end

    local kills     = math.max(0, ply:Frags())
    local fdata     = CoDHUD.Factions[CoDHUD_GetHUDType()] and CoDHUD.Factions[CoDHUD_GetHUDType()][localFac]
    local voiceTag  = fdata and fdata.voice or nil
    local hasTwo    = (loserFac ~= "" and CoDHUD.Factions[CoDHUD_GetHUDType()] and CoDHUD.Factions[CoDHUD_GetHUDType()][loserFac] ~= nil)

	-- Team Scores
	local teamsMap = {}

	for _, p in ipairs(player.GetAll()) do
		local fac = p:GetNW2String("CoDHUD_Faction", "rangers")
		if fac ~= "" then
			teamsMap[fac] = teamsMap[fac] or {
				fac = fac,
				score = 0
			}

			teamsMap[fac].score = teamsMap[fac].score + math.max(0, p:Frags())
		end
	end

	local teams = {}

	for _, t in pairs(teamsMap) do
		table.insert(teams, t)
	end

	-- Ensure local faction is first (optional but consistent with HUD)
	local lp = LocalPlayer()
	local localFac = lp:GetNW2String("CoDHUD_Faction", "rangers")

	table.sort(teams, function(a, b)
		return (a.score or 0) > (b.score or 0)
	end)

	local gm = CoDHUD_ActiveGamemodeCL or "war"
	local isDM = (gm == "dm")

	local resultState
	local placement = nil
	local dmScore = {}

	if isDM then
		local placements = CoDHUD_GetDMPlacements()

		for i, data in ipairs(placements) do
			local entry = {
				name  = IsValid(data.ply) and data.ply:Nick() or "Unknown",
				pos   = i,
				score = data.score or 0,
				ply   = data.ply -- optional, useful later if needed
			}

			table.insert(dmScore, entry)

			-- local player's placement
			if data.ply == ply then
				placement = i
			end
		end
	end

    local now = CurTime()

    -- Core state
    re_active      = true
    re_lock_time   = now
    re_bw          = 0
    re_winner      = winnerFac
    re_loser       = loserFac
    re_has_two     = hasTwo
    -- re_left_fac    = leftFac
    -- re_right_fac   = rightFac
    re_match_bonus = CalcMatchBonus(kills)
    re_mvlock      = true
    re_locked_ang  = nil
	
	_G.CoDHUD_IsRoundEnding = true

	-- ============================================================
	--  Draw detection
	-- ============================================================
	local isDraw = false

	if #teams <= 1 then
		-- Only one (or zero) team exists
		if teams[1] and teams[1].score == 0 then
			isDraw = true
		end
	else
		-- Check if top two teams have same score
		if teams[1].score == teams[2].score then
			isDraw = true
		end
	end

	-- RESULT RESOLUTION (single source of truth)
	if isDM then
		if placement == 1 then
			resultState = "win"
			re_result_glow = Color(0, 220, 80)
		elseif placement and placement <= 3 then
			resultState = "win"
			re_result_glow = Color(0, 220, 80)
		else
			resultState = "lose"
			re_result_glow = Color(220, 60, 60)
		end

	elseif isDraw or winnerFac == "" then
		resultState = "draw"
		re_result_glow = Color(255, 255, 255)

	else
		local localFac = ply:GetNW2String("CoDHUD_Faction", "rangers")

		if localFac == winnerFac then
			resultState = "win"
			re_result_glow = Color(0, 220, 80)
		else
			resultState = "lose"
			re_result_glow = Color(220, 60, 60)
		end
	end

    local leftFac   = localFac
    local rightFac  = resultState == "win" and loserFac or winnerFac
    local leftSc    = resultState == "win" and winnerSc or loserSc
    local rightSc   = resultState == "win" and loserSc  or winnerSc
	
    re_left_fac    = leftFac
    re_right_fac   = rightFac
	
	if resultState == "win" then
		ws_result = str.re.win or "MW2_MP_VICTORY"
	elseif resultState == "draw" then
		ws_result = str.re.draw or "MW2_MP_DRAW"
	else
		ws_result = str.re.lose or "MW2_MP_DEFEAT"
	end
	
	ws_result = language.GetPhrase(ws_result)

    -- Write-in state reset
	local timeLeft = (CoDHUD_RoundEndTime or 0) - CurTime()

	if forcedEnd then
		ws_limit = language.GetPhrase("MW2_MP_HOST_ENDED_GAME")
	elseif (CoDHUD_MatchMaxTime > 0) and timeLeft <= 0.1 then
		ws_limit = language.GetPhrase(str.re.result.time or "MW2_MP_TIME_LIMIT_REACHED")
	else
		ws_limit = language.GetPhrase(str.re.result.score or "MW2_MP_SCORE_LIMIT_REACHED")
	end

	-- Only reset AFTER everything that depends on it is done
	timer.Simple(0.1, function() CoDHUD_RoundEndTime = 0 end)

	if CoDHUD[CoDHUD_GetHUDType()] and CoDHUD[CoDHUD_GetHUDType()].RoundEnd then
		CoDHUD[CoDHUD_GetHUDType()].RoundEnd(teams, ws_result, ws_limit, re_result_glow, CFG, dmScore)
	end

    -- Music
	timer.Simple( CFG.MUSIC_DELAY, function()
		local theme

		if isDM then
			theme = "music/" .. CoDHUD_GetHUDType() .. "/" .. ((placement and placement <= 3) and fdata.victorytheme or fdata.defeattheme)
		elseif isDraw then
			theme = voicefile.drawmusic
		else
			theme = "music/" .. CoDHUD_GetHUDType() .. "/" .. (resultState == "win" and fdata.victorytheme or fdata.defeattheme)
		end

		if GetConVar("codhud_enable_music"):GetBool() and theme then
			CoDHUD_PlayAnnouncerSound( theme, true, nil, true )
		end
	end)
	
    -- Voiceline
	if not isDM then
		timer.Simple( CFG.VOICE_DELAY, function()
			local voiceline

			if isDraw then
				voiceline = voicefile.missiondraw
			else
				voiceline = resultState == "win" and voicefile.missionwin or voicefile.missionlose
			end

			local sound = CoDHUD_GetAnnouncerSound(voiceline or nil)
			if sound then CoDHUD_PlayAnnouncerSound(sound, false) end
		end)
	end

    -- Scoreboard opens at 6s, overlay drawing stops at 6s
    timer.Create("MW2_RE_Board", CFG.SCOREBOARD_DELAY, 1, function()
        if re_active then RunConsoleCommand("+showscores") end
    end)

    -- Auto-end
    timer.Create("MW2_RE_Done", CFG.DURATION, 1, RE_End)
	
	timer.Simple( CFG.POINTS_DELAY, function() -- Redundant, as it's not visible anyway. But included just in case.
		if _G.CoDHUD_AddScore then _G.CoDHUD_AddScore(re_match_bonus) end
	end)
end)

-- ============================================================
--  Think
-- ============================================================
hook.Add("Think", "MW2_RE_Think", function()
    if not re_active then return end

    local now = CurTime()
    re_bw = math.Clamp((now - re_lock_time) / CFG.BW_FADE_TIME, 0, 1)
end)

-- ============================================================
--  CreateMove
-- ============================================================
hook.Add("CreateMove", "MW2_RE_Input", function(cmd)
    if not re_mvlock then return end
    cmd:ClearMovement()

    cmd:RemoveKey(IN_ATTACK)
	cmd:RemoveKey(IN_ATTACK2)
	cmd:RemoveKey(IN_RELOAD)
	cmd:RemoveKey(IN_USE)
	cmd:RemoveKey(IN_JUMP)
	cmd:RemoveKey(IN_DUCK)
	cmd:RemoveKey(IN_SPEED)
	cmd:RemoveKey(IN_WALK)
	
    if CurTime() >= re_lock_time + 1.3 then
        if not re_locked_ang then re_locked_ang = cmd:GetViewAngles() end
        cmd:SetViewAngles(re_locked_ang)
    end
end)

-- ============================================================
--  HUDShouldDraw
-- ============================================================
hook.Add("HUDShouldDraw", "MW2_RE_HUD", function(name)
    if not re_active then return end
    if name == "CHudChat" or name == "CHudVoiceSteam" then return end
    return false
end)

-- ============================================================
--  RenderScreenspaceEffects
-- ============================================================
hook.Add("RenderScreenspaceEffects", "MW2_RE_BW", function()
    if not re_active or re_bw <= 0 then return end
    DrawColorModify({
        ["$pp_colour_addr"]       = 0, ["$pp_colour_addg"]       = 0, ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0, ["$pp_colour_contrast"]   = 1,
        ["$pp_colour_colour"]     = 1 - re_bw,
        ["$pp_colour_mulr"]       = 0, ["$pp_colour_mulg"]       = 0, ["$pp_colour_mulb"] = 0,
    })
end)

-- ============================================================
--  DrawOverlay
-- ============================================================
hook.Add("DrawOverlay", "MW2_RE_Draw", function()
    if not re_active then return end
    if not IsValid(LocalPlayer()) then return end

	if CoDHUD[CoDHUD_GetHUDType()] and CoDHUD[CoDHUD_GetHUDType()].RoundEndBonus then
		CoDHUD[CoDHUD_GetHUDType()].RoundEndBonus(re_lock_time, re_match_bonus)
	end
end)