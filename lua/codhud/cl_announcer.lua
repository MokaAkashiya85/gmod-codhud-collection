---- [ CLIENT ANNOUNCER & MUSIC ] ----

-- Queue system
CoDHUD_AnnouncerQueue = CoDHUD_AnnouncerQueue or {}
CoDHUD_AnnouncerPlaying = CoDHUD_AnnouncerPlaying or false
CoDHUD_AnnouncerNextTime = CoDHUD_AnnouncerNextTime or 0
CoDHUD_ActiveAnnouncerChannel = CoDHUD_ActiveAnnouncerChannel or nil

-- Cache
CoDHUD_AnnouncerCache = CoDHUD_AnnouncerCache or {}

-- Music check
CoDHUD_CurrentMusic = CoDHUD_CurrentMusic or nil
CoDHUD_MusicVolumeScale = CoDHUD_MusicVolumeScale or 1

local ANNOUNCER_COOLDOWN = 1 -- small gap between lines

local Subtitles = {}

function CoDHUD_AddSubtitle(speaker, text, duration)
    table.insert(Subtitles, {
        speaker = speaker,
        text = text,
        spawnTime = CurTime(),
        dieTime = CurTime() + duration + 1
    })
end

function CoDHUD_AddSubtitleFromSound(path, duration)
    local hud = CoDHUD_GetHUDType()

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local faction = ply:GetNW2String("CoDHUD_Faction", "")

    if faction == "" then
        faction = cookie.GetString("CoDHUD_SelectedFaction", "rangers")
    end

    -- filename without extension
    local key = string.GetFileFromFilename(path)
    key = string.StripExtension(key)

    -- folder before filename
    local folder = string.GetPathFromFilename(path)
    folder = string.TrimRight(folder, "/")

    local group = string.GetFileFromFilename(folder)

    local subtitleKey = string.format( "CoDHUD.Sub.%s.%s.%s", hud, group, string.lower(key) )
    local speakerKey = string.format( "CoDHUD.SubName.%s.%s", hud, faction )
    local subtitle = language.GetPhrase(subtitleKey)

    -- if subtitle == subtitleKey then return end

    local speaker = language.GetPhrase(speakerKey)

    CoDHUD_AddSubtitle(speaker, subtitle, duration or 2)
	-- print(speaker, subtitle, duration)
end

local function CoDHUD_FinishAnnouncer()
	if IsValid(CoDHUD_ActiveAnnouncerChannel) then
		CoDHUD_ActiveAnnouncerChannel:Stop()
	end

	CoDHUD_ActiveAnnouncerChannel = nil
	CoDHUD_AnnouncerPlaying = false
	CoDHUD_AnnouncerNextTime = CurTime() + ANNOUNCER_COOLDOWN
end

local function CoDHUD_ProcessAnnouncerQueue()
	if CoDHUD_AnnouncerPlaying then return end
	if #CoDHUD_AnnouncerQueue == 0 then return end
	if CurTime() < CoDHUD_AnnouncerNextTime then return end

	local entry = table.remove(CoDHUD_AnnouncerQueue, 1)

	if not entry then return end

	CoDHUD_AnnouncerPlaying = true

	sound.PlayFile("sound/" .. entry.path, "noplay", function(chan, errCode, errStr)
		if not IsValid(chan) then
			CoDHUD_FinishAnnouncer()
			return
		end

		CoDHUD_ActiveAnnouncerChannel = chan

		chan:SetVolume(1)
		chan:Play()

		local duration = chan:GetLength()

		-- MP3 safety fallback
		if not duration or duration <= 0 then
			duration = 2
		end
		
		CoDHUD_AddSubtitleFromSound(entry.path, duration)

		-- failsafe timeout
		timer.Simple(duration + 0.1, function()
			if CoDHUD_ActiveAnnouncerChannel ~= chan then
				return
			end

			CoDHUD_FinishAnnouncer()
		end)

		if chan.SetEndCallback then
			chan:SetEndCallback(function()
				if CoDHUD_ActiveAnnouncerChannel ~= chan then
					return
				end

				CoDHUD_FinishAnnouncer()
			end)
		end
	end)
end

hook.Add("Think", "CoDHUD_AnnouncerQueue_Think", CoDHUD_ProcessAnnouncerQueue)

-- Helper to play sounds with toggle checks
function CoDHUD_PlayAnnouncerSound(path, isMusic, volume)
	CoDHUD_MusicVolumeScale = GetConVar("snd_musicvolume"):GetFloat() or 1

	if isMusic then

		if not GetConVar("codhud_enable_music"):GetBool() then
			return
		end

		-- stop previous music immediately
		if IsValid(CoDHUD_CurrentMusic) then
			CoDHUD_CurrentMusic:Stop()
			CoDHUD_CurrentMusic = nil
		end

		sound.PlayFile("sound/codhud/" .. path, "noplay", function(chan, errCode, errStr)
			if not IsValid(chan) then
				return
			end

			CoDHUD_CurrentMusic = chan

			local vol = volume or CoDHUD_MusicVolumeScale or 1

			chan:SetVolume(vol)
			chan:Play()

			-- cleanup when finished
			if chan.SetEndCallback then
				chan:SetEndCallback(function()

					if CoDHUD_CurrentMusic == chan then
						CoDHUD_CurrentMusic = nil
					end
				end)
			end
		end)

		return
	else
		if not GetConVar("codhud_enable_announcer"):GetBool() then
			return
		end
	end

	table.insert(CoDHUD_AnnouncerQueue, { path = path })
end

-- Resolve announcer sound with language + suffix fallback
function CoDHUD_GetAnnouncerSound(keys)

	if isstring(keys) then
		keys = { keys }
	end

	local ply = LocalPlayer()
	if not IsValid(ply) then return nil end

	local faction = ply:GetNW2String("CoDHUD_Faction", "")

	if faction == "" then
		faction = cookie.GetString( "CoDHUD_SelectedFaction", "rangers" )
	end

	if not CoDHUD.Factions[CoDHUD_GetHUDType()] or not CoDHUD.Factions[CoDHUD_GetHUDType()][faction] then
		return nil
	end

	local voice = CoDHUD.Factions[CoDHUD_GetHUDType()][faction].voicepath
	local lang = GetConVar("gmod_language"):GetString() or "en"
	local forceEnglish = GetConVar("codhud_enable_announcer_english"):GetBool()

	if forceEnglish then
		lang = "en"
	end

	local function tryLang(l)
		for _, key in ipairs(keys) do
			local filesuffix = ""

			if CoDHUD[CoDHUD_GetHUDType()].VoiceCallouts and CoDHUD[CoDHUD_GetHUDType()].VoiceCallouts.suffix then
				filesuffix = CoDHUD[CoDHUD_GetHUDType()].VoiceCallouts.suffix
			end

			local voicePath = CoDHUD.Factions[CoDHUD_GetHUDType()][faction].voicepath
			local cacheKey = CoDHUD_GetHUDType() .. "|" .. faction .. "|" .. l .. "|" .. key

			-- build cache once
			if not CoDHUD_AnnouncerCache[cacheKey] then
				local folder = "codhud/announcer/" .. CoDHUD_GetHUDType() .. "/" .. l .. "/" .. string.GetPathFromFilename(voicePath)
				local prefix = string.GetFileFromFilename(voicePath) .. key
				local files = file.Find("sound/" .. folder .. "*.mp3", "GAME")

				local candidates = {}

				for _, filename in ipairs(files) do
					local lower = string.lower(filename)

					if string.StartWith( lower, string.lower(prefix) ) then
						table.insert(candidates, folder .. filename)
					end
				end

				-- fallback exact file
				local exactPath = "codhud/announcer/" .. CoDHUD_GetHUDType() .. "/" .. l .. "/" .. voicePath .. key .. filesuffix .. ".mp3"

				if file.Exists("sound/" .. exactPath, "GAME") then
					table.insert(candidates, exactPath)
				end

				CoDHUD_AnnouncerCache[cacheKey] = candidates
			end

			local candidates =
				CoDHUD_AnnouncerCache[cacheKey]

			if candidates and #candidates > 0 then
				local selected = candidates[math.random(#candidates)]

				return selected
			end
		end

		return nil
	end

	return tryLang(lang) or tryLang("en")
end

local function CoDHUD_ShouldHideHUD()
    if gui.IsGameUIVisible() then return true end
    if gui.IsConsoleVisible() then return true end
    if vgui.CursorVisible() then return true end
    if IsValid(ScoreBoard) then return true end -- fallback safety
    if CoDHUD_ScoreboardOpened then return true end -- fallback safety
    return false
end

-- [[ RENDERING ]]
hook.Add("DrawOverlay", "CoDHUD_Subtitles_Draw", function()
    if (not GetConVar("codhud_enable_subtitles"):GetBool()) or GetConVar("codhud_quickdisable_hud"):GetBool() then return end

    if CoDHUD_ShouldHideHUD() then return end

	if CoDHUD[CoDHUD_GetHUDType()] and CoDHUD[CoDHUD_GetHUDType()].Subtitles then
		CoDHUD[CoDHUD_GetHUDType()].Subtitles(Subtitles)
	end
end)