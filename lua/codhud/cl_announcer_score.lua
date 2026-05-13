---- [ CLIENT ANNOUNCER CALLOUTS ] ----

local LastScoreState = "tied"
local NearEndTriggered = false
local MusicTriggered = false
CoDHUD_HadAbove60 = CoDHUD_HadAbove60 or false
CoDHUD_HadAbove30 = CoDHUD_HadAbove30 or false
CoDHUD_LowTimeTriggered = CoDHUD_LowTimeTriggered or false
CoDHUD_TimerLastPlay = CoDHUD_TimerLastPlay or 0
CoDHUD_ActiveTimerTier = CoDHUD_ActiveTimerTier or nil

local function CoDHUD_GetFactionScores(ply)
    local lpFaction = ply:GetNW2String("CoDHUD_Faction", "")
    if lpFaction == "" then
        lpFaction = cookie.GetString("CoDHUD_SelectedFaction", "rangers")
    end

    local factionScores = {}

    for _, p in ipairs(player.GetAll()) do
        local faction = p:GetNW2String("CoDHUD_Faction", "")
        if faction == "" then
            faction = cookie.GetString("CoDHUD_SelectedFaction", "rangers")
        end

        local score = math.max(0, p:Frags())
        factionScores[faction] = (factionScores[faction] or 0) + score
    end

    local myScore = factionScores[lpFaction] or 0

    local bestEnemyScore = 0
    for faction, score in pairs(factionScores) do
        if faction ~= lpFaction and score > bestEnemyScore then
            bestEnemyScore = score
        end
    end

    return myScore, bestEnemyScore, lpFaction
end

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
        return a.score > b.score
    end)

    return players
end

local function CoDHUD_GetDMPlayerState(ply)
    local placements = CoDHUD_GetDMPlacements()

    local myPlace = nil
    local myScore = math.max(0, ply:Frags())
    local firstScore = 0

    if placements[1] then
        firstScore = placements[1].score or 0
    end

    for k, v in ipairs(placements) do
        if v.ply == ply then
            myPlace = k
            break
        end
    end

    return myPlace, myScore, firstScore
end

hook.Add("Think", "CoDHUD_Announcer_Score_Think", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
	local hudType = CoDHUD_GetHUDType()
	if not CoDHUD or not hudType or not CoDHUD[hudType] then return end

	local voicefile = CoDHUD[hudType].VoiceCallouts
	if not voicefile then return end
	local isDM = (CoDHUD_ActiveGamemodeCL == "dm")

    -- 1. Retrieve current faction and voice tag
    local currentFaction = ply:GetNW2String("CoDHUD_Faction", "")
    if currentFaction == "" then
        currentFaction = cookie.GetString("CoDHUD_SelectedFaction", "rangers")
    end

    if not CoDHUD.Factions[CoDHUD_GetHUDType()] or not CoDHUD.Factions[CoDHUD_GetHUDType()][currentFaction] then return end

    -- 2. Calculate Scores
	local myScore
	local bestEnemyScore

	if isDM then
		local myPlace, score, firstScore = CoDHUD_GetDMPlayerState(ply)

		myScore = score
		bestEnemyScore = firstScore

		-- DM does not use team-based announcer states
		if myPlace == nil then return end
	else
		myScore, bestEnemyScore = CoDHUD_GetFactionScores(ply)
	end

    -- 3. Reset logic for new rounds
    if myScore == 0 and bestEnemyScore == 0 then
        LastScoreState = "tied"
        NearEndTriggered = false
        MusicTriggered = false
        return
    end

    -- 4. Get Replicated Score Limit
    local limit = GetConVar("codhud_score_limit"):GetInt()
    if not limit or limit <= 0 then limit = 75 end

    -- 5. Music Trigger (Passing 'true' to indicate this is music)
    if not MusicTriggered then
        if (limit - myScore) <= (limit * 0.25) and myScore > 0 then
            MusicTriggered = true
            CoDHUD_PlayAnnouncerSound(voicefile.winningmusic, true)
        elseif (limit - bestEnemyScore) <= (limit * 0.25) and bestEnemyScore > 0 then
            MusicTriggered = true
            CoDHUD_PlayAnnouncerSound(voicefile.losingmusic, true)
        end
    end

    -- 6. Near End Announcer
    if not NearEndTriggered then
        if (limit - myScore) <= (limit * 0.25) and myScore > bestEnemyScore and myScore > 0 then
            NearEndTriggered = true
			local sound = CoDHUD_GetAnnouncerSound(voicefile.winningfight)

			if sound then CoDHUD_PlayAnnouncerSound(sound, false) end

        elseif (limit - bestEnemyScore) <= (limit * 0.25) and bestEnemyScore > myScore and bestEnemyScore > 0 then
            NearEndTriggered = true
			local sound = CoDHUD_GetAnnouncerSound(voicefile.losingfight)
			if sound then CoDHUD_PlayAnnouncerSound(sound, false) end
        end
    end

	if CoDHUD_ActiveGamemodeCL == "dm" then return end

    -- 7. General Score State Triggers
    local currentState = "tied"
    if myScore > bestEnemyScore then 
        currentState = "winning"
    elseif myScore < bestEnemyScore then 
        currentState = "losing"
    end

    if currentState ~= LastScoreState then
        if currentState == "winning" then
            if myScore == 1 and bestEnemyScore == 0 then
				local sound = CoDHUD_GetAnnouncerSound(voicefile.leadtaken)
				if sound then CoDHUD_PlayAnnouncerSound(sound, false) end
            else
				local sound = CoDHUD_GetAnnouncerSound(voicefile.leadtaken)
				if sound then CoDHUD_PlayAnnouncerSound(sound, false) end
            end
        elseif currentState == "losing" then
			local sound = CoDHUD_GetAnnouncerSound(voicefile.leadlost)
			if sound then CoDHUD_PlayAnnouncerSound(sound, false) end
        elseif currentState == "tied" and myScore > 0 and bestEnemyScore > 0 then
			local sound = CoDHUD_GetAnnouncerSound(voicefile.leadtied)
			if sound then CoDHUD_PlayAnnouncerSound(sound, false) end
        end
        
        LastScoreState = currentState
    end
end)

hook.Add("Think", "CoDHUD_Announcer_Time_Think", function()
	if _G.CoDHUD_IsRoundEnding then return end
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
	local hudType = CoDHUD_GetHUDType()
	if not CoDHUD or not hudType or not CoDHUD[hudType] then return end

	local voicefile = CoDHUD[hudType].VoiceCallouts
	if not voicefile then return end
	local isDM = (CoDHUD_ActiveGamemodeCL == "dm")

    -- 1. Retrieve current faction and voice tag
    local currentFaction = ply:GetNW2String("CoDHUD_Faction", "")
    if currentFaction == "" then
        currentFaction = cookie.GetString("CoDHUD_SelectedFaction", "rangers")
    end

	local timeLeft = (CoDHUD_RoundEndTime or 0) - CurTime()
	local matchTime = CoDHUD_MatchMaxTime or 0
	local timeAnnouncersEnabled = (matchTime > 0)
	local has60Callout = (matchTime > 60)
	
	if not timeAnnouncersEnabled then return end
	
	-- Track crossing of 60 seconds threshold
	if has60Callout and timeLeft >= 60 then
		CoDHUD_HadAbove60 = true
	end

	if has60Callout and CoDHUD_HadAbove60 and timeLeft < 60 then
		CoDHUD_HadAbove60 = false

		timer.Remove("CoDHUD_SuspenseTimer")

		if not MusicTriggered then
			if isDM then
				local myPlace = select(1, CoDHUD_GetDMPlayerState(ply))

				if myPlace and myPlace <= 3 then
					if voicefile.winningmusic then
						MusicTriggered = true
						CoDHUD_PlayAnnouncerSound(voicefile.winningmusic, true)
					end
				else
					if voicefile.losingmusic then
						MusicTriggered = true
						CoDHUD_PlayAnnouncerSound(voicefile.losingmusic, true)
					end
				end
			else
				local myScore, bestEnemyScore = CoDHUD_GetFactionScores(ply)

				local sound = nil

				if myScore > bestEnemyScore then
					sound = CoDHUD_GetAnnouncerSound(voicefile.winningfight)

					if voicefile.winningmusic then
						MusicTriggered = true
						CoDHUD_PlayAnnouncerSound(voicefile.winningmusic, true)
					end
				else
					sound = CoDHUD_GetAnnouncerSound(voicefile.losingfight)

					if voicefile.losingmusic then
						MusicTriggered = true
						CoDHUD_PlayAnnouncerSound(voicefile.losingmusic, true)
					end
				end

				if sound then
					CoDHUD_PlayAnnouncerSound(sound, false)
				end
			end
		end
	end
	
	-- Track crossing of 30 seconds threshold
	if timeLeft >= 30 then
		CoDHUD_HadAbove30 = true
		CoDHUD_LowTimeTriggered = false
	end

	if CoDHUD_HadAbove30 and timeLeft < 30 and not CoDHUD_LowTimeTriggered then
		CoDHUD_LowTimeTriggered = true
		CoDHUD_HadAbove30 = false

		timer.Remove("CoDHUD_SuspenseTimer")

		local sound = CoDHUD_GetAnnouncerSound(voicefile.lowtime)

		if sound then
			CoDHUD_PlayAnnouncerSound(sound, false)
		end
	end
end)

hook.Add("Think", "CoDHUD_Timer_Tick", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local hudtype = CoDHUD_GetHUDType()
    local timerData = CoDHUD[hudtype] and CoDHUD[hudtype].Timer
    if not timerData or not timerData.sound then return end

    local timeLeft = (CoDHUD_RoundEndTime or 0) - CurTime()
    if timeLeft <= 0 then return end

    local now = CurTime()

    -- 1. Find best active tier (lowest threshold that is still active)
    local activeThreshold = nil
    local activeInterval = nil

    for threshold, interval in pairs(timerData.timings or {}) do
        if timeLeft <= threshold then
            if not activeThreshold or threshold < activeThreshold then
                activeThreshold = threshold
                activeInterval = interval
            end
        end
    end

    if not activeThreshold then return end

    -- 2. Switch tier if needed (reset timing when entering new phase)
    if CoDHUD_ActiveTimerTier ~= activeThreshold then
        CoDHUD_ActiveTimerTier = activeThreshold
        CoDHUD_TimerLastPlay = 0
    end

    -- 3. Interval trigger
    if (now - CoDHUD_TimerLastPlay) >= activeInterval then
        CoDHUD_TimerLastPlay = now

        surface.PlaySound(timerData.sound)
    end
end)