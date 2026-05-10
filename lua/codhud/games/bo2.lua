CoDHUD.RegisterHUD( "bo2", "#CoDHUD.Type.bo2", true )

local hudtype = "bo2"

CoDHUD = CoDHUD or {}
CoDHUD[hudtype] = CoDHUD[hudtype] or {}
CoDHUD.Factions = CoDHUD.Factions or {}
CoDHUD.Gamemodes = CoDHUD.Gamemodes or {}

local textype = {
	-- "hud/bo1/type.wav",
	"hud/bo1/delete.wav",
}

-- [[ SPECIAL KILLFEED ICONS ]]
if CLIENT then
	killicon.Add("CoDHUD_BO1_Suicide", hudtype .. "/killfeed/death_suicide.png", Color(255, 255, 255, 0))
	killicon.Add("CoDHUD_BO1_Headshot", hudtype .. "/killfeed/death_headshot.png", Color(255, 255, 255, 0))
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
		color = Color(63, 96, 110),
		killfeedcol = Color(63, 96, 110),
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
		color = Color(82, 52, 16),
		killfeedcol = Color(82, 52, 16),
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
		color = Color(82, 52, 16),
		killfeedcol = Color(82, 52, 16),
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
		color = Color(82, 52, 16),
		killfeedcol = Color(82, 52, 16),
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
		color = Color(82, 52, 16),
		killfeedcol = Color(82, 52, 16),
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
		color = Color(82, 52, 16),
		killfeedcol = Color(82, 52, 16),
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
	sound = "hud/ui_mp_countdown_v1.mp3",
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
	local textCol   = Color(255, 255, 50, alpha)
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
	runX = runX + DrawComponent(partPlus, "BO1_Score_Plus", runX, y) + gapPlus

	for i = 1, #s_val do
		local char = s_val:sub(i, i)
		local w    = DrawComponent(char, "BO1_Score_Main", runX, y)
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
	surface.SetMaterial( Material( "bo1/settings/menu_mp_background_main2.png" ) )
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
		type = "bo_challenge",
        text = CoDHUD_ChallengeTitle(header, level),
        subtext = (sub and sub ~= "") and ResolvePrefix("MW2_CHALLENGE_", sub) or nil,
        x = CoDHUD_SX(960),
        y = CoDHUD_SY(125),
		holdTime = 2.5,

        color = Color(0,0,0),
        fonts = {
            pri = "BO1_ChalHeader",
            sub = "BO1_ChalSub",
        },
    })

    surface.PlaySound("music/bo1/stings/mp_milestone_sting.wav")
end
CoDHUD[hudtype].ChallengeComplete = challengecomplete

local function rs_obj( ... )
	local text = select(1, ...)

	CoDHUD_HeaderQueue.Push({
		type = "bo",
		writeSounds = textype,
		writeSpeed = 8,
		text = language.GetPhrase(text),
		x = CoDHUD_SX(960),
		y = CoDHUD_SY(170),
		color = Color(0, 0, 0),
		fonts = {
			pri = "BO1_RS_O_Pri",
			sec = "BO1_RS_O_Sec",
			shd = "BO1_RS_O_Shd"
		}
	})
end
CoDHUD[hudtype].RoundStartObjective = rs_obj

local function rs_title( ... )
	local text = select(1, ...)
	local glow = select(2, ...)
	local logo = select(3, ...)

	CoDHUD_HeaderQueue.Push({
		type = "bo",
		writeSounds = textype,
		writeSpeed = 8,
		text = language.GetPhrase(text),
		x = CoDHUD_SX(960),
		y = CoDHUD_SY(50),
		color = Color(0,0,0),

		iconY = CoDHUD_SY(80),
		iconSize = CoDHUD_S(134),

		fonts = {
			pri = "BO1_RS_H_Pri",
			sec = "BO1_RS_H_Sec",
			shd = "BO1_RS_H_Shd"
		},

		icon = logo
	})
end
CoDHUD[hudtype].RoundStart = rs_title

local function rs_timer( ... )
	local disp = select(1, ...)
	
	local outlined = GetConVar("codhud_enable_outlinedtext"):GetBool()

    local tx  = CoDHUD_SX(960)
    -- local ty  = CoDHUD_SY(540)
    local ty  = ScrH() * 0.5
    local syo = CoDHUD_SY(-85)

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
			draw.SimpleTextOutlined( disp, "BO1_RS_Timer", tx, ty, Color(255,255,100), 1, 1, outlined and 1 or 0, Color(0,0,0) )
		cam.PopModelMatrix()

		draw.SimpleTextOutlined( "#BO1_MP_MATCH_STARTING_IN", "BO1_RS_S_Pri", tx, ty + syo, Color(255,255,255), 1, 1, outlined and 1 or 0, Color(0,0,0) )
	end
end
CoDHUD[hudtype].RoundStartTimer = rs_timer

local function re_teams( ... )
    local teams = select(1, ...)
    local ws_result = select(2, ...)
    local ws_limit = select(3, ...)
    local re_result_glow = select(4, ...)
    local CFG = select(5, ...)

    local multiplier = 100

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
		writeSounds = textype,
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
            pri = "BO1_RE_Sc_Pri",
            sec = "BO1_RE_Sc_Sec",
            shd = "BO1_RE_Sc_Shd",
        }
    })

	-- Text
	CoDHUD_HeaderQueue.Push({
		type = "bo",
		text = ws_result,
		writeSounds = textype,
		writeSpeed = 8,
		x = CoDHUD_SX(960),
		y = CoDHUD_SY(240),
		color = re_result_glow,
		multiple = true,
		skipErase = true,
		persist = true,
		endTime = CFG.SCOREBOARD_DELAY,
		fonts = {
			pri = "BO1_RE_Re_Pri",
			sec = "BO1_RE_Re_Sec",
			shd = "BO1_RE_Re_Shd",
			sub = "BO1_ChalSub"
		}
	})

	CoDHUD_HeaderQueue.Push({
		type = "bo",
		text = ws_limit,
		writeSounds = textype,
		writeSpeed = 8,
		x = CoDHUD_SX(960),
		y = CoDHUD_SY(330),
		color = Color(135, 135, 180),
		multiple = true,
		skipErase = true,
		persist = true,
		endTime = CFG.SCOREBOARD_DELAY,
		fonts = {
			pri = "BO1_RE_Li_Pri",
			sec = "BO1_RE_Li_Sec",
			shd = "BO1_RE_Li_Shd",
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

	draw.SimpleTextOutlined( string.format( language.GetPhrase("MW2_MP_MATCH_BONUS_IS"), tostring(re_match_bonus) ), "BO1_RE_Bonus", CoDHUD_SX(960), CoDHUD_SY(720), Color(240, 250, 110, iconAlpha), 1, 1, outlined and 1 or 0, Color(0,0,0, iconAlpha) )
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
	local animtime = select(1, ...)
	local scoreTime = select(2, ...)
	local finalAlpha = select(3, ...)
	local scoreScale = select(4, ...)
	local currentPulseAlpha = select(5, ...)
	local scoreVal = select(6, ...)

	local outlined = GetConVar("codhud_enable_outlinedtext"):GetBool()

	local cx, cy = ScrW() / 2, ScrH() / 2
	local drawAlpha = (currentPulseAlpha / 255) * finalAlpha
	local drawY     = cy - CoDHUD_SY(140)

	local mat = Matrix()
	mat:Translate(Vector(cx, drawY, 0))
	mat:Scale(Vector(scoreScale, scoreScale, 1))
	mat:Translate(Vector(-cx, -drawY, 0))

	cam.PushModelMatrix(mat)
		DrawSqueezedScore(scoreVal, cx, drawY, drawAlpha)
	cam.PopModelMatrix()
end
CoDHUD[hudtype].XP = xp

local function dmg_dir( ... )
	local attackers = select(1, ...)
	local ply = select(2, ...)

    local cx, cy = ScrW() / 2, ScrH() / 2
	local matDamage = Material(hudtype .. "/icons/hit_direction.png", "mips smooth")

	for i = #attackers, 1, -1 do
		local v = attackers[i]

		-- Fade Logic
		if CurTime() > v.time - 1 then 
			v.alpha = math.Approach(v.alpha, 0, FrameTime() * 400)
			if v.alpha <= 0 then table.remove(attackers, i) continue end
		end

		-- Live Tracking: If they are still alive, grab their new position
		local targetWorldPos = v.trackPos
		if IsValid(v.ent) then
			-- Re-apply stability offset
			targetWorldPos = v.ent:GetPos() + (ply:GetPos() - v.ent:GetPos()) * -33000
		end

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
	end
end
CoDHUD[hudtype].DamageDirection = dmg_dir

local function grenade_dir( ... )
	local showIcon = select(1, ...)
	local nearEnts = select(2, ...)
	local ply = select(3, ...)

    local cx, cy = ScrW() / 2, ScrH() / 2

	local matIcon = Material(hudtype .. "/hud/grenadeicon.png", "mips smooth")
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

        surface.SetFont("BO1_KillfeedFont")

		local attackerEnt = data.attackerEnt
		local victimEnt = data.victimEnt

		local aColBase = GetFactionColor(attackerEnt)
		local vColBase = GetFactionColor(victimEnt)

		local aCol = Color(aColBase.r, aColBase.g, aColBase.b, finalTxtAlpha)
		local vCol = Color(vColBase.r, vColBase.g, vColBase.b, finalTxtAlpha)

        if data.type == "kill" then
			local ICON_BOX_W = iconW
			local ICON_BOX_H = iconH

			local cls = data.isHeadshot and "CoDHUD_BO1_Headshot" or data.weaponClass
			local w, h = killicon.GetSize(cls)

			if not w or w <= 0 then w = ICON_BOX_W end
			if not h or h <= 0 then h = ICON_BOX_H end

			local gap = CoDHUD_S(10)

			-- 1. Attacker
			if data.attackerName != "" then
				draw.SimpleText(data.attackerName, "BO1_KillfeedFont", x, currentY, aCol)

				local tw, _ = surface.GetTextSize(data.attackerName)
				x = x + tw
			end

			-- 2. Icon
			local iconY = currentY + (ICON_BOX_H - h) * 0.5

			local alpha = math.min(165 * fadeFactor, 255)

			local offsetX = CoDHUD_S(0)
			local offsetY = CoDHUD_S(-15)

			if cls == "CoDHUD_BO1_Headshot" then
				offsetY = CoDHUD_S(-2)
			end

			-- surface.SetDrawColor(255,255,255,alpha)
			-- surface.DrawRect(x + gap + offsetX, iconY + (h * 0.33) + offsetY, w, h)
			
			killicon.Render(x + gap + offsetX, iconY + (h * 0.33) + offsetY, cls, alpha, false, false)

			x = x + w + (gap * 2)

			-- 3. Victim
			draw.SimpleText(data.victimName, "BO1_KillfeedFont", x, currentY, vCol)
        else
            draw.SimpleText(data.msg, "BO1_KillfeedFont", x, currentY, Color(255, 255, 255, finalTxtAlpha))
        end
    end
end
CoDHUD[hudtype].Killfeed = killfeed