---- [ CLIENT SCOREBAR ] ----

local function GetFactionScore(faction)
    local total = 0

    for _, p in ipairs(player.GetAll()) do
        if p:GetNW2String("CoDHUD_Faction", "") == faction then
            total = total + math.max(0, p:Frags())
        end
    end

    return total
end

local function GetScorebarData()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local str = CoDHUD[CoDHUD_GetHUDType()].TextStrings
    local data = {}

    local gm = CoDHUD_ActiveGamemodeCL or "war"
    local isDM = (gm == "dm")

    -- RAW TIME
    local remaining = math.max(0, CoDHUD_RoundEndTime - CurTime())
    data.timeRaw = remaining
    data.timeAlive = remaining > 0

    -- TIME STRING
    local mins = math.floor(remaining / 60)
    local secs = math.floor(remaining % 60)
    local baseTime = string.format("%d:%02d", mins, secs)

    if remaining < 30 and remaining > 0 then
        local tenths = math.floor((remaining % 1) * 10)
        data.timeStr = string.format("%s.%d", baseTime, tenths)
    else
        data.timeStr = baseTime
    end

    data.mins = mins

    if isDM then -- FFA
        local players = {}

        for _, p in ipairs(player.GetAll()) do
            if IsValid(p) then
                table.insert(players, { ply = p, score = math.max(0, p:Frags()) })
            end
        end

        table.sort(players, function(a, b)
            return a.score > b.score
        end)

        data.dmLeaderboard = players

        local myScore = math.max(0, ply:Frags())
        data.clientScore = myScore

        local myIndex = 1
        for i, v in ipairs(players) do
            if v.ply == ply then
                myIndex = i
                break
            end
        end

        data.dmPlacement = myIndex

        local enemy = players[myIndex + 1]
        data.enemyScore = enemy and enemy.score or 0
        data.enemyPlayer = enemy and enemy.ply or nil
    else -- TDM
        local factionScores = {}

        for _, p in ipairs(player.GetAll()) do
            local f = p:GetNW2String("CoDHUD_Faction", "")
            if f ~= "" then
                factionScores[f] = (factionScores[f] or 0) + math.max(0, p:Frags())
            end
        end

        local sortedFactions = {}
        for faction, score in pairs(factionScores) do
            table.insert(sortedFactions, { faction = faction, score = score })
        end

        table.sort(sortedFactions, function(a, b)
            return a.score > b.score
        end)

        local myFaction = ply:GetNW2String("CoDHUD_Faction", "")
        data.clientScore = factionScores[myFaction] or 0

        local enemyFactionData = nil
        for _, v in ipairs(sortedFactions) do
            if v.faction ~= myFaction then
                enemyFactionData = v
                break
            end
        end

        data.enemyScore = enemyFactionData and enemyFactionData.score or 0
        data.enemyFaction = enemyFactionData and enemyFactionData.faction or nil
    end

    -- STATUS (shared)
    local COL_WINNING = Color(110, 220, 120, 255)
    local COL_LOSING  = Color(215, 110, 120, 255)
    local COL_TIE     = Color(230, 230, 110, 255)

    data.statusText = str.scorebar.tied or "MW2_MPUI_TIED_CAPS"
    data.statusCol  = COL_TIE
    data.statusLosing = false

    if data.clientScore > data.enemyScore then
        data.statusText = str.scorebar.winning or "MW2_MPUI_WINNING_CAPS"
        data.statusCol  = COL_WINNING
    elseif data.clientScore < data.enemyScore then
        data.statusText = str.scorebar.losing or "MW2_MPUI_LOSING_CAPS"
        data.statusCol  = COL_LOSING
        data.statusLosing = true
    end

    return data
end

hook.Add("HUDPaint", "CoDHUD_Scorebar", function()
    if (not GetConVar("codhud_enable_scorebar"):GetBool()) or GetConVar("codhud_quickdisable_hud"):GetBool() then return end
    if not GetConVar("cl_drawhud"):GetBool() then return end

    local ply = LocalPlayer()
    -- if not IsValid(ply) or not ply:Alive() then return end
    if not IsValid(ply) then return end

    if CoDHUD[CoDHUD_GetHUDType()] and CoDHUD[CoDHUD_GetHUDType()].Scorebar then
        local data = GetScorebarData()
        if data then
            CoDHUD[CoDHUD_GetHUDType()].Scorebar(data)
        end
    end
end)