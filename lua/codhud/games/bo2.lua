CoDHUD.RegisterHUD( "bo2", "#CoDHUD.Type.bo2", true )

local hudtype = "bo2"

CoDHUD = CoDHUD or {}
CoDHUD[hudtype] = CoDHUD[hudtype] or {}
CoDHUD.Factions = CoDHUD.Factions or {}
CoDHUD.Gamemodes = CoDHUD.Gamemodes or {}

local textype = {
	"hud/bo2/cp_fill.LN65.pc.snd.wav",
}

-- [[ SPECIAL KILLFEED ICONS ]]
if CLIENT then
	killicon.Add("CoDHUD_BO2_Suicide", hudtype .. "/killfeed/death_suicide.png", Color(255, 255, 255, 0))
	killicon.Add("CoDHUD_BO2_Headshot", hudtype .. "/killfeed/death_headshot.png", Color(255, 255, 255, 0))
end

-- [[ SUSPENSE ]]
CoDHUD[hudtype].SuspenseTracks = {
	"music/bo2/underscores/2m01_myanmar_squirreljump_v1_mp_loop.SL65.pc.snd.wav",
	"music/bo2/underscores/mus_mp_underscore_5m01_no_vox_no_sitar.SN65.pc.snd.wav",
	"music/bo2/underscores/mus_mp_underscore_5m05_no_vox.SN65.pc.snd.wav",
	"music/bo2/underscores/mus_mp_underscore_14m04_no_orch.SN65.pc.snd.wav",
	"music/bo2/underscores/mus_mp_underscore_14m06a_no_orch.SN65.pc.snd.wav",
	"music/bo2/underscores/mus_mp_underscore_14m09a_master.SN65.pc.snd.wav",
	"music/bo2/underscores/mus_mp_underscore_14m09b_no_strings.SN65.pc.snd.wav",
}

-- [[ FACTIONS ]]
CoDHUD.Factions[hudtype] = {
	["seals"] = {
		name = "BO2_MP_SEALS_NAME",
		short = "BO2_MPUI_SEALS_SHORT",
		voicepath = "st6/vox_st6_",
		spawntheme = "spawn/mus_mp_spawn_00.SN65.pc.snd.wav",
		victorytheme = "spawn/mus_mp_spawn_00_short.SN65.pc.snd.wav",
		defeattheme = "loss/mus_loss_00.SN65.pc.snd.wav",
		spawnIcon = hudtype .. "/factions/faction_seals.vtf",
		scoreIcon = hudtype .. "/factions/faction_seals.vtf",
		color = Color(116, 158, 182),
		killfeedcol = Color(116, 158, 182),
		glow = Color(116, 158, 182),
		order = 1
	},
	["sdc"] = {
		name = "BO2_MP_PLA_NAME",
		short = "BO2_MPUI_PLA_SHORT",
		voicepath = "pla/vox_pla_",
		spawntheme = "spawn/mus_mp_spawn_03.SN65.pc.snd.wav",
		victorytheme = "spawn/mus_mp_spawn_03_short.SN65.pc.snd.wav",
		defeattheme = "loss/mus_loss_00.SN65.pc.snd.wav",
		spawnIcon = hudtype .. "/factions/faction_pla.vtf",
		scoreIcon = hudtype .. "/factions/faction_pla.vtf",
		color = Color(167, 14, 16),
		killfeedcol = Color(167, 14, 16),
		glow = Color(167, 14, 16),
		order = 2
	},
	["fbi"] = {
		name = "BO2_MP_FBI_NAME",
		short = "BO2_MPUI_FBI_SHORT",
		voicepath = "fbi/vox_fbi_",
		spawntheme = "spawn/mus_mp_spawn_06.SN65.pc.snd.wav",
		victorytheme = "spawn/mus_mp_spawn_06_short.SN65.pc.snd.wav",
		defeattheme = "loss/mus_loss_00.SN65.pc.snd.wav",
		spawnIcon = hudtype .. "/factions/faction_fbi.vtf",
		scoreIcon = hudtype .. "/factions/faction_fbi.vtf",
		color = Color(16, 208, 221),
		killfeedcol = Color(16, 208, 221),
		glow = Color(16, 208, 221),
		order = 3
	},
	["pmc"] = {
		name = "BO2_MP_PMC_NAME",
		short = "BO2_MPUI_PMC_SHORT",
		voicepath = "pmc/vox_pmc_",
		spawntheme = "spawn/mus_mp_spawn_02.SN65.pc.snd.wav",
		victorytheme = "spawn/mus_mp_spawn_02_short.SN65.pc.snd.wav",
		defeattheme = "loss/mus_loss_00.SN65.pc.snd.wav",
		spawnIcon = hudtype .. "/factions/faction_pmc.vtf",
		scoreIcon = hudtype .. "/factions/faction_pmc.vtf",
		color = Color(252, 163, 11),
		killfeedcol = Color(252, 163, 11),
		glow = Color(252, 163, 11),
		order = 4
	},
	["isa"] = {
		name = "BO2_MP_ISA_NAME",
		short = "BO2_MPUI_ISA_SHORT",
		voicepath = "isa/vox_isa_",
		spawntheme = "spawn/mus_mp_spawn_cia_20sec.SN65.pc.snd.wav",
		victorytheme = "spawn/mus_mp_spawn_cia_10sec.SN65.pc.snd.wav",
		defeattheme = "loss/mus_loss_00.SN65.pc.snd.wav",
		spawnIcon = hudtype .. "/factions/faction_isa.vtf",
		scoreIcon = hudtype .. "/factions/faction_isa.vtf",
		color = Color(84, 149, 115),
		killfeedcol = Color(84, 149, 115),
		glow = Color(84, 149, 115),
		order = 5
	},
	["cd"] = {
		name = "BO2_MP_CD_NAME",
		short = "BO2_MPUI_CD_SHORT",
		voicepath = "cia/vox_cda_",
		spawntheme = "spawn/mus_mp_spawn_05.SN65.pc.snd.wav",
		victorytheme = "spawn/mus_mp_spawn_05_short.SN65.pc.snd.wav",
		defeattheme = "loss/mus_loss_00.SN65.pc.snd.wav",
		spawnIcon = hudtype .. "/factions/faction_cd.vtf",
		scoreIcon = hudtype .. "/factions/faction_cd.vtf",
		color = Color(239, 237, 134),
		killfeedcol = Color(239, 237, 134),
		glow = Color(239, 237, 134),
		order = 6
	},
}

-- [[ TEXT STRINGS & VOICE CALLOUTS ]]
CoDHUD[hudtype].TextStrings = {
	connected = "MW2_MP_CONNECTED",
	disconnected = "MW2_MP_DISCONNECTED",
	leftgame = "MW2_EXE_LEFTGAME",
	
	re = {
		draw = "MW2_MP_DRAW",
		win = "MW2_MP_VICTORY",
		lose = "MW2_MP_DEFEAT",
		result = {
			score = "MW2_MP_SCORE_LIMIT_REACHED",
			time = "MW2_MP_TIME_LIMIT_REACHED"
		}
	},
	scorebar = {
		tied = "BO1_MENU_TIED_CAPS",
		winning = "BO1_MENU_WINNING_CAPS",
		losing = "BO1_MENU_LOSING_CAPS"
	},
}

CoDHUD[hudtype].VoiceCallouts = {
	winningmusic = "music/bo1/timers/eagleclaw_timer_a.wav",
	losingmusic = "music/bo1/timers/invictus_time_a.wav",
	drawmusic = "music/bo1/results/draw/pentagon_lose_a.wav",

	winningfight = "winning",
	losingfight = "losing",
	lowtime = "timesup",
	
	leadtaken = "lead_taken",
	leadlost = "lead_lost",
	
	missionwin = "mission_success",
	missionlose = "mission_fail",
	missiondraw = "draw",
}

CoDHUD[hudtype].Timer = {
	sound = "hud/bo2/timer_00.LN65.pc.snd.wav",
	timings = {
		[30] = 2,
		[10] = 1
	}
}

local function GetFactionColor(ent)
    if not IsValid(ent) then return Color(255,255,255) end
    local faction = ent:GetNW2String("CoDHUD_Faction", "rangers")

    if CoDHUD.Factions[hudtype][faction] and CoDHUD.Factions[hudtype][faction].killfeedcol then 
		return CoDHUD.Factions[hudtype][faction].killfeedcol
	end

    return Color(255,255,255)
end

-- [[ GAMEMODES ]]
CoDHUD.Gamemodes[hudtype] = {
	{ "#MW2_MPUI_WAR", "war" },
	{ "#MW2_MPUI_DEATHMATCH", "dm" },
	{ "#MW2_MPUI_DOMINATION", "dom" },
	{ "#MW2_MPUI_SEARCH_AND_DESTROY", "sd" },
	{ "#MW2_MPUI_SABOTAGE", "sab" },
	{ "#MW2_MPUI_CAPTURE_THE_FLAG", "ctf" },
	{ "#MW2_MPUI_HEADQUARTERS", "hq" },
	{ "#MW2_MPUI_DD", "dd" },
}

CoDHUD.Gamemodes[hudtype].Hints = {
    ["war"] = "BO1_OBJECTIVES_TDM_HINT", -- TDM
    ["dm"] = "BO1_OBJECTIVES_DM_HINT", -- FFA
    ["dom"] = "BO1_OBJECTIVES_DOM_HINT", -- Domination
    ["sd"] = "BO1_OBJECTIVES_SD_ATTACKER_HINT", -- Search & Destroy
    ["sab"] = "BO1_OBJECTIVES_SAB_HINT", -- Sabotage
    ["ctf"] = "BO1_OBJECTIVES_CTF_HINT", -- Capture the Flag
    ["hq"] = "BO1_OBJECTIVES_TDM_HINT", -- Headquarters (REPLACEME LATER MAYBE?)
    ["dd"] = "BO1_OBJECTIVES_DEM_ATTACKER_HINT", -- Demolition
}

CoDHUD.Gamemodes[hudtype].Callouts = {
    ["war"] = "tdm_start",
    ["dm"] = "ffa_start",
    ["dom"] = "dom_start",
    ["sd"] = "sd_start",
    ["sab"] = "sab_start",
    ["ctf"] = "ctf_start",
    ["hq"] = "hq_start",
    ["dd"] = "demo_start",
}

CoDHUD.Gamemodes[hudtype].Boosts = {
    ["war"] = "generic_boost",
    ["dm"] = "generic_boost",
    ["dom"] = "cap_start",
    ["sd"] = "destroy_start",
    ["sab"] = "destroy_start",
    ["ctf"] = "cap_start",
    ["hq"] = "cap_start",
    ["dd"] = "cap_start",
}

-- [[ HELPERS ]]
local function DrawSqueezedScore(val, x, y, alpha)
	local textCol   = Color(255, 255, 255, alpha)
	local shadowCol = Color(0, 0, 0, alpha * 0.8)
	local s_val     = tostring(val)
	local partPlus  = "+"

	surface.SetFont("BO1_Score_Plus")
	local wP  = surface.GetTextSize(partPlus)
	local gapPlus = CoDHUD_SX(0)

	surface.SetFont("BO1_Score_Main")

	local totalW = wP + gapPlus
	for i = 1, #s_val do
		local char = s_val:sub(i, i)
		local w    = surface.GetTextSize(char)
		totalW = totalW + w
		if i < #s_val then
			totalW = totalW
		end
	end

	local curX = x - (totalW / 2)

	local function DrawComponent(txt, font, px, py)
		draw.SimpleTextOutlined(txt, font, px, py, textCol, 0, 1, 0, shadowCol)
		surface.SetFont(font)
		local w = surface.GetTextSize(txt)
		return w
	end

	local runX = curX
	runX = runX + DrawComponent(partPlus, "BO2_Score_Plus", runX, y) + gapPlus

	for i = 1, #s_val do
		local char = s_val:sub(i, i)
		local w    = DrawComponent(char, "BO2_Score_Main", runX, y)
		if i < #s_val then
			runX = runX + w
		end
	end
end

local function DrawSqueezedText(text, font, x, y, color, squeeze, squeezeOne, align, squeezeOneBefore, outlineW, outlineCol)
    local str = tostring(text)
    surface.SetFont(font)

    local totalW = 0
    for i = 1, #str do
        local char     = str:sub(i, i)
        local nextChar = str:sub(i + 1, i + 1)
        local w = surface.GetTextSize(char)
        totalW = totalW + w
        if i < #str then
            local gap = (char == "1") and squeezeOne or (nextChar == "1" and squeezeOneBefore or squeeze)
            totalW = totalW + gap
        end
    end

    local runX = (align == 1) and (x - totalW/2) or (align == 2 and x or x - totalW)

    for i = 1, #str do
        local char     = str:sub(i, i)
        local nextChar = str:sub(i + 1, i + 1)
        local o        = outlineW or 0
        local outlineCol = outlineCol or Color(0, 0, 0, color.a)

		draw.SimpleTextOutlined( char, font, runX, y, color, 0, 0, o, outlineCol )

        local w = surface.GetTextSize(char)
        if i < #str then
            local gap = (char == "1") and squeezeOne or (nextChar == "1" and squeezeOneBefore or squeeze)
            runX = runX + w + gap
        end
    end
end

-- [[ HUD ELEMENTS ]]
CoDHUD[hudtype].MedalsBlockChallenges = true   -- medals pause challenges

local function settingsmenu( ... )
	local w = select(1, ...)
	local h = select(2, ...)

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial( Material( "bo2/settings/menu_mp_soldiers.png" ) )
	surface.DrawTexturedRect(0, 0, w, h)
end
CoDHUD[hudtype].SettingsMenu = settingsmenu

local function challengecomplete( ... )
    local header = select(1, ...)
    local level = select(2, ...)
    local sub = select(3, ...)
	local subval = select(4, ...)
    local align = select(5, ...)
	
	local function ResolvePrefix(prefix, text)
		if not prefix or prefix == "" then return text end
		
		if string.find(text, " ") then
			return language.GetPhrase(text)
		end
		
		if subval then
			return string.format( language.GetPhrase(prefix .. text), subval )
		else
			return language.GetPhrase(prefix .. text)
		end
	end
	
    CoDHUD_HeaderQueue.Push({
		type = "bo2_challenge",
        text = CoDHUD_ChallengeTitle(header, level),
        subtext = (sub and sub ~= "") and ResolvePrefix("MW2_CHALLENGE_", sub) or nil,
        x = CoDHUD_SX(960),
        y = CoDHUD_SY(125),
		holdTime = 1.5,

        color = Color(0,0,0),
        fonts = {
            pri = "BO2_ChalHeader",
            sub = "BO2_ChalSub",
        },
    })

    surface.PlaySound("hud/bo2/award.SN65.pc.snd.wav")
end
CoDHUD[hudtype].ChallengeComplete = challengecomplete

local function rs_obj( ... )
	local text = select(1, ...)

	CoDHUD_HeaderQueue.Push({
		type = "bo",
		writeSounds = textype,
		writeSpeed = 8,
		writeSoundOnce = true,
		text = language.GetPhrase(text),
		x = CoDHUD_SX(960),
		y = CoDHUD_SY(170),
		color = Color(0, 0, 0),
		fonts = {
			pri = "BO2_RS_O_Pri",
			sec = "BO2_RS_O_Sec",
			shd = "BO2_RS_O_Shd"
		}
	})
end
CoDHUD[hudtype].RoundStartObjective = rs_obj

local function rs_title( ... )
	local text = select(4, ...)
	local glow = select(2, ...)
	local logo = select(3, ...)

	CoDHUD_HeaderQueue.Push({
		type = "bo2_teamheader",
		text = language.GetPhrase(text .. "_CAPS"),
		x = CoDHUD_SX(960),
		y = CoDHUD_SY(120),
		flashColor = glow,

		iconY = CoDHUD_SY(100),
		iconSize = CoDHUD_S(200),

		fonts = {
			pri = "BO2_RS_H_Pri",
			sec = "BO2_RS_H_Sec",
			shd = "BO2_RS_H_Shd"
		},

		icon = logo
	})
end
CoDHUD[hudtype].RoundStart = rs_title

local function rs_timer( ... )
	local disp = select(1, ...)

	local scale = 1 / CoDHUD_GetUIScaleMultiplier()

	local outlined = GetConVar("codhud_enable_outlinedtext"):GetBool()

    local tx  = CoDHUD_SX(960) * scale
    local ty  = CoDHUD_SY(540) * scale
    -- local ty  = ScrH() * 0.5
    local syo = CoDHUD_SY(-85) * scale

	if disp ~= rs_last_dig then
		rs_last_dig  = disp
		rs_dig_scale = 1.8
	end
	rs_dig_scale = math.Approach(rs_dig_scale, 1, FrameTime() * 6)

	if disp > 0 then
		local tMat = Matrix()
		tMat:Translate(Vector(tx, ty, 0))
		tMat:Scale(Vector(rs_dig_scale, rs_dig_scale, 1))
		tMat:Translate(Vector(-tx, -ty, 0))

		cam.PushModelMatrix(tMat)
			draw.SimpleTextOutlined( disp, "BO2_RS_Timer", tx, ty, Color(255,255,100), 1, 1, outlined and 1 or 0, Color(0,0,0) )
		cam.PopModelMatrix()

		draw.SimpleTextOutlined( "#BO1_MP_MATCH_STARTING_IN", "BO2_RS_S_Pri", tx, ty + syo, Color(255,255,255), 1, 1, outlined and 1 or 0, Color(0,0,0) )
	end
end
CoDHUD[hudtype].RoundStartTimer = rs_timer

local function re_teams( ... )
    local teams = select(1, ...)
    local ws_result = select(2, ...)
    local ws_limit = select(3, ...)
    local re_result_glow = select(4, ...)
    local CFG = select(5, ...)

    local multiplier = 1

    -- Apply visual scaling only
    local scaledTeams = {}
    for k, v in ipairs(teams) do
        scaledTeams[k] = {
            fac = v.fac,
            score = (v.score or 0) * multiplier
        }
    end

    -- Teams
    CoDHUD_HeaderQueue.Push({
		type = "bo",
        teams = scaledTeams, -- use scaled version
		writeSounds = {""},
		writeSpeed = 8,
        x = CoDHUD_SX(960),
        y = CoDHUD_SY(400),
        multiple = true,
        persist = true,
        endTime = CFG.SCOREBOARD_DELAY,

        iconSize = CoDHUD_S(184),
        iconGap  = CoDHUD_S(80),
        scoreY = CoDHUD_SY(620),

        fonts = {
            pri = "BO2_RE_Sc_Pri",
            sec = "BO2_RE_Sc_Sec",
            shd = "BO2_RE_Sc_Shd",
        }
    })

	-- Text
	CoDHUD_HeaderQueue.Push({
		type = "bo",
		text = ws_result,
		writeSounds = textype,
		writeSoundOnce = true,
		writeSpeed = 8,
		x = CoDHUD_SX(960),
		y = CoDHUD_SY(240),
		color = re_result_glow,
		multiple = true,
		skipErase = true,
		persist = true,
		endTime = CFG.SCOREBOARD_DELAY,
		fonts = {
			pri = "BO2_RE_Re_Pri",
			sec = "BO2_RE_Re_Sec",
			shd = "BO2_RE_Re_Shd",
			sub = "BO2_ChalSub"
		}
	})

	CoDHUD_HeaderQueue.Push({
		type = "bo",
		text = ws_limit,
		writeSounds = {""},
		writeSpeed = 80,
		x = CoDHUD_SX(960),
		y = CoDHUD_SY(330),
		color = Color(135, 135, 180),
		multiple = true,
		skipErase = true,
		persist = true,
		endTime = CFG.SCOREBOARD_DELAY,
		fonts = {
			pri = "BO2_RE_Li_Pri",
			sec = "BO2_RE_Li_Sec",
			shd = "BO2_RE_Li_Shd",
		}
	})

end
CoDHUD[hudtype].RoundEnd = re_teams

local function re_bonus( ... )
	local re_lock_time = select(1, ...)
	local re_match_bonus = select(2, ...)

	local outlined = GetConVar("codhud_enable_outlinedtext"):GetBool()

    local el = CurTime() - re_lock_time
    if el < 0 then return end
    if el >= 6.0 then return end

    local iconAlpha = math.floor(math.Clamp(el / 1.0, 0, 1) * 255)

	draw.SimpleTextOutlined( string.format( language.GetPhrase("MW2_MP_MATCH_BONUS_IS"), tostring(re_match_bonus) ), "BO2_RE_Bonus", CoDHUD_SX(960), CoDHUD_SY(720), Color(240, 250, 110, iconAlpha), 1, 1, outlined and 1 or 0, Color(0,0,0, iconAlpha) )
end
CoDHUD[hudtype].RoundEndBonus = re_bonus

local function hitmarker( ... )
	local hitTime = select(1, ...)
	local ct = CurTime()
	local cx, cy = ScrW() / 2, ScrH() / 2

	local matHit = Material(hudtype .. "/icons/damage_feedback.png", "mips smooth")

	local fade = math.Clamp((hitTime - ct) / 0.9, 0, 1) * 255
	surface.SetMaterial(matHit)
	surface.SetDrawColor(255, 255, 255, fade)
	local size = 36
	surface.DrawTexturedRect(cx - (size / 2), cy - (size / 2), size, size)
end
CoDHUD[hudtype].Hitmarker = hitmarker

local function xp( ... )

	local animtime         = select(1, ...)
	local scoreTime        = select(2, ...)
	local finalAlpha       = select(3, ...)
	local scoreScale       = select(4, ...)
	local currentPulseAlpha= select(5, ...)
	local scoreVal         = select(6, ...)

	local cx, cy = ScrW() / 2, ScrH() / 2
	local drawX  = cx + CoDHUD_SY(90)
	local drawY  = cy - CoDHUD_SY(90)

	-- BO2 TIMINGS
	local bgIntroTime   = 0.13
	local textDelay     = 0.01
	local textIntroTime = 0.03

	local holdStart = bgIntroTime + textDelay + textIntroTime

	-- sync with existing fade system
	local remaining = math.max(scoreTime - CurTime(), 0)
	local fadeFrac = math.Clamp(remaining / 0.3, 0, 1)
	local isExiting = remaining <= 0.3

	-- VISUAL STATE
	local bgAlpha      = 0
	local bgColorLerp  = 0
	local textAlpha    = 0

	-- INTRO:
	-- WHITE BG FLASH
	if animtime <= bgIntroTime then

		local p = math.Clamp(animtime / bgIntroTime, 0, 1)

		bgAlpha = Lerp(p, 255, 110)
		bgColorLerp = p

	-- TEXT INTRO
	elseif animtime <= holdStart then

		bgAlpha = 110
		bgColorLerp = 1

		local p = math.Clamp( (animtime - (bgIntroTime + textDelay)) / textIntroTime, 0, 1 )

		textAlpha = Lerp(p, 0, 255)

	-- HOLD
	elseif not isExiting then
		bgAlpha = 110
		bgColorLerp = 1
		textAlpha = 255

	-- EXIT
	else
		textAlpha = 0
		bgColorLerp = 0
		bgAlpha = 255 * fadeFrac
	end

	-- COLORS
	local flashColor = Color(175,175,225)

	local drawBgCol = Color(
		Lerp(bgColorLerp, 255, flashColor.r),
		Lerp(bgColorLerp, 255, flashColor.g),
		Lerp(bgColorLerp, 255, flashColor.b),
		bgAlpha * (finalAlpha / 255)
	)

	local drawTextAlpha = textAlpha * (currentPulseAlpha / 255) * (finalAlpha / 255)

	-- SIZE
	surface.SetFont("BO1_Score_Main")

	local txt = "+" .. tostring(scoreVal)
	local tw, th = surface.GetTextSize(txt)
	local padX = CoDHUD_SX(12)
	local padY = CoDHUD_SY(12)
	local bw = tw + padX * 2
	local bh = th + padY * 2

	-- BACKING
	surface.SetMaterial( Material( CoDHUD_GetHUDType() .. "/hud/fade_team.vmt" ) )
	surface.SetDrawColor(drawBgCol)
	surface.DrawTexturedRect( drawX - bw * 1, drawY - bh * 1, bw * 2, bh * 2 )

	-- TEXT
	DrawSqueezedScore( scoreVal, drawX, drawY, drawTextAlpha )
end
CoDHUD[hudtype].XP = xp

local function dmg_dir( ... )
	local attackers = select(1, ...)
	local ply = select(2, ...)

    local cx, cy = ScrW() / 2, ScrH() / 2
	local matDamage = Material(hudtype .. "/icons/hitdirection")

	for i = #attackers, 1, -1 do
		local v = attackers[i]

		-- Fade Logic
		if CurTime() > v.time - 1 then 
			v.alpha = math.Approach(v.alpha, 0, FrameTime() * 400)
			if v.alpha <= 0 then table.remove(attackers, i) continue end
		end

		-- Live Tracking: If they are still alive, grab their new position
		local targetWorldPos = v.trackPos
		-- if IsValid(v.ent) then -- Re-apply stability offset
			-- targetWorldPos = v.ent:GetPos() + (ply:GetPos() - v.ent:GetPos()) * -33000
		-- end

		-- === DIRECTION MATH (Grenade Pointer Logic) ===
		-- 1. Get relative position
		local localPos = ply:WorldToLocal(targetWorldPos)
		
		-- 2. Calculate Angle (Inverting Y for screen space)
		local dirVecX = localPos.x
		local dirVecY = -localPos.y 
		local screenAngleRad = math.atan2(dirVecX, dirVecY)

		-- 3. Position on Orbit
		local orbitRadius = 280
		local px = cx + math.cos(screenAngleRad) * orbitRadius
		local py = cy - math.sin(screenAngleRad) * orbitRadius

		-- 4. Rotate Texture (Angle + 270 degrees)
		local rotation = math.deg(screenAngleRad) + 270

		surface.SetMaterial(matDamage)
		surface.SetDrawColor(255, 255, 255, v.alpha)
		surface.DrawTexturedRectRotated(px, py, 180, 90, rotation)
		surface.DrawTexturedRectRotated(px, py, 180, 90, rotation)
		surface.DrawTexturedRectRotated(px, py, 180, 90, rotation)
	end
end
CoDHUD[hudtype].DamageDirection = dmg_dir

local function grenade_dir( ... )
	local showIcon = select(1, ...)
	local nearEnts = select(2, ...)
	local ply = select(3, ...)

    local cx, cy = ScrW() / 2, ScrH() / 2

	local matIcon = Material(hudtype .. "/icons/grenadeicon.png", "mips smooth")
	local matPointer = Material(hudtype .. "/icons/grenadepointer.png", "mips smooth")
		
    for _, ent in ipairs(nearEnts) do
        if not CoDHUD_IsGrenade(ent) then continue end

        -- 1. LOCALIZED COORDINATES
        local localPos = ply:WorldToLocal(ent:GetPos())
        local dirVecX = localPos.x
        local dirVecY = -localPos.y 
        
        -- 2. CALC ANGLE
        local screenAngleRad = math.atan2(dirVecX, dirVecY)
        local screenAngleDeg = math.deg(screenAngleRad)

        -- 3. POSITIONING
        local ringRadius = 150
        local px = cx + math.cos(screenAngleRad) * ringRadius
        local py = cy - math.sin(screenAngleRad) * ringRadius

        -- 4. POINTER POSITION
        local pointerRadius = ringRadius + 40
        local ptrX = cx + math.cos(screenAngleRad) * pointerRadius
        local ptrY = cy - math.sin(screenAngleRad) * pointerRadius

        surface.SetDrawColor(255, 255, 255, 255)

        -- 5. DRAW THE POINTER
        if matPointer and not matPointer:IsError() then
            surface.SetMaterial(matPointer)
            surface.DrawTexturedRectRotated(ptrX, ptrY, 70, 35, screenAngleDeg + 270)
        end

        -- 6. DRAW THE ICON
        if showIcon then
            if matIcon and not matIcon:IsError() then
                surface.SetMaterial(matIcon)
                surface.DrawTexturedRectRotated(px, py, 50, 50, 0)
            end
        end
    end
end
CoDHUD[hudtype].GrenadeIndicator = grenade_dir

local function killfeed( ... )
	local KillFeed = select(1, ...)
	
    -- Animation Settings
    ANIM_TIME = 0.25
    ANIM_RISE = 15

    local cx, cy = ScrW() / 2, ScrH() / 2
	local ct = CurTime()

	local outlined = GetConVar("codhud_enable_outlinedtext"):GetBool()

    local xPos = CoDHUD_S(10)
    local yPos = CoDHUD_S(260)
    local spacing = CoDHUD_S(36)
    local iconW = CoDHUD_S(32)
    local iconH = CoDHUD_S(32)
    local iconOffY = CoDHUD_S(0)
    local gap_name = CoDHUD_S(10)
    local gap_icon = CoDHUD_S(5)
    local gap_extra = CoDHUD_S(25)

    local baseY = ScrH() - yPos

    for i = #KillFeed, 1, -1 do
        local data = KillFeed[i]
        local age = ct - data.spawnTime
        local timeLeft = data.dieTime - ct

		local ICON_BOX_W = iconW
		local ICON_BOX_H = iconH

        if timeLeft <= 0 then
            table.remove(KillFeed, i)
            continue
        end

        -- Calculate Animation and Fading
        local animProgress = math.Clamp(age / ANIM_TIME, 0, 1)
        local fadeFactor = 1

        if age < ANIM_TIME then
            -- Fade in from below
            fadeFactor = animProgress
        elseif timeLeft < 1 then
            -- Fade out (standard)
            fadeFactor = math.Clamp(timeLeft, 0, 1)
        end

        -- Vertical Offset Logic: Start lower and rise up
        local yOffset = (1 - animProgress) * CoDHUD_S(ANIM_RISE)
		local currentY = baseY - ((#KillFeed - i) * spacing) + yOffset
		
        local x = xPos
        local finalTxtAlpha = 155 * fadeFactor

        surface.SetFont("BO2_KillfeedFont")

		local attackerEnt = data.attackerEnt
		local victimEnt = data.victimEnt

		local aColBase = GetFactionColor(attackerEnt)
		local vColBase = GetFactionColor(victimEnt)

		local aCol = Color(aColBase.r, aColBase.g, aColBase.b, finalTxtAlpha)
		local vCol = Color(vColBase.r, vColBase.g, vColBase.b, finalTxtAlpha)

        if data.type == "kill" then
			local ICON_BOX_W = iconW
			local ICON_BOX_H = iconH

			local cls = data.isHeadshot and "CoDHUD_BO2_Headshot" or data.weaponClass
			local w, h = killicon.GetSize(cls)

			if not w or w <= 0 then w = ICON_BOX_W end
			if not h or h <= 0 then h = ICON_BOX_H end

			local gap = CoDHUD_S(10)

			-- 1. Attacker
			if data.attackerName != "" then
				draw.SimpleText(data.attackerName, "BO2_KillfeedFont", x, currentY, aCol)

				local tw, _ = surface.GetTextSize(data.attackerName)
				x = x + tw
			end

			-- 2. Icon
			local iconY = currentY + (ICON_BOX_H - h) * 0.5

			local alpha = math.min(165 * fadeFactor, 255)

			local offsetX = CoDHUD_S(0)
			local offsetY = CoDHUD_S(-15)

			if cls == "CoDHUD_BO2_Headshot" then
				offsetY = CoDHUD_S(-2)
			end

			-- surface.SetDrawColor(255,255,255,alpha)
			-- surface.DrawRect(x + gap + offsetX, iconY + (h * 0.33) + offsetY, w, h)
			
			killicon.Render(x + gap + offsetX, iconY + (h * 0.33) + offsetY, cls, alpha, false, false)

			x = x + w + (gap * 2)

			-- 3. Victim
			draw.SimpleText(data.victimName, "BO2_KillfeedFont", x, currentY, vCol)
        else
            draw.SimpleText(data.msg, "BO2_KillfeedFont", x, currentY, Color(255, 255, 255, finalTxtAlpha))
        end
    end
end
CoDHUD[hudtype].Killfeed = killfeed

local function medals( ... )

	local speedMul   = select(1, ...)
	local activeMedal= select(2, ...)

	local age = (CurTime() - activeMedal.start) / speedMul

	local outlined = GetConVar("codhud_enable_outlinedtext"):GetBool()

	-- TIMINGS
	local TITLE_FADE_TIME = 0.18
	local ICON_DELAY = TITLE_FADE_TIME * 0.5
	local ICON_REVEAL_TIME = 0.28
	local HOLD_TIME = 1.0
	local FADE_OUT_TIME = 0.18
	local FULL_DURATION = ICON_DELAY + ICON_REVEAL_TIME + HOLD_TIME + FADE_OUT_TIME

	if age >= FULL_DURATION then
		return true
	end

	-- POSITION
	local cx = (ScrW() * 0.5)
	local cy = (ScrH() * 0.1)

	-- ALPHAS
	local titleAlpha = 0
	local iconAlpha  = 0
	local fadeOutFrac = 0

	-- TITLE INTRO
	if age <= TITLE_FADE_TIME then
		local p = math.Clamp( age / TITLE_FADE_TIME, 0, 1 )
		titleAlpha = p * 255
	else
		titleAlpha = 255
	end

	-- ICON REVEAL
	local iconAge = age - ICON_DELAY
	local revealFrac = 0

	if iconAge > 0 then
		revealFrac = math.Clamp( iconAge / ICON_REVEAL_TIME, 0, 1 )
		iconAlpha = revealFrac * 255
	end

	-- FADE OUT
	local fadeOutStart = FULL_DURATION - FADE_OUT_TIME

	if age >= fadeOutStart then
		fadeOutFrac = math.Clamp( (age - fadeOutStart) / FADE_OUT_TIME, 0, 1 )

		local fade = 1 - fadeOutFrac
		titleAlpha = titleAlpha * fade
		iconAlpha = iconAlpha * fade
	end

	-- COLORS
	local colWhite = Color(255,255,255,titleAlpha)
	local colBlack = Color(0,0,0,titleAlpha * 0.8)

	-- ICON
	local hud = CoDHUD[CoDHUD_GetHUDType()]
	local medalsTable = (hud and hud.MedalsTable) or (CoDHUD["mw2"] and CoDHUD["mw2"].MedalsTable)
	local medalData = medalsTable[activeMedal.id]

	local iconPath = medalData and medalData[3] or (hudtype .. "/medals/hud_medals_default.png")	
	local iconMat = Material(iconPath, "smooth")

	local size = CoDHUD_S(160)
	local iconX = cx - (size * 0.5)
	local iconY = cy - CoDHUD_S(45)

	-- DIAGONAL REVEAL
	if revealFrac > 0 then

		local reveal = revealFrac

		local w = size
		local h = size

		-- diagonal sweep position
		local sweep = (w + h) * reveal

		surface.SetMaterial(iconMat)

		local poly = {}

		-- bottom-left
		table.insert(poly, { x = iconX, y = iconY + h, u = 0, v = 1 })

		-- top-left intersection
		if sweep <= h then
			table.insert(poly, { x = iconX, y = iconY + h - sweep, u = 0, v = 1 - (sweep / h) })
		else
			table.insert(poly, { x = iconX + (sweep - h), y = iconY, u = (sweep - h) / w, v = 0 })
			table.insert(poly, { x = iconX, y = iconY, u = 0, v = 0 })
		end

		-- right intersection
		if sweep <= w then
			table.insert(poly, { x = iconX + sweep, y = iconY + h, u = sweep / w, v = 1 })
		else
			table.insert(poly, { x = iconX + w, y = iconY + h - (sweep - w), u = 1, v = 1 - ((sweep - w) / h) })
			table.insert(poly, { x = iconX + w, y = iconY + h, u = 1, v = 1 })
		end

		surface.SetDrawColor(255,255,255,iconAlpha)
		surface.DrawPoly(poly)

		-- SHEEN
		local sheenWidth = size * 3
		local sheenPos = (w + h + sheenWidth * 2) * revealFrac

		-- stop rendering once fully exited
		if sheenPos < (w + h + sheenWidth) then

			local sx1 = iconX + sheenPos - sheenWidth
			local sy1 = iconY + h

			local sx2 = iconX + sheenPos
			local sy2 = iconY

			render.OverrideBlend(true, BLEND_SRC_ALPHA, BLEND_ONE, BLENDFUNC_ADD)

				surface.SetDrawColor( 255, 255, 255, 90 * (1 - fadeOutFrac) )

				surface.DrawPoly({
					{ x = sx1, y = sy1, },
					{ x = sx1 + sheenWidth, y = sy1, },
					{ x = sx2 + sheenWidth, y = sy2, },
					{ x = sx2, y = sy2, }
				})

			render.OverrideBlend(false)
		end
	end

	-- TITLE
	draw.SimpleTextOutlined( language.GetPhrase(activeMedal.text), "BO2_MedalPrimary", cx, cy + CoDHUD_SY(128), colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, outlined and 1.5 or 0, colBlack )
end
CoDHUD[hudtype].Medals = medals
CoDHUD[hudtype].MedalsSound = "hud/bo2/metal_3.SN65.pc.snd.wav"
CoDHUD[hudtype].MedalsTable = {
	["headshot"] = { "BO2_MEDAL_HEADSHOT", nil, "bo2/medals/hud_medals_headshot.png" },
	["doublekill"] = { "BO2_MEDAL_MULTIKILL_2", nil, "bo2/medals/hud_medals_doublekill.png" },
	["triplekill"] = { "BO2_MEDAL_MULTIKILL_3", nil, "bo2/medals/hud_medals_triplekill.png" },
	["multikill"] = { "BO2_MEDAL_MULTIKILL_4", nil, "bo2/medals/hud_medals_quadkill.png" },
	["longshot"] = { "BO2_MEDAL_LONGSHOT_KILL", nil, "bo2/medals/hud_medals_longshot.png" },
	["oneshot"] = { "BO2_MEDAL_KILL_ENEMY_ONE_BULLET", nil, "bo2/medals/hud_medals_oneshot_onekill.png" },
	["firstblood"] = { "BO2_MEDAL_FIRST_KILL", nil, "bo2/medals/hud_medals_firstblood.png" },
	["comeback"] = { "BO2_MEDAL_COMEBACK_FROM_DEATHSTREAK", nil, "bo2/medals/hud_medals_comeback.png" },
	["payback"] = { "BO2_MEDAL_REVENGE_KILL", nil, "bo2/medals/hud_medals_revenge.png" },
}

local function minimap( ... )
	local ply = select(1, ...)
	
	local MAP_CFG = {
		X = 12,
		Y = 16,
		W = 224,
		H = 224,

		ALPHA_BORDER    = 255,
		ALPHA_MAP_BG    = 120,
		ALPHA_PLAYER    = 255,
		ALPHA_STATIC_S  = 100,
		ALPHA_MOVING_S  = 255,

		SIZE_PLAYER     = 42,
		SIZE_FRIENDLY   = 42,
		SIZE_ENEMY      = 42,

		SCAN_SPEED      = 48,
		FADE_TIME       = 0.7,
		FADE_TIME_VIS   = 1.3,

		-- [ TINKERING ] 
		-- Adjust this to control how close icons get to the edge. 
		-- 0 means the center of the icon sits exactly on the border line. 
		EDGE_PADDING    = 0, 
	}

	local MAT_BORDER        = Material(hudtype .. "/minimap/compass_map_background.png", "smooth")
	local MAT_MAP_BG        = Material("cod4/minimap/compass_map_default.png", "smooth")
	local MAT_PLAYER        = Material(hudtype .. "/minimap/compassping_player.png", "smooth")
	local MAT_COMPASS   = Material(hudtype .. "/minimap/compass_mp_hud.png", "smooth noclamp")

	local MAT_FRIEND_HOLLOW  = Material(hudtype .. "/minimap/compassping_green_hollow_mp.png", "smooth")
	local MAT_ENEMY_FIRING   = Material(hudtype .. "/minimap/compassping_dog.png", "smooth")

    local x, y = CoDHUD_SX(MAP_CFG.X), CoDHUD_SY(MAP_CFG.Y)
    local w, h = CoDHUD_S(MAP_CFG.W), CoDHUD_S(MAP_CFG.H)
    local centerX, centerY = x + (w / 2), y + (h / 2)
	local radar = CoDHUD_GetRadar()

    -- 1. LAYER: MINIMAP BORDER
    surface.SetMaterial(MAT_BORDER)
    surface.SetDrawColor(255, 255, 255, MAP_CFG.ALPHA_BORDER)
    surface.DrawTexturedRect(x, y, w, h)

    -- [[ STENCIL MASKING ]]
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)

    surface.SetMaterial(MAT_BORDER)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(x, y, w, h)

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilPassOperation(STENCIL_KEEP)

	-- 2. LAYER: RADAR BACKGROUND
	if radar then -- If GMinimap exists
		local rx = x + CoDHUD_S(2)
		local ry = y + CoDHUD_S(2)
		local rw = w - CoDHUD_S(4)
		local rh = h - CoDHUD_S(4)
		
		radar.origin = ply:GetPos()
		radar.rotation = Angle(0, ply:EyeAngles().y, 0)
		radar.ratio = 10
		
		if radar._rx ~= rx or radar._ry ~= ry or radar._rw ~= rw or radar._rh ~= rh then
			radar:SetDimensions(rx, ry, rw, rh)
			radar:UpdateLayout()

			radar._rx = rx
			radar._ry = ry
			radar._rw = rw
			radar._rh = rh
		end

		radar:Draw()
	else -- fallback if GMinimap missing
		surface.SetMaterial(MAT_MAP_BG)
		surface.SetDrawColor(255, 255, 255, MAP_CFG.ALPHA_MAP_BG)
		surface.DrawTexturedRect(x + CoDHUD_S(2), y + CoDHUD_S(2), w - CoDHUD_S(4), h - CoDHUD_S(4))
	end

    render.SetStencilEnable(false)
    -- [[ STENCIL END ]]

	-- 5. LAYER: HORIZONTAL COMPASS (SCROLLING)
	local yaw = (ply:EyeAngles().y + 90) % 360
	local u = 1 - (yaw / 360)

	local compassH = h * 0.15
	local scale = 0.5

	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(x, y + h, w, compassH)
	
	surface.SetMaterial(MAT_BORDER)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawTexturedRect(x, y + h, w, compassH)
	
	surface.SetMaterial(MAT_COMPASS)
	surface.SetDrawColor(255, 255, 255)

	local uEnd = u + scale

	if uEnd <= 1 then
		surface.DrawTexturedRectUV(x, y + h, w, compassH, u, 0, uEnd, 1)
	else
		local overflow = uEnd - 1
		local split = (1 - u) / scale

		surface.DrawTexturedRectUV( x, y + h, w * split, compassH, u, 0, 1, 1 )
		surface.DrawTexturedRectUV( x + (w * split), y + h, w * (1 - split), compassH, 0, 0, overflow, 1 )
	end

    -- 5. LAYER: THE ICONS
    local pSize = CoDHUD_S(MAP_CFG.SIZE_PLAYER)
    local fSize = CoDHUD_S(MAP_CFG.SIZE_FRIENDLY)
    local eSize = CoDHUD_S(MAP_CFG.SIZE_ENEMY)
    
    local localFaction = ply:GetNW2String("CoDHUD_Faction", "")
    local targets = ents.FindByClass("npc_*")
    table.Add(targets, player.GetAll())

    for _, ent in ipairs(targets) do
        if not IsValid(ent) or ent == ply then continue end
        
        local isAlive = (ent:IsPlayer() and ent:Alive()) or (ent:IsNPC() and ent:Health() > 0)
        local targetFaction = ent:GetNW2String("CoDHUD_Faction", "")
        local isFriendly = (localFaction ~= "" and targetFaction == localFaction)
        local entIdx = ent:EntIndex()

        -- Visibility / Shared Vision Check (Enemies only)
        local isVisibleToTeam = false
        if not isFriendly then
            for _, observer in ipairs(player.GetAll()) do
                local obsFaction = observer:GetNW2String("CoDHUD_Faction", "")
                local isObserverFriendly = (localFaction ~= "" and obsFaction == localFaction)
                
                if observer == ply or (isObserverFriendly and observer:Alive()) then
                    local dirToEnt = (ent:WorldSpaceCenter() - observer:EyePos()):GetNormalized()
                    local dot = observer:GetAimVector():Dot(dirToEnt)
                    local fovRad = math.rad((observer:IsPlayer() and observer:GetFOV() or 90) / 2)
                    
                    if dot > math.cos(fovRad) then
                        local tr = util.TraceLine({
                            start = observer:EyePos(),
                            endpos = ent:WorldSpaceCenter(),
                            filter = {observer, ent},
                            mask = MASK_SHOT
                        })
                        if not tr.Hit then
                            isVisibleToTeam = true
                            break
                        end
                    end
                end
            end

            if isVisibleToTeam and isAlive then
                CoDHUD_VisCache[entIdx] = CurTime() + MAP_CFG.FADE_TIME_VIS
            end
        end

        local visAlpha = 0
        if CoDHUD_VisCache[entIdx] then
            local timeLeft = CoDHUD_VisCache[entIdx] - CurTime()
            if timeLeft > 0 then
                visAlpha = math.Clamp(timeLeft / MAP_CFG.FADE_TIME_VIS, 0, 1) * 255
            else
                CoDHUD_VisCache[entIdx] = nil
            end
        end

        -- Base alpha logic: Friendlies are always 255, enemies use visAlpha
        local alpha = 255
        if not isFriendly then
            alpha = visAlpha
        end

        if not isAlive then
            if isFriendly then 
                continue 
            else
                if not CoDHUD_DeathCache[entIdx] then
                    CoDHUD_DeathCache[entIdx] = CurTime()
                end
                
                local timeSinceDeath = CurTime() - CoDHUD_DeathCache[entIdx]
                if timeSinceDeath > MAP_CFG.FADE_TIME then continue end
                alpha = math.min(alpha, 255 * (1 - (timeSinceDeath / MAP_CFG.FADE_TIME)))
            end
        else
            CoDHUD_DeathCache[entIdx] = nil
        end

        if alpha <= 0 then continue end

        -- Relative Position Math
		local targetX, targetY

		if radar then
			local pos = ent:GetPos()
			local origin = ply:EyePos()

			local delta = pos - origin

			local yaw = ply:EyeAngles().y
			local rad = math.rad(yaw + 180)

			local cos, sin = math.cos(rad), math.sin(rad)

			local x2 = delta.y * cos - delta.x * sin
			local y2 = delta.y * sin + delta.x * cos

			x2 = x2 / radar.ratio
			y2 = y2 / radar.ratio

			local boundsX = (w / 2) - MAP_CFG.EDGE_PADDING
			local boundsY = (h / 2) - MAP_CFG.EDGE_PADDING

			if math.abs(x2) > boundsX or math.abs(y2) > boundsY then
				local scaleX = boundsX / math.max(0.0001, math.abs(x2))
				local scaleY = boundsY / math.max(0.0001, math.abs(y2))
				local scale = math.min(scaleX, scaleY)

				x2 = x2 * scale
				y2 = y2 * scale
			end

			targetX = centerX + x2
			targetY = centerY + y2

		else
			local relPos = ent:GetPos() - ply:GetPos()
			local dist = relPos:Length() / 8 

			local posAngle = relPos:Angle()
			posAngle.y = posAngle.y - ply:EyeAngles().y + 90

			local rad = math.rad(posAngle.y)
			local offsetX = math.cos(rad) * dist
			local offsetY = -math.sin(rad) * dist

			local boundsX = (w / 2) - MAP_CFG.EDGE_PADDING
			local boundsY = (h / 2) - MAP_CFG.EDGE_PADDING

			if math.abs(offsetX) > boundsX or math.abs(offsetY) > boundsY then
				local scaleX = boundsX / math.max(0.0001, math.abs(offsetX))
				local scaleY = boundsY / math.max(0.0001, math.abs(offsetY))
				local scale = math.min(scaleX, scaleY)

				offsetX = offsetX * scale
				offsetY = offsetY * scale
			end

			targetX = centerX + offsetX
			targetY = centerY + offsetY
		end

        if isFriendly then
            local rotation = ent:EyeAngles().y - ply:EyeAngles().y
            surface.SetMaterial(MAT_FRIEND_HOLLOW)
            surface.SetDrawColor(255, 255, 255, alpha)
            surface.DrawTexturedRectRotated(targetX, targetY, fSize, fSize, rotation)
        else
            surface.SetMaterial(MAT_ENEMY_FIRING)
            surface.SetDrawColor(255, 255, 255, alpha)
            surface.DrawTexturedRect(targetX - (eSize / 2), targetY - (eSize / 2), eSize, eSize)
        end
    end

    -- Draw Local Player Icon (Static center)
    surface.SetMaterial(MAT_PLAYER)
    surface.SetDrawColor(255, 255, 255, MAP_CFG.ALPHA_PLAYER)
    surface.DrawTexturedRect(centerX - (pSize / 2), centerY - (pSize / 2), pSize, pSize)
end
CoDHUD[hudtype].Minimap = minimap

local function scorebar(data)

    local outlined = GetConVar("codhud_enable_outlinedtext"):GetBool()

	local CFG = {
		-- Base Bar
		BAR_W     = 441.6, -- 256 x 1.725
		BAR_H     = 220.8, -- 128 x 1.725
		BAR_X_OFF = 8,
		BAR_Y_OFF = -32,

		-- Faction Icon
		ICON_SCALE = 0.7,
		ICON_X     = 58,
		ICON_Y     = 44,

		-- Timer
		TIMER_X          = 46,
		TIMER_Y          = 44,
		TIMER_SHIFT_2DIG = 0,
		TIMER_SHIFT_3DIG = 0,
		TIMER_OUTLINE_W  = 1.5,

		-- Winning / Losing / Tie Text Position
		STATUS_X = 121,
		STATUS_Y = 44,

		-- Squeeze Values
		SQUEEZE            = 0,
		SQUEEZE_ONE        = 0,
		SQUEEZE_ONE_BEFORE = 0,
	}

	local SCORES_CFG = {
		-- Text Config
		X = 212.5,
		Y = 117.5,
		GAP_OFFSET = 63,
		OUTLINE_W = outlined and 1 or 0,

		-- Score Limit for Bar Scaling
		SCORE_LIMIT = 75,

		-- Active Bar Config (Green/Red)
		HUD_X = 187.5,
		HUD_Y = 38,
		HUD_W_BASE = 0,
		HUD_W_MAX = 215,
		HUD_H = 43,
		HUD_H_LOWER = 31.5,
		SLANT_SIZE = 11,
		VERTICAL_GAP = 5,
		SHADOW_OFFSET = 2,

		-- Base Bar Config (Black Backgrounds)
		BASE_X = 52,
		BASE_Y = 97,
		BASE_W = 384,
		BASE_H = 99,
	}

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    -- FACTION (unchanged)
    local currentFaction = ply:GetNW2String("CoDHUD_Faction", "")
    if currentFaction == "" then
        currentFaction = cookie.GetString("CoDHUD_SelectedFaction", "rangers")
        if not CoDHUD.Factions[hudtype][currentFaction] then currentFaction = "rangers" end
        ply:SetNW2String("CoDHUD_Faction", currentFaction)
    end

    local scrW, scrH = ScrW(), ScrH()

    -- TOP BAR
    local barW, barH = CoDHUD_SX(CFG.BAR_W), CoDHUD_SY(CFG.BAR_H)
    local barX = CoDHUD_SX(CFG.BAR_X_OFF)
    local barY = scrH - CoDHUD_SY(CFG.BAR_Y_OFF) - barH

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(Material(hudtype .. "/hud/background_score.vmt"))
	
	for i = 1, 8 do
		surface.DrawTexturedRect(barX, barY, barW, barH)
	end

	local factionData = CoDHUD.Factions[hudtype] and CoDHUD.Factions[hudtype][currentFaction]
	local factionMat = factionData and factionData.scoreIcon

	local factionData = CoDHUD.Factions[hudtype] and CoDHUD.Factions[hudtype][currentFaction]
	if not factionData then
		currentFaction = "rangers"
		factionData = CoDHUD.Factions[hudtype][currentFaction]
	end

	if factionMat then
		local iSize = math.Round(barH * CFG.ICON_SCALE)
		local fdg = factionData.glow
		
		-- Background element
		surface.SetDrawColor(fdg.r, fdg.g, fdg.b, fdg.a * 0.25)
		surface.SetMaterial(Material(hudtype .. "/hud/fade_team.vmt"))
		surface.DrawTexturedRect( barX + CoDHUD_SX(CFG.ICON_X * 0.75), barY + CoDHUD_SY(CFG.ICON_Y * 1.25), iSize * 1.25, iSize * 1.25)

		surface.SetMaterial(Material(factionMat, "smooth"))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect( barX + CoDHUD_SX(CFG.ICON_X), barY + CoDHUD_SY(CFG.ICON_Y), iSize, iSize )
		surface.DrawTexturedRect( barX + CoDHUD_SX(CFG.ICON_X), barY + CoDHUD_SY(CFG.ICON_Y), iSize, iSize )
	end

    -- SCORE BARS (UNCHANGED)
    local clientKills   = data.clientScore
    local topEnemyKills = data.enemyScore

    local S_CFG = SCORES_CFG

    local baseX     = CoDHUD_S(S_CFG.BASE_X)
    local baseY		= scrH - CoDHUD_S(S_CFG.BASE_Y)
    local baseW     = CoDHUD_S(S_CFG.BASE_W)
    local baseH     = CoDHUD_S(S_CFG.BASE_H)

    local textX     = CoDHUD_S(S_CFG.X)
    local textY		= scrH - CoDHUD_S(S_CFG.Y)

    local hudX      = CoDHUD_S(S_CFG.HUD_X)
    local hudY      = scrH - CoDHUD_S(S_CFG.HUD_Y)
    local hudWBase  = CoDHUD_S(S_CFG.HUD_W_BASE)
    local hudWMax   = CoDHUD_S(S_CFG.HUD_W_MAX)
    local hudH      = CoDHUD_S(S_CFG.HUD_H)
    local hudHLower      = CoDHUD_S(S_CFG.HUD_H_LOWER)
    local vertGap   = CoDHUD_S(S_CFG.VERTICAL_GAP)

    local liveScoreLimit = S_CFG.SCORE_LIMIT
    local cv_limit = GetConVar("codhud_score_limit")
    if cv_limit then
        local val = cv_limit:GetInt()
        if val > 0 then liveScoreLimit = val end
    end
	
	liveScoreLimit = liveScoreLimit * 1

    local maxAddedWidth = hudWMax - hudWBase
    local client_w = math.Round(hudWBase + math.Clamp(((clientKills * 1) / liveScoreLimit) * maxAddedWidth, 0, maxAddedWidth))
    local enemy_w  = math.Round(hudWBase + math.Clamp(((topEnemyKills * 1) / liveScoreLimit) * maxAddedWidth, 0, maxAddedWidth))

    local HUD_X = hudX
    local HUD_Y = hudY
    local top_y = HUD_Y - vertGap - hudH
    local white = Color(255,255,255,255)

    draw.SimpleTextOutlined( clientKills * 1,   "BO2_Font", CoDHUD_SX(S_CFG.X) - CoDHUD_SX(0), ScrH() - CoDHUD_SY(S_CFG.Y), white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, outlined and 1 or 0, Color(0,0,0,white.a * 0.25) )
    draw.SimpleTextOutlined( topEnemyKills * 1,   "BO2_Font2", CoDHUD_SX(S_CFG.X) - CoDHUD_SX(5), ScrH() - CoDHUD_SY(S_CFG.Y) + CoDHUD_S(S_CFG.GAP_OFFSET), white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, outlined and 1 or 0, Color(0,0,0,white.a * 0.25) )
	
	
    -- TIMER (NOW FROM DATA)
    local timeStr = data.timeStr
    local mins = data.mins

	local timecol = Color(255,255,255)
	
	if data.timeRaw > 30 and data.timeRaw < 60 then
		timecol = Color(218,136,43)
	elseif data.timeRaw < 30 then
		timecol = Color(255,100,100)
	end
	
	timecol = Color(timecol.r, timecol.g, timecol.b, 200) 

	local shouldDrawTimer =
    data.timeRaw > 0.1 and
    (CoDHUD_MatchMaxTime <= 0 or data.timeRaw <= CoDHUD_MatchMaxTime)

	if shouldDrawTimer then
		draw.SimpleTextOutlined( timeStr, "BO2_Timer", barX + CoDHUD_SX(CFG.TIMER_X), barY + CoDHUD_SY(CFG.TIMER_Y), timecol, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, outlined and 1 or 0, Color(0,0,0,timecol.a * 0.25) )
	end
	
	-- Status Colors
	-- data.tiedCol = Color(110, 220, 120, 255)
	-- data.winningCol = Color(215, 110, 120, 255)
	-- data.losingCol = Color(230, 230, 110, 255)

	local text = language.GetPhrase(data.statusText)
	local textcol = Color(255,255,255,200)

	local alt = math.floor(CurTime() / 10) % 2 == 1

	if alt then
		text = string.format( language.GetPhrase("BO2_MPUI_X_POINTS_TO_WIN_CAPS"), liveScoreLimit )
	end

    draw.SimpleTextOutlined( text, "BO2_Status", barX + CoDHUD_SX(CFG.STATUS_X), barY + CoDHUD_SY(CFG.STATUS_Y), textcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, outlined and 1 or 0, Color(0,0,0,textcol.a * 0.25) )

end
CoDHUD[hudtype].Scorebar = scorebar

local function scoreboard( ... )
	local outlined = GetConVar("codhud_enable_outlinedtext"):GetBool()

	local CFG = {
		-- Player Row Background
		BAR_W = 1012.5,
		BAR_H = 40,
		BAR_X_OFF = 142,
		BAR_Y_OFF = 252,
		BAR_ALPHA = 100,

		-- Spacing & Layout
		ROW_GAP = 0,
		TEAM_GAP = 30,

		-- Faction Icon
		ICON_SIZE = 192,
		ICON_X_OFF = -240,
		ICON_Y_OFF = -32,

		-- Score Position
		SCORE_NAME_X = -278,
		SCORE_NAME_Y = 12.5,

		-- Faction Name Position
		FAC_NAME_X = -278,
		FAC_NAME_Y = 53,

		-- Stats Header Y Position
		STATS_HEADER_Y = -45,

		-- Full-Width Header Bar
		HEADER_Y_POS = 90,
		HEADER_H = 50,
		HEADER_ALPHA = 255,
		HEADER_ICON_SIZE = 86,
		HEADER_ICON_X = 140,
		HEADER_ENEMY_ICON_X = 340,

		-- Map Display
		MAP_Y_OFF = 98,

		-- Timer / Header Score
		TIMER_X_POS = 325,
		TIMER_Y_OFF = 150,
		SQUEEZE = 0,
		SQUEEZE_ONE = -0,
		SQUEEZE_ONE_BEFORE = -0,

		-- Stat Offsets (from barRight, going left)
		OFF_PING = 10,
		OFF_ASSISTS = 100,
		OFF_RATIO = 200,
		OFF_DEATHS = 300,
		OFF_KILLS = 400,
		OFF_SCORE = 500,
	}

	local MAT_BOXFG = Material(hudtype .. "/hud/menu_mp_map_frame.png", "mips smooth")
	local MAT_BOXOVERLAY = Material(hudtype .. "/hud/fade_score.vmt")
	local MAT_ICON_DEAD  = Material(hudtype .. "/icons/hud_status_dead.png", "mips smooth")

	local viewportTop = CoDHUD_S(0)
	local viewportHeight = ScrH() -- cap scoreboard height (~65% screen)

	local viewportBottom = viewportTop + viewportHeight

	local function SortLogic(a, b)
		local scoreA = math.max(0, a:Frags())
		local scoreB = math.max(0, b:Frags())

		if scoreA == scoreB then
			if a == LocalPlayer() then return true end
			if b == LocalPlayer() then return false end
			return a:Nick() < b:Nick()
		end

		return scoreA > scoreB
	end

	local function DrawPlayerRow(ply, lp, x, y, w, h, barRight, bgCol)
		-- Status Icon (dead indicator) - Moved next to name
		if ply:IsValid() and not ply:Alive() then
			surface.SetMaterial(MAT_ICON_DEAD)
			surface.SetDrawColor(255, 255, 255, 255)
			local iconSz = h * 0.8
			-- Adjusted X to be right before the name (name starts at 110)
			surface.DrawTexturedRect(x - CoDHUD_S(32), y + (h / 2) - (iconSz / 2), iconSz, iconSz)
		end

		-- Colors & Stats
		local isMe = (ply == lp)
		if isMe then
			surface.SetDrawColor(255, 140, 40, 255)
			surface.DrawOutlinedRect(x - CoDHUD_S(4), y - CoDHUD_S(2), w + CoDHUD_S(6), h + CoDHUD_S(4), 3)
		end
		local tCol = Color(255, 255, 255, 255)
		local pScore = math.max(0, ply:Frags())
		local kills = ply:Frags()
		local deaths = ply:Deaths()

		local ratio = 0

		if kills > 0 then
			ratio = kills / (deaths > 1 and deaths or 1)
		end

		local kd = string.format("%.2f", ratio)

		-- Background on some elements
		surface.SetDrawColor(bgCol.r, bgCol.g, bgCol.b, CFG.BAR_ALPHA)
		surface.DrawRect(barRight - CoDHUD_SX(CFG.OFF_ASSISTS) - CoDHUD_SX(50), y, CoDHUD_S(100), h)
		surface.DrawRect(barRight - CoDHUD_SX(CFG.OFF_DEATHS) - CoDHUD_SX(50), y, CoDHUD_S(100), h)
		surface.DrawRect(barRight - CoDHUD_SX(CFG.OFF_SCORE) - CoDHUD_SX(50), y, CoDHUD_S(100), h)

		-- Text
		draw.SimpleTextOutlined(ply:Nick(), "BO2_Scoreboard_Text", x + CoDHUD_SX(80), y + (h / 2), tCol, TEXT_ALIGN_LEFT,  TEXT_ALIGN_CENTER, outlined and 1 or 0, Color(0, 0, 0))
		draw.SimpleTextOutlined(ply:Ping(), "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_PING),  y + (h / 2), tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, outlined and 1 or 0, Color(0, 0, 0))
		draw.SimpleTextOutlined(deaths, "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_DEATHS),  y + (h / 2), tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, outlined and 1 or 0, Color(0, 0, 0))
		draw.SimpleTextOutlined(kd, "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_RATIO),  y + (h / 2), tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, outlined and 1 or 0, Color(0, 0, 0))
		draw.SimpleTextOutlined(ply:GetNWInt("Assists", 0), "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_ASSISTS), y + (h / 2), tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, outlined and 1 or 0, Color(0, 0, 0))
		draw.SimpleTextOutlined(kills, "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_KILLS),   y + (h / 2), tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, outlined and 1 or 0, Color(0, 0, 0))
		draw.SimpleTextOutlined(pScore, "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_SCORE),   y + (h / 2), tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, outlined and 1 or 0, Color(0, 0, 0))
	end

    local scrW, scrH = ScrW(), ScrH()
    local lp = LocalPlayer()

    -- 1. IDENTIFY FACTIONS & PLAYERS
	local factions = {}

	for _, p in ipairs(player.GetAll()) do
		local fac = p:GetNW2String("CoDHUD_Faction", "rangers")
		if fac == "" then fac = "rangers" end

		factions[fac] = factions[fac] or {}
		table.insert(factions[fac], p)
	end

    -- 2. SORT PLAYERS
	local factionList = {}

	for fac, players in pairs(factions) do
		table.sort(players, SortLogic)

		table.insert(factionList, {
			key = fac,
			players = players,
			score = 0
		})
	end

	for _, f in ipairs(factionList) do
		local score = 0
		for _, p in ipairs(f.players) do
			score = score + math.max(0, p:Frags())
		end
		f.score = score
	end

	table.sort(factionList, function(a, b)
		return a.score > b.score
	end)

    -- 3. LAYOUT POSITIONS
    local barW = CoDHUD_S(CFG.BAR_W)
    local barH = CoDHUD_S(CFG.BAR_H)
    local barX = (scrW / 2) - (barW / 2) + CoDHUD_S(CFG.BAR_X_OFF)
    local barRight = barX + barW
	
	CoDHUD.Scoreboard.ContentHeight = 0

	for _, facData in ipairs(factionList) do
		local visualPlayers = math.max(#facData.players, 2)
		local factionHeight = (visualPlayers * (barH + CoDHUD_S(CFG.ROW_GAP))) + CoDHUD_S(CFG.TEAM_GAP)

		CoDHUD.Scoreboard.ContentHeight = CoDHUD.Scoreboard.ContentHeight + factionHeight
	end

	-- include top header space so scroll math is correct
	CoDHUD.Scoreboard.ContentHeight = CoDHUD.Scoreboard.ContentHeight + CoDHUD_S(200)
	
	local sb = CoDHUD.Scoreboard

	local startY = CoDHUD_S(CFG.BAR_Y_OFF) - math.floor(sb.Scroll)
	local headerY = CoDHUD_S(CFG.BAR_Y_OFF) - CoDHUD_S(50) - CoDHUD.Scoreboard.Scroll
	
	-- HEADER BACKGROUND
	local headerPaddingX = CoDHUD_S(24)
	local headerH = CoDHUD_S(45)
	local headerX = barX - headerPaddingX
	local headerW = (barRight - headerX) + CoDHUD_S(0)

	-- extend left so timer fits
	headerX = headerX - CoDHUD_S(260)
	headerW = headerW + CoDHUD_S(260)

	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect( headerX, headerY - CoDHUD_S(5), headerW, headerH )
	
	surface.SetMaterial(MAT_BOXFG)
	surface.SetDrawColor(255,255,255)
	surface.DrawTexturedRect( headerX, headerY - CoDHUD_S(5), headerW, headerH )

	-- Timer
	local totalSecs = math.floor(CurTime())
	local mins, secs = math.floor(totalSecs / 60), totalSecs % 60
	local timeStr = string.format("%d:%02d", mins, secs)
	draw.SimpleTextOutlined( timeStr, "BO2_Scoreboard_Timer", CoDHUD_S(CFG.TIMER_X_POS), headerY, Color(255,255,255), TEXT_ALIGN_LEFT, 0, outlined and 1 or 0, Color(0,0,0) )
	
	-- Stats column headers
	draw.SimpleTextOutlined( language.GetPhrase("BO1_CGAME_SB_PING"), "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_PING) + CoDHUD_SX(4), headerY, Color(255,255,255), TEXT_ALIGN_RIGHT, 0, outlined and 1 or 0, Color(0,0,0) )
	draw.SimpleTextOutlined( language.GetPhrase("BO1_CGAME_SB_DEATHS"), "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_DEATHS), headerY, Color(255,255,255), TEXT_ALIGN_CENTER, 0, outlined and 1 or 0, Color(0,0,0) )
	draw.SimpleTextOutlined( language.GetPhrase("BO1_CGAME_SB_KDRATIO"), "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_RATIO), headerY, Color(255,255,255), TEXT_ALIGN_CENTER, 0, outlined and 1 or 0, Color(0,0,0) )
	draw.SimpleTextOutlined( language.GetPhrase("BO1_CGAME_SB_ASSISTS"), "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_ASSISTS), headerY, Color(255,255,255), TEXT_ALIGN_CENTER, 0, outlined and 1 or 0, Color(0,0,0) )
	draw.SimpleTextOutlined( language.GetPhrase("BO1_CGAME_SB_KILLS"), "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_KILLS), headerY, Color(255,255,255), TEXT_ALIGN_CENTER, 0, outlined and 1 or 0, Color(0,0,0) )
	draw.SimpleTextOutlined( language.GetPhrase("BO1_CGAME_SB_SCORE"), "BO2_Scoreboard_Text", barRight - CoDHUD_SX(CFG.OFF_SCORE), headerY, Color(255,255,255), TEXT_ALIGN_CENTER, 0, outlined and 1 or 0, Color(0,0,0) )
		
		
	render.SetScissorRect(0, viewportTop, ScrW(), viewportBottom, true)
		for fi, facData in ipairs(factionList) do
			local players = facData.players
			local facKey = facData.key
			local score = facData.score or 0
			local fData = CoDHUD.Factions[hudtype] and CoDHUD.Factions[hudtype][facKey] or { name = facKey, short = facKey, color = Color(120,120,120) }

			local sectionY = startY

			local playerCount = #players
			local visualPlayers = math.max(playerCount, 2)

			local factionRectX = barX - CoDHUD_S(24)
			local factionRectY = sectionY - CoDHUD_S(3)
			local factionRectW = barW + CoDHUD_S(24)
			local factionRectH = (visualPlayers * (barH + CoDHUD_S(CFG.ROW_GAP))) + CoDHUD_S(6)

			factionRectX = factionRectX - CoDHUD_S(260)
			factionRectW = factionRectW + CoDHUD_S(260)

			surface.SetDrawColor(0, 0, 0, 210)
			surface.DrawRect( factionRectX, factionRectY, factionRectW, factionRectH )

			surface.SetMaterial(MAT_BOXFG)
			surface.SetDrawColor(255,255,255)
			surface.DrawTexturedRect( factionRectX, factionRectY, factionRectW, factionRectH )

			surface.SetMaterial(MAT_BOXFG)
			surface.SetDrawColor(255,255,255)
			surface.DrawTexturedRect( factionRectX, factionRectY, factionRectW, factionRectH )

			-- ICON
			local iconPath = CoDHUD.Factions[hudtype][facKey].scoreIcon
			local mat = Material(iconPath, "smooth")

			surface.SetMaterial(mat)
			surface.SetDrawColor(255,255,255,255)

			local iconSize = CoDHUD_S(CFG.ICON_SIZE)
			local iconX = barX + CoDHUD_S(CFG.ICON_X_OFF)
			local iconY = sectionY + CoDHUD_S(CFG.ICON_Y_OFF)
			local minPlayers = 2
			local maxPlayersForFullIcon = 4
			local revealT = math.Clamp( (playerCount - minPlayers) / (maxPlayersForFullIcon - minPlayers), 0, 1 )
			local visibleFrac = Lerp(revealT, 0.6, 1)
			surface.DrawTexturedRectUV( iconX, iconY, iconSize, iconSize * visibleFrac, 0, 0, 1, visibleFrac )

			surface.SetMaterial(MAT_BOXOVERLAY)
			surface.SetDrawColor(fData.glow)
			surface.DrawTexturedRect( factionRectX, factionRectY + CoDHUD_SY(3), iconSize * 1.4, factionRectH )

			draw.SimpleTextOutlined( score, "BO2_Scoreboard_Score", barX + CoDHUD_SX(CFG.SCORE_NAME_X), sectionY + CoDHUD_S(CFG.SCORE_NAME_Y) - CoDHUD_S(22), Color(255,255,255), TEXT_ALIGN_LEFT, 0, outlined and 1 or 0, Color(0,0,0) )
			
			surface.SetFont("BO2_Scoreboard_Score")
			local scorew, scoreh = surface.GetTextSize(score)
			
			draw.SimpleTextOutlined( language.GetPhrase(fData.short .. "_CAPS"), "BO2_Scoreboard_Text", barX + CoDHUD_S(CFG.FAC_NAME_X), sectionY + CoDHUD_S(CFG.FAC_NAME_Y), fData.glow, 0,0, outlined and 1 or 0, Color(0,0,0) )

			-- rows
			for i, ply in ipairs(players) do
				local rowY = sectionY + (i - 1) * (barH + CoDHUD_S(CFG.ROW_GAP))
				DrawPlayerRow(ply, lp, barX, rowY, barW, barH, barRight, fData.color)
			end

			-- push next faction down
			local sectionHeight = (visualPlayers * (barH + CoDHUD_S(CFG.ROW_GAP)))
			startY = startY + sectionHeight + CoDHUD_S(CFG.TEAM_GAP)
		end
	render.SetScissorRect(0, 0, 0, 0, false)

end
CoDHUD[hudtype].Scoreboard = scoreboard

local function deathicon( ... )
	local m = select(1, ...)
	local elapsed = select(2, ...)

    local MAT_DEAD_ICON  = Material(hudtype .. "/icons/headicon_dead.png", "smooth")
	
	local screenData = m.pos:ToScreen()
	if screenData.visible then
		
		local currentAlpha = 185
		
		if elapsed > (3.7 - 1.0) then
			currentAlpha = Lerp((elapsed - (3.7 - 1.0)) / 1.0, 185, 0)
		end

		local dist = LocalPlayer():GetPos():Distance(m.pos)
		local scale = math.Clamp(1 - (dist / 2500), 0.5, 1)
		local scaledSize = 76 * scale

		surface.SetMaterial(MAT_DEAD_ICON)
		surface.SetDrawColor(255, 255, 255, currentAlpha)
		surface.DrawTexturedRect(screenData.x - (scaledSize/2), screenData.y - (scaledSize/2), scaledSize, scaledSize)
	end
end
CoDHUD[hudtype].DeathIcon = deathicon

local function friendorfoe( ... )
	local displayName = select(1, ...)
	local finalScale = select(2, ...)
	local screenData = select(3, ...)
	local isFriendly = select(4, ...)
	local alpha = select(5, ...)
	
	local ENEMY_COLOR    = Color(210, 30, 50)  
    local FRIENDLY_COLOR = Color(60, 200, 60)
	
	local factionColor = isFriendly and FRIENDLY_COLOR or ENEMY_COLOR

	surface.SetFont("BO1_TargetName_Primary")
	local tw, th = surface.GetTextSize(displayName)
	tw, th = tw * finalScale, th * finalScale

	local drawX, drawY = screenData.x - (tw / 2), screenData.y - (th / 2)

	local matrix = Matrix()
	matrix:Translate(Vector(drawX, drawY, 0))
	matrix:Scale(Vector(finalScale, finalScale, 1))

	cam.PushModelMatrix(matrix)
		draw.SimpleText(displayName, "BO2_TargetName_Primary", 0, 0, Color(factionColor.r, factionColor.g, factionColor.b, alpha), 0, 0)
	cam.PopModelMatrix()
end
CoDHUD[hudtype].IFF = friendorfoe

local ICON_ON = Material(hudtype .. "/icons/voice_on.png", "noclamp smooth")
local ICON_DIM = Material(hudtype .. "/icons/voice_on_dim.png", "noclamp smooth")

local function voice( ... )
	local yOffset = select(1, ...)
	local ply = select(2, ...)
	
	-- Positioning Config
	local VOICE_X = 22
	local VOICE_Y_START = ScrH() * 0.30 
	local SPACING = 28 
	local ICON_SIZE = 36
	local TEXT_X_OFFSET = 2 

	local drawY = VOICE_Y_START + yOffset
	
	-- Volume check for icon swapping
	local isSpeaking = ply:VoiceVolume() > 0.05 
	local icon = isSpeaking and ICON_ON or ICON_DIM

	-- Draw Icon
	surface.SetMaterial(icon)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(VOICE_X, drawY, ICON_SIZE, ICON_SIZE)

	-- Draw Name
	draw.SimpleText(ply:Nick(), "BO1_VoiceFont", VOICE_X + ICON_SIZE + TEXT_X_OFFSET, drawY, Color(255, 255, 255), 0, 0)

	yOffset = yOffset + SPACING
end
CoDHUD[hudtype].VoiceChat = voice

-- local debugpic = true
local debugpicture = Material("debugref/bo2_2.png", "smooth")

local function weaponinfo(...)

	if debugpic then
		surface.SetMaterial(debugpicture)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	local MASK = select(1, ...)
	local ply = select(3, ...)


	local CFG = {
		-- Base Bar
		BAR_W     = 441.6, -- 256 x 1.725
		BAR_H     = 220.8, -- 128 x 1.725
		BAR_X_OFF = 446.6,
		BAR_Y_OFF = -32,

		-- Lines
		LINES_W       = 295,
		LINES_H       = 142.5,
		LINES_X_OFF   = 131,
		LINES_Y_OFF   = -20,

		-- Grenades
		GRENADE_X_OFF     = 140,
		GRENADE_Y_OFF     = 50,
		GRENADE_ICON_W    = 40,
		GRENADE_ICON_H    = 40,
		GRENADE_STACK_GAP = -4,
		GRENADE_MAX       = 4,
		GRENADE_SHADES    = { 255, 200, 175, 120 },

		-- Reserve Ammo
		RES_X       = 80,
		RES_Y       = 102.5,

		-- Text kerning
		SQUEEZE            = -6,
		SQUEEZE_ONE        = -14,
		SQUEEZE_ONE_BEFORE = -10,

		-- Weapon Name
		WEP_NAME_X_OFF = 55,
		WEP_NAME_Y_OFF = 145,
		WEP_NAME_FADE  = 2,
		WEP_NAME_SQ    = -3,
		WEP_NAME_SQ1   = -8,

		-- Status Indicator
		STAT_FONT_SIZE = 28,
		STAT_LOW_PERC  = 0.40,
		STAT_FLASH_SPD = 8,
		STAT_Y_OFF     = 62,

		-- Alt Ammo (Underbarrel / Secondary)
		ALT_TEXT_X     = 320 - 56,
		ALT_TEXT_Y     = 42,
		ALT_TEXT_SQ    = 0,

		ALT_WICON_SIZE  = 48,
		ALT_WICON_X     = 320,
		ALT_WICON_Y     = 56,
	}


	local MAT_FRAME  = Material(hudtype .. "/hud/background_weaponinfo.vmt")

	local MAT_ALT  = {
		["grenade"] = Material(hudtype .. "/icons/hud_obit_grenade_launcher_attach.png", "smooth mips"),
		["buckshot"] = Material("mw2/hud/dpad_underbarrel_shotgun.png", "smooth mips"),
	}
	
	local MAT_GRENADE = Material(hudtype .. "/icons/grenadeicon.png", "smooth")

    local barW, barH = CoDHUD_SX(CFG.BAR_W), CoDHUD_SY(CFG.BAR_H)
    local barX = ScrW() - CoDHUD_SX(CFG.BAR_X_OFF)
    local barY = ScrH() - CoDHUD_SY(CFG.BAR_Y_OFF) - barH

    surface.SetMaterial(MAT_FRAME)
    surface.SetDrawColor(255, 255, 255)
	for i = 1, 8 do
		surface.DrawTexturedRect(barX, barY, barW, barH)
	end

    -- 2. GRENADE DRAWING
    local grenadeCount = math.Clamp(ply:GetAmmoCount("Grenade") or 0, 0, CFG.GRENADE_MAX)
    if grenadeCount > 0 then
        local barW = CoDHUD_SX(CFG.BAR_W)
        local barH = CoDHUD_SY(CFG.BAR_H)
        local barX = ScrW() - CoDHUD_SX(CFG.BAR_X_OFF) - barW
        local barY = ScrH() - CoDHUD_SY(CFG.BAR_Y_OFF) - barH

        local iW = CoDHUD_S(CFG.GRENADE_ICON_W)
        local iH = CoDHUD_S(CFG.GRENADE_ICON_H)
        local stackGap = CoDHUD_S(CFG.GRENADE_STACK_GAP)

        local anchorX = ScrW() - CoDHUD_SX(CFG.GRENADE_X_OFF)
        local anchorY = ScrH() - CoDHUD_SY(CFG.GRENADE_Y_OFF)

        surface.SetMaterial(MAT_GRENADE)

        for i = (CFG.GRENADE_MAX - 1), 0, -1 do
            if i < grenadeCount then
                local colorIndex = i + 1
                local shade = CFG.GRENADE_SHADES[colorIndex] or CFG.GRENADE_SHADES[#CFG.GRENADE_SHADES]
                surface.SetDrawColor(shade, shade, shade, 255)

                local xPos = anchorX - (i * stackGap)
                local yPos = anchorY

                surface.DrawTexturedRect(xPos, yPos, iW, iH)
            end
        end
    end

    -- 3. WEAPON HUD DRAWING
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end

    if wep ~= lastWep then
        lastWep       = wep
        wepSwitchTime = CurTime()
    end

    local clip    = wep:Clip1()
    local clip2    = wep:Clip2()
    local maxClip = wep:GetMaxClip1()
    local maxClip2 = wep:GetMaxClip2()
    local primType = wep:GetPrimaryAmmoType()
    local altType = wep:GetSecondaryAmmoType()
	local altAmmoName = game.GetAmmoName(altType)
    local primCount = ply:GetAmmoCount(primType)
	local altCount = ply:GetAmmoCount(altType)

	local reloading = 
	wep.IsReloading or reloadingM203 -- CW2
	or (wep.ARC9 and wep:GetReloading()) -- ARC9
	or (wep.ArcCW and wep:GetReloading()) -- ArcCW
	or (wep.IsTFAWeapon and TFA.Enum.ReloadStatus[wep:GetStatus()]) -- TFA

	local glactive = 
	wep.dt and (wep.dt.AltActive or wep.dt.M203Active) -- CW2
	or (wep.ARC9 and wep:GetUBGL())

	if glactive then
		clip = clip2
		maxClip = maxClip2
		primCount = altCount - clip
	end

	surface.SetFont("BO2_Res")
	local restext = " / " .. primCount
	local resw, resh = surface.GetTextSize(restext)
	surface.SetFont("BO2_Res_Large")
	local clipw, cliph = surface.GetTextSize(maxClip)
	surface.SetFont("BO2_Res")

	if primType ~= -1 then
        local resCol = (primCount == 0 or primCount < maxClip) and Color(255, 120, 120, 255) or  Color(255, 255, 255, 255)
		if maxClip > 0 then
			draw.SimpleTextOutlined(restext, "BO2_Res", ScrW() - CoDHUD_SX(CFG.RES_X) - resw, ScrH() - CoDHUD_SY(CFG.RES_Y), resCol, 0, 0, outlined and 1 or 0, Color(0, 0, 0))
		else
			surface.SetFont("BO2_Res_Large")
			local restext, resw = tostring(primCount), surface.GetTextSize(primCount)
			draw.SimpleTextOutlined(primCount, "BO2_Res_Large", ScrW() - CoDHUD_SX(CFG.RES_X) - resw, ScrH() - CoDHUD_SY(CFG.RES_Y * 1.15), resCol, 0, 0, outlined and 1 or 0, Color(0, 0, 0))
			surface.SetFont("BO2_Res")
		end
    end

	surface.SetFont("BO2_Wep_Name")
	local name  = string.upper(language.GetPhrase(wep:GetPrintName() or wep:GetClass()))
	local namew, nameh = surface.GetTextSize(name)

	draw.RoundedBox( 4, ScrW() - CoDHUD_SX(CFG.WEP_NAME_X_OFF) - CoDHUD_S(namew), ScrH() - CoDHUD_SY(CFG.WEP_NAME_Y_OFF), CoDHUD_S(namew) + CoDHUD_S(8), CoDHUD_S(nameh), Color( 255, 255, 255, 100 ) )
	draw.SimpleTextOutlined(name, "BO2_Wep_Name", ScrW() - CoDHUD_SX(CFG.WEP_NAME_X_OFF), ScrH() - CoDHUD_SY(CFG.WEP_NAME_Y_OFF), Color(0, 0, 0,175), 2, 0, 1, Color(0, 0, 0, 10))

	local altCache = (altType == primType or altType == game.GetAmmoID("Grenade") and maxClip2 > 0)

    if altType ~= -1 then
		if altType ~= primType and altType ~= game.GetAmmoID("Grenade") then
			surface.SetFont("BO2_Ammo_Alt")
			local altLen = #tostring(altCount)
			local altw, alth = surface.GetTextSize(altCount)
			local altPad = (altw + (altLen * CFG.ALT_TEXT_SQ))

			local alticon = "grenade"
			if altAmmoName == "Buckshot" then alticon = "buckshot" end

			surface.SetMaterial(MAT_ALT[alticon])
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(ScrW() - CoDHUD_SX(CFG.ALT_WICON_X), ScrH() - CoDHUD_SY(CFG.ALT_WICON_Y), CoDHUD_S(CFG.ALT_WICON_SIZE), CoDHUD_S(CFG.ALT_WICON_SIZE))

			local altCol = (altCount > 0) and Color(255, 255, 255, 255) or Color(255, 120, 120, 255)
			
			draw.RoundedBox( 4, ScrW() -  CoDHUD_SX(CFG.ALT_TEXT_X), ScrH() - CoDHUD_SY(CFG.ALT_TEXT_Y), CoDHUD_S(8) + altPad, CoDHUD_S(alth), Color( 0, 0, 0, 200 ) )
			
			DrawSqueezedText(altCount, "BO2_Ammo_Alt", ScrW() -  CoDHUD_SX(CFG.ALT_TEXT_X), ScrH() - CoDHUD_SY(CFG.ALT_TEXT_Y), altCol, CFG.ALT_TEXT_SQ, CFG.ALT_TEXT_SQ, 2, CoDHUD_S(999))
		elseif maxClip2 > 0 and clip2 >= 0 then
			local perc      = clip2 / maxClip2
			local isLowClip = (perc <= CFG.STAT_LOW_PERC)
			local blink = 255 * math.abs(math.sin(RealTime() * 3))
			
			local col = Color(255, isLowClip and blink or 255, isLowClip and blink or 255)
			
			draw.SimpleTextOutlined(clip2, "BO2_Res_Large", ScrW() - CoDHUD_SX(CFG.RES_X) - resw, ScrH() - CoDHUD_SY(CFG.RES_Y * 1.15), col, 2, 0, outlined and 1 or 0, Color(0, 0, 0))
		end
    end

    if maxClip > 0 and clip >= 0 then
        local perc      = clip / maxClip
        local isLowClip = (perc <= CFG.STAT_LOW_PERC)
		local blink = 255 * math.abs(math.sin(RealTime() * 3))
		
		local col = Color(255, isLowClip and blink or 255, isLowClip and blink or 255)
		
        DrawSqueezedText(clip, "BO2_Res_Large", ScrW() - CoDHUD_SX(CFG.RES_X+(altCache and 12 or 0)) - resw - (altCache and clipw or 0), ScrH() - CoDHUD_SY(CFG.RES_Y * 1.15), col, 0, 0, 0)
    end

    if maxClip > 0 and clip >= 0 and not reloading then
        local perc      = clip / maxClip
        local statText  = ""
        local statCol   = Color(255, 255, 255)
        local isNoAmmo  = false
        local isLowAmmo = false
        local isReloadText  = false

        if clip == 0 and primCount == 0 then
            statText = "#MW2_WEAPON_NO_AMMO"
            isNoAmmo = true
        elseif perc <= CFG.STAT_LOW_PERC and primCount == 0 then
            statText = "#MW2_PLATFORM_LOW_AMMO_NO_RELOAD"
            statCol  = Color(255, 230, 0)
            isLowAmmo = true
        elseif perc <= CFG.STAT_LOW_PERC and primCount > 0 then
            statText = "#MW2_PLATFORM_RELOAD"
            isReloadText = true
        end

        if statText ~= "" then
            local cx   = ScrW() / 2
            local cy   = (ScrH() / 2) + CoDHUD_SY(CFG.STAT_Y_OFF)
            local sine = (math.sin(CurTime() * CFG.STAT_FLASH_SPD) + 1) / 2

            local finalCol = table.Copy(statCol)

            if isNoAmmo then
                local glow = 225 + (sine * 30)
                finalCol = Color(glow, 40, 40, glow)
            elseif isLowAmmo or isReloadText then
                finalCol.a = 100 + (sine * 155)
            end

            draw.SimpleTextOutlined(statText, "BO2_Stat_Font", cx + CoDHUD_SX(2), cy + CoDHUD_SY(2), finalCol, 1, 1, 1.5, Color(0, 0, 0, finalCol.a * 0.8))
        end
    end
end
CoDHUD[hudtype].WeaponInfo = weaponinfo
