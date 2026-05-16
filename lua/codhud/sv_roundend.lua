---- [ SERVER ROUND END ] ----

local RE_Triggered     = false
local RE_ThinkThrottle = 0

codhud_enable_roundend = CreateConVar("codhud_enable_roundend", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Enable or disable the MW2 round end screen.")
codhud_enable_roundend_StartNext = CreateConVar("codhud_enable_roundend_startnext", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Immediately starts a new 'Round' once the current one ends.")

CoDHUD_RoundEnding = false
CoDHUD_RoundEndTimeSV = nil

local function CoDHUD_DoRoundEnd(winnerFaction, loserFaction, winnerScore, loserScore)
    if RE_Triggered then return end
	RE_Triggered = true

	timer.Simple( 0.05, function()
		net.Start("CoDHUD_RoundEnd")
			net.WriteString(winnerFaction or "")
			net.WriteString(loserFaction or "")
			net.WriteInt(winnerScore or 0, 32)
			net.WriteInt(loserScore or 0, 32)
		net.Broadcast()
		
		CoDHUD_RoundEnding = true
		
		for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) then
                if ply:Alive() then
                    ply:Freeze(true)
                end
            end
        end
	end)
	
    -- Calculate the approximate center of the map
    local spawns = ents.FindByClass("info_player_start")
    table.Add(spawns, ents.FindByClass("info_player_terrorist"))
    table.Add(spawns, ents.FindByClass("info_player_counterterrorist"))
    if #spawns == 0 then
        for _, p in ipairs(player.GetAll()) do
            table.insert(spawns, p)
        end
    end

    local mapCenter = Vector(0, 0, 0)
    if #spawns > 0 then
        for _, spawn in ipairs(spawns) do
            mapCenter = mapCenter + spawn:GetPos()
        end
        mapCenter = mapCenter / #spawns
    end

    -- Delay the kill and camera placement by 6 seconds
    timer.Simple(6, function()
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) then
                if ply:Alive() then
					ply:Freeze(false) -- To be safe
                    ply:StripWeapons()
                    ply:KillSilent()
                end
                
                ply:Spectate(OBS_MODE_ROAMING)
                
                if #spawns > 0 then
                    local randEnt = spawns[math.random(1, #spawns)]
                    if IsValid(randEnt) then
                        -- Target 800 units above the spawn point
                        local targetPos = randEnt:GetPos() + Vector(0, 0, 800)
                        
                        -- Trace upwards to prevent putting the camera out of bounds/in the skybox
                        local tr = util.TraceLine({
                            start = randEnt:GetPos(),
                            endpos = targetPos,
                            mask = MASK_SOLID_BRUSHONLY
                        })
                        
                        -- Place slightly below the ceiling hit
                        local finalPos = tr.HitPos - Vector(0, 0, 64)
                        ply:SetPos(finalPos)
                        
                        -- Angle the camera down towards the calculated map center
                        local dir = (mapCenter - finalPos):GetNormalized()
                        ply:SetEyeAngles(dir:Angle())
                    end
                end
            end
        end
    end)
			
	CoDHUD_RoundEndTimeSV = nil

    -- Respawn all players 10 seconds after the client screen triggers
    timer.Simple(15, function()
		if GetConVar("codhud_enable_roundend_startnext"):GetBool() then
			local gamemode = CoDHUD_ActiveGamemode or "war"
			local matchtimer = GetConVar("codhud_matchstart_timer"):GetInt()
			local maxtimer = GetConVar("codhud_time_limit"):GetFloat()

			CoDHUD_FirstBloodOccurred = false

			CoDHUD_RoundStarting = true
			CoDHUD_RoundStartTimer = CurTime() + matchtimer

			timer.Remove("CoDHUD_RoundStartTime")

			if maxtimer > 0 then
				CoDHUD_RoundEndTimeSV = CurTime() + (matchtimer + 1) + (maxtimer * 60)
			end

			for _, p in ipairs(player.GetAll()) do
				if IsValid(p) then
					p:SetFrags(0)
					p:SetDeaths(0)
					p:Spawn()
					p:Freeze(true)
				end
			end

			net.Start("CoDHUD_RoundStart")
				net.WriteString(gamemode)
				net.WriteInt(matchtimer, 6)
				net.WriteInt(maxtimer, 32)
				net.WriteFloat(CoDHUD_RoundEndTimeSV or 0)
			net.Broadcast()

			timer.Create("CoDHUD_RoundStartTime", matchtimer, 1, function()

				CoDHUD_RoundStarting = false
				CoDHUD_RoundStartTimer = nil
                _G.CoDHUD_RoundActive = true

				for _, p in ipairs(player.GetAll()) do
					if IsValid(p) then
						p:Freeze(false)
					end
				end
			end)
		else
            _G.CoDHUD_ActiveGamemode = "dm"
            _G.CoDHUD_RoundActive = false
			for _, ply in ipairs(player.GetAll()) do
				if IsValid(ply) then
					ply:SetFrags(0)
					ply:UnSpectate()
					ply:Spawn()
				end
			end
		end
		RE_Triggered = false
		CoDHUD_RoundEnding = false
    end)
end

hook.Add("Think", "CoDHUD_RoundEnd_ScoreCheck", function()
    if not _G.CoDHUD_RoundActive then return end
	if CoDHUD_RoundStarting then return end
	if not GetConVar("codhud_enable_roundend"):GetBool() then return end

    if RE_Triggered then return end

    local now = CurTime()
    if now < RE_ThinkThrottle then return end
    RE_ThinkThrottle = now + 0.5

    local limitCV = GetConVar("codhud_score_limit")
    if not limitCV then return end

    local scoreLimit = limitCV:GetInt()
    if scoreLimit <= 0 then
        scoreLimit = 75
    end

    -- Build faction scores
    local factionScores = {}

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) then continue end

        local faction = ply:GetNW2String("CoDHUD_Faction", "")
        if faction == "" then
            faction = "rangers"
        end

        local score = math.max(0, ply:Frags())

        factionScores[faction] = (factionScores[faction] or 0) + score
    end

    -- Determine if any faction reached the score limit
    local winnerFaction = nil
    local winnerScore = 0

    for faction, score in pairs(factionScores) do
        if score >= scoreLimit then
            winnerFaction = faction
            winnerScore = score
            break
        end
    end

    if not winnerFaction then return end

    -- Find highest enemy faction
    local loserFaction = ""
    local loserScore = 0

    for faction, score in pairs(factionScores) do
        if faction ~= winnerFaction and score > loserScore then
            loserFaction = faction
            loserScore = score
        end
    end

    CoDHUD_DoRoundEnd(winnerFaction, loserFaction, winnerScore, loserScore)
end)

hook.Add("Think", "CoDHUD_RoundEnd_TimeLimit", function()
    if not _G.CoDHUD_RoundActive then return end
	if CoDHUD_RoundStarting then return end
    if not GetConVar("codhud_enable_roundend"):GetBool() then return end
    if RE_Triggered then return end
	if not CoDHUD_RoundEndTimeSV then return end
	if CurTime() < CoDHUD_RoundEndTimeSV then return end

    local factionScores = {}

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        local faction = ply:GetNW2String("CoDHUD_Faction", "rangers")
        local score   = math.max(0, ply:Frags())
        factionScores[faction] = (factionScores[faction] or 0) + score
    end

    local winnerFaction, winnerScore = nil, -1

    for faction, score in pairs(factionScores) do
        if score > winnerScore then
            winnerFaction = faction
            winnerScore = score
        end
    end

    local loserFaction, loserScore = "", 0

    for faction, score in pairs(factionScores) do
        if faction ~= winnerFaction then
            loserFaction = faction
            loserScore = score
            break
        end
    end

    CoDHUD_DoRoundEnd(winnerFaction, loserFaction, winnerScore, loserScore)
end)

hook.Add("PlayerDeathThink", "CoDHUD_RE_PreventRespawn", function(ply)
    if RE_Triggered then return false end
end)