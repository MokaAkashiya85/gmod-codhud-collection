---- [ CLIENT CHALLENGE & STAT TRACKING ] ----

CoDHUD_Stats = CoDHUD_Stats or {}
CoDHUD_LastLevelup = CoDHUD_LastLevelup or nil

local STATS_FILE = "codhud_stats.json"

local defaultStats = {
    huds = {},
    challengescompleted = {}
}

-- HELPERS
local function EnsureHUDEntry(hud)
    hud = hud or CoDHUD_GetHUDType()

	CoDHUD_Stats.huds = CoDHUD_Stats.huds or {}

	CoDHUD_Stats.huds[hud] = CoDHUD_Stats.huds[hud] or {
        kills = 0,
        deaths = 0,
        headshots = 0,

        xp = 0,

        level = {
            level = 1,
            name = "",
            short = "0",
            nextxp = 0
        },

        weaponkills = {},
        weaponheadshots = {}
    }

    return CoDHUD_Stats.huds[hud]
end

local function PushClientStats()
    local stats = EnsureHUDEntry()

    net.Start("CoDHUD_ClientFullSync")
        net.WriteTable({
            hud = CoDHUD_GetHUDType(),
            kills = stats.kills,
            deaths = stats.deaths,
            headshots = stats.headshots,
            xp = stats.xp,
            level = stats.level,
            weaponkills = stats.weaponkills,
            weaponheadshots = stats.weaponheadshots,
            challenges = CoDHUD_Stats.challengescompleted
        })
    net.SendToServer()
end

function CoDHUD_GetStats(hud)
    return EnsureHUDEntry(hud)
end

-- LEVEL HELPERS
local function GetHUDLevelData(hud)
    hud = hud or CoDHUD_GetHUDType()

    if not CoDHUD[hud] then return nil end
    if not CoDHUD[hud].Levels then return nil end

    return CoDHUD[hud].Levels
end

function CalculateLevelFromXP(xp, hud)
    local levels = GetHUDLevelData(hud or CoDHUD_GetHUDType())

    if not levels then
        return 1, nil
    end

    local bestLevel = 1
    local bestData = levels[1]

    for lvl, data in pairs(levels) do
        local minXP = data[2]

        if xp >= minXP and lvl >= bestLevel then
            bestLevel = lvl
            bestData = data
        end
    end

    return bestLevel, bestData
end

function CoDHUD_UpdateLevel(forceHUD)
    local hud = forceHUD or CoDHUD_GetHUDType()
    local stats = EnsureHUDEntry(hud)
    local oldLevel = stats.level.level or 0
    local newLevel, levelData = CalculateLevelFromXP(stats.xp or 0, hud)
    if not levelData then return end

	stats.level = {
		level = newLevel,
		name = language.GetPhrase(levelData[4]),
		short = levelData[1],
		nextxp = levelData[6],
		icon = levelData[5]
	}

    -- Promotion detected
	if newLevel > oldLevel then
		local logoPath = CoDHUD[hud].LevelData.materialpath .. levelData[5]
		local rankString = CoDHUD[hud].LevelData.nameprefix .. levelData[4]

		local localizedRank = language.GetPhrase(rankString)
		local rankMaterial = Material(logoPath .. ".png", "smooth")

		-- STORE LAST PROMOTION
		CoDHUD_LastLevelup = { hud = hud, name = localizedRank, level = newLevel, material = rankMaterial }

		if CoDHUD[hud] and CoDHUD[hud].Levelup then
			CoDHUD[hud].Levelup( localizedRank, newLevel, rankMaterial )
		end
	end

    CoDHUD_SaveStats()
end

function CoDHUD_SaveStats()
    file.Write( STATS_FILE, util.TableToJSON(CoDHUD_Stats, true) )
end

-- LOAD
if file.Exists(STATS_FILE, "DATA") then
    local raw = file.Read(STATS_FILE, "DATA")
    CoDHUD_Stats = util.JSONToTable(raw) or table.Copy(defaultStats)
else
    CoDHUD_Stats = table.Copy(defaultStats)
end

CoDHUD_Stats = CoDHUD_Stats or {}
CoDHUD_Stats.challengescompleted = CoDHUD_Stats.challengescompleted or {}

EnsureHUDEntry()

-- LOCAL UPDATE HELPERS
function CoDHUD_AddXP(amount)
    local stats = EnsureHUDEntry()

    stats.xp = (stats.xp or 0) + amount

    hook.Run("CoDHUD_XPAdded", amount)

    CoDHUD_UpdateLevel()

    net.Start("CoDHUD_ClientStatUpdate")
        net.WriteString("xp")
        net.WriteInt(amount, 32)
    net.SendToServer()

    -- PushClientStats()
end

function CoDHUD_AddKill(amount)
    -- local stats = EnsureHUDEntry()
    -- stats.kills = (stats.kills or 0) + amount

    net.Start("CoDHUD_ClientStatUpdate")
        net.WriteString("kill")
        net.WriteInt(amount, 32)
    net.SendToServer()
end

function CoDHUD_AddDeath(amount)
    -- local stats = EnsureHUDEntry()
    -- stats.deaths = (stats.deaths or 0) + amount

    net.Start("CoDHUD_ClientStatUpdate")
        net.WriteString("death")
        net.WriteInt(amount, 32)
    net.SendToServer()
end

hook.Add("CoDHUD_StatAdded", "CoDHUD_StatAdded_Handler", function(stat, amount)
    if stat == "kills" then
        CoDHUD_AddKill(amount)
    elseif stat == "deaths" then
        CoDHUD_AddDeath(amount)
    elseif stat == "xp" then
        CoDHUD_AddXP(amount)
    end
end)

function CoDHUD_AddStat(amount, stat)
    local stats = EnsureHUDEntry()
    stats[stat] = (stats[stat] or 0) + amount
    
    -- net.Start("CoDHUD_ClientStatUpdate")
    --     net.WriteString(stat)
    --     net.WriteInt(amount, 32)
    -- net.SendToServer()

    hook.Run("CoDHUD_StatAdded", stat, amount)
end

function CoDHUD_CompleteChallenge(id)
    CoDHUD_Stats.challengescompleted[id] = true

    CoDHUD_SaveStats()

    net.Start("CoDHUD_ClientCompletedChallenge")
        net.WriteString(id)
    net.SendToServer()
end

-- SEND FULL FILE TO SERVER
hook.Add("InitPostEntity", "CoDHUD_SendStatsToServer", function()
    timer.Simple(2, function()
        net.Start("CoDHUD_SendFullStats")
            net.WriteTable(CoDHUD_Stats)
        net.SendToServer()
    end)
end)

concommand.Add("codhud_rank_clear", function()
    CoDHUD_Stats.huds = {}
	
	if CoDHUD_Stats and CoDHUD_Stats.huds and CoDHUD_Stats.huds[CoDHUD_GetHUDType()] then
		CoDHUD_Stats.huds[CoDHUD_GetHUDType()] = {}
	end
    CoDHUD_SaveStats()
    print("[CoDHUD] Cleared Client Rank and Stats.")
	CoDHUD_AddKillfeedMessage("CoDHUD.System.RankReset")
	
	net.Start("CoDHUD_SendFullStats")
		net.WriteTable(CoDHUD_Stats)
	net.SendToServer()
end)

---[[ DEBUGGING AREA ]]
CreateConVar( "codhud_debug_progress", "0", FCVAR_ARCHIVE )

CreateConVar("codhud_replay_levelup", "0", FCVAR_ARCHIVE)

cvars.AddChangeCallback("codhud_replay_levelup", function(_, _, newValue)
    if tonumber(newValue) ~= 1 then return end

    if not CoDHUD_LastLevelup then
        print("[CoDHUD] No cached level-up notification to replay.")
        return
    end

    local data = CoDHUD_LastLevelup
    local hud = data.hud

    if CoDHUD[hud] and CoDHUD[hud].Levelup then
        CoDHUD[hud].Levelup(
            data.name,
            data.level,
            data.material
        )

        print("[CoDHUD] Replayed last level-up notification.")
    end

    RunConsoleCommand("codhud_replay_levelup", "0")
end, "CoDHUD_ReplayLevelup")


local lastXPTime = 0
local lastXPAmount = 0

-- XP TRACKING
hook.Add("CoDHUD_XPAdded", "CoDHUD_DebugXPTracker", function(amount)
    lastXPTime = CurTime()
    lastXPAmount = amount
end)

-- HELPERS
local function CountCompletedChallenges()
    local tbl = CoDHUD_Stats and CoDHUD_Stats.challengescompleted or {}

    local count = 0

    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

local function GetCurrentHUDStats()
    if not CoDHUD_GetStats then return nil end

    return CoDHUD_GetStats()
end

local function GetXPToNext(stats)
    if not stats or not stats.level then
        return 0
    end

    local nextXP = stats.level.nextxp or 0
    local currentXP = stats.xp or 0

    return math.max(nextXP - currentXP, 0)
end

local function SecondsSinceLastXP()
    if lastXPTime <= 0 then
        return "Never"
    end

    return string.format("%.1fs ago", CurTime() - lastXPTime)
end

net.Receive("CoDHUD_OnDeath", function()
    local target = net.ReadEntity()
    local attacker = net.ReadEntity()
    local inflictor = net.ReadEntity()
    local isHeadshot = net.ReadBool()
    local additionalData = net.ReadTable()

    if not IsValid( target ) then return end

    local isLPTar = IsValid( target ) and target:IsPlayer() and target == LocalPlayer()
    local isLPAt = IsValid( attacker ) and attacker:IsPlayer() and attacker == LocalPlayer()

    if isLPTar then
        CoDHUD_AddStat(1, "deaths")
    elseif isLPAt then
        if IsValid( target ) and ( target:IsNPC() or target:IsNextBot() ) then return end
        
        if isHeadshot then
            CoDHUD_AddStat( 1, "headshots" )
        end
        CoDHUD_AddStat( 1, "kills" )
    end
end)

-- net.Receive("CoDHUD_OnDamage", function()
--     local target = net.ReadEntity()
--     local attacker = net.ReadEntity()
--     local isKill = net.ReadBool()

--     print( "OnDamage", target, attacker, isKill )

--     if not IsValid(target) or not IsValid(attacker) then return end

--     local isLPTar = target == LocalPlayer()
--     local isLPAt = attacker == LocalPlayer()

--     if isLPAt then
--         if isKill then
--             CoDHUD_AddStat(1, "kills")
--         end
--     elseif isLPTar then
--         if isKill then
--             CoDHUD_AddStat(1, "deaths")
--         end
--     end
-- end)

-- DEBUG HUD
hook.Add("HUDPaint", "CoDHUD_DebugProgressOverlay", function()
    if not GetConVar("codhud_debug_progress"):GetBool() then return end

    local stats = GetCurrentHUDStats()
    if not stats then return end
	
    local hud = CoDHUD_GetHUDType()
    local levelData = stats.level or {}
	
	local rankprefix = CoDHUD[hud].LevelData and CoDHUD[hud].LevelData.nameprefix or ""
	
    local lines = {
        "=== CoDHUD Progress Debug ===",

        "",

        "HUD: " .. tostring(hud),

        "",

        "Rank Index: " .. tostring(levelData.level or 0),
        "Rank Name: " .. tostring(language.GetPhrase(rankprefix .. levelData.name or "UNKNOWN")),

        "",

        "Current XP: " .. tostring(stats.xp or 0),
        "Next Rank XP: " .. tostring(levelData.nextxp or 0),
        "XP Remaining: " .. tostring(GetXPToNext(stats)),

        "",

        "Last XP Gain: +" .. tostring(lastXPAmount),
        "Last XP Time: " .. SecondsSinceLastXP(),

        "",

        "Kills: " .. tostring(stats.kills or 0),
        "Deaths: " .. tostring(stats.deaths or 0),
        "Headshots: " .. tostring(stats.headshots or 0),

        "",

        "Completed Challenges: " .. tostring(CountCompletedChallenges())
    }

    -- Optional challenge listing
    local completed = CoDHUD_Stats and CoDHUD_Stats.challengescompleted

    if completed and table.Count(completed) > 0 then
        table.insert(lines, "")
        table.insert(lines, "-- Challenges --")

        local added = 0

        for id in pairs(completed) do
            table.insert(lines, "• " .. id)

            added = added + 1

            -- Prevent screen spam
            if added >= 15 then
                table.insert(lines, "...")
                break
            end
        end
    end

    -- DRAW
    surface.SetFont("Trebuchet18")

    local padding = 12
    local lineH = 20

    local widest = 0

    for _, str in ipairs(lines) do
        local w = surface.GetTextSize(str)

        widest = math.max(widest, w)
    end

    local boxW = widest + padding * 2
    local boxH = (#lines * lineH) + padding * 2

    local x = ScrW() - CoDHUD_SY(240)
    local y = CoDHUD_SX(240)

    draw.RoundedBox( 8, x, y, boxW, boxH, Color(0, 0, 0, 220) )

    surface.SetDrawColor(255, 180, 0, 255)
    surface.DrawOutlinedRect(x, y, boxW, boxH, 2)

    local ty = y + padding

    for _, str in ipairs(lines) do
        draw.SimpleText( str, "Trebuchet18", x + padding, ty, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        ty = ty + lineH
    end
end)

-- LEVEL LIST DEBUG PANEL
hook.Add("HUDPaint", "CoDHUD_DebugLevelList", function()
    if not GetConVar("codhud_debug_progress"):GetBool() then return end

    local hud = CoDHUD_GetHUDType()

    if not CoDHUD[hud] then return end
    if not CoDHUD[hud].Levels then return end
    if not CoDHUD[hud].LevelData then return end

    local levels = CoDHUD[hud].Levels
    local materialPath = CoDHUD[hud].LevelData.materialpath or ""

    -- SORT LEVELS
    local sorted = {}

    for lvl, data in pairs(levels) do
        table.insert(sorted, {
            level = lvl,
            data = data
        })
    end

    table.sort(sorted, function(a, b)
        return a.level < b.level
    end)

    -- LAYOUT
    local rowsPerColumn = #levels / 2 + 1

    local rowH = 14
    local iconSize = 14

    local padding = 15
    local titleH = 20

    local columnWidth = 260

    local totalColumns = math.ceil(#sorted / rowsPerColumn)

    local boxW = (columnWidth * totalColumns) + (padding * 2)
    local boxH = (rowsPerColumn * rowH) + titleH + padding

    local x = 40
    local y = 200

    -- BACKGROUND
    draw.RoundedBox(8, x, y, boxW, boxH, Color(0, 0, 0, 220))
    surface.SetDrawColor(255, 180, 0, 255)
    surface.DrawOutlinedRect(x, y, boxW, boxH, 2)

    -- TITLE
    draw.SimpleText( "=== LEVEL LIST ===", "Trebuchet18", x + padding, y + 6, Color(255, 200, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    -- DRAW LEVELS
    for index, entry in ipairs(sorted) do
        local lvl = entry.level
        local data = entry.data

        local localizedName = language.GetPhrase(CoDHUD[hud].LevelData.nameprefix .. data[4] or "UNKNOWN")
        local icon = Material( materialPath .. (data[5] or "") .. ".png", "smooth" )

        -- COLUMN/POSITION
        local column = math.floor((index - 1) / rowsPerColumn)
        local row = (index - 1) % rowsPerColumn

        local drawX = x + padding + (column * columnWidth)
        local drawY = y + titleH + (row * rowH)

        -- ICON
        if icon then
            surface.SetMaterial(icon)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect( drawX, drawY + 2, iconSize, iconSize )
        end

        -- TEXT
        draw.SimpleText( string.format("%02d | %s", lvl, localizedName), "Trebuchet18", drawX + iconSize + 8, drawY + 1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end
end)