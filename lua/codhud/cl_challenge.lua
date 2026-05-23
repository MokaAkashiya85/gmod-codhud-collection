---- [ CLIENT CHALLENGE NOTIFICATIONS & TRACKING ] ----

local function GetWeaponPrintName(class)

    -- 1. Seek for registered weapon
    local listedSwep = list.GetEntry("Weapon", class)
    if listedSwep and listedSwep.PrintName then
        return listedSwep.PrintName
    end

    -- 3. Try active weapon (MOST reliable)
    local ply = LocalPlayer()
    if IsValid(ply) then
        local wep = ply:GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == class then
            return wep:GetPrintName() or "#" .. wep:GetClass() or wep.PrintName
        end
    end

    -- 2. Try SWEP stored (fallback)
    local swep = weapons.GetStored(class)
    if swep and swep.PrintName then
        return swep.PrintName
    end


    -- 4. Last resort cleanup
    return string.upper(string.gsub(class, "^weapon_", ""))
end

-- [[ HELPERS ]]
function CoDHUD_ChallengeTitle(header, level, prefix)
    local name = header
    prefix = prefix or "MW2_CHALLENGE_"

    local mode = nil

    -- Detect prefixes
    if string.find(header, "%[KILLS%]") then
        mode = "MARKSMAN"
        name = language.GetPhrase(GetWeaponPrintName(string.Trim(string.Replace(header, "[KILLS] ", ""))))
    elseif string.find(header, "%[HS%]") then
        mode = "EXPERT"
        name = language.GetPhrase(GetWeaponPrintName(string.Trim(string.Replace(header, "[HS] ", ""))))
    else
		if string.find(header, " ") then prefix = "" end
        mode = "LEVEL"
        name = language.GetPhrase(prefix .. header)
    end

    -- Build rank name
    local rank = ""
    if level and level > 0 then
        rank = language.GetPhrase(prefix .. mode .. "_" .. level)
    end

    -- Fallback
    if rank == "LEVEL" then
        rank = mode
    end

    -- Final format
    if rank ~= "" then
        return name .. rank
    else
        return name
    end
end

-- [[ QUEUE SYSTEM ]]
local notificationQueue = {}
local activeNotif = nil
local queuedChallenge = false

local function QueueNotification(id, header, level, sub, subval, pts, align)
    if id ~= "debug" and CoDHUD_Stats.challengescompleted[id] then return end

    if _G.CoDHUD_AddScore and pts and pts > 0 then
        timer.Simple(0.25, function()
            _G.CoDHUD_AddScore(pts)
        end)
    end

    if id ~= "debug" then
        CoDHUD_CompleteChallenge(id)
        -- CoDHUD_SaveStats()
    end

    if (not GetConVar("codhud_enable_headers"):GetBool()) or GetConVar("codhud_quickdisable_hud"):GetBool() then return end

	table.insert(notificationQueue, {
		id = id,
		header = header,
		level = level,
		sub = sub,
		subval = subval,
		align = align
	})
end

local function ProcessQueue()

    if CoDHUD_HeaderQueue.IsBusy() then return end
	local hud = CoDHUD[CoDHUD_GetHUDType()]

	if hud and hud.MedalsBlockChallenges and _G.CoDHUD_MedalsActive then
		return
	end

    if #notificationQueue == 0 then return end

    local n = table.remove(notificationQueue, 1)

	if CoDHUD[CoDHUD_GetHUDType()] and CoDHUD[CoDHUD_GetHUDType()].ChallengeComplete then
		CoDHUD[CoDHUD_GetHUDType()].ChallengeComplete( n.header, n.level, n.sub, n.subval, n.align )
	end
end

-- [[ NETWORK RECEIVERS ]]
net.Receive("CoDHUD_Challenge_Generic", function()
    local id     = net.ReadString()
    local header = net.ReadString()
    local level  = net.ReadInt(5)
    local sub    = net.ReadString()
    local subval = net.ReadInt(32)
	local pts    = net.ReadInt(32)

    QueueNotification(id, header, level, sub, subval, pts)
end)

net.Receive("CoDHUD_Challenge_MW2_Flyswatter", function()
    QueueNotification("flyswatter", "FLYSWATTER", nil, "SHOOT_DOWN_AN_ENEMY_HELICOPTER", nil)
end)

-- [[ RENDERING ENGINE ]]
hook.Add("Think", "CoDHUD_Challenge_TextThink", function()
    ProcessQueue()
end)

-- [[ DEBUG COMMANDS ]]
concommand.Add("codhud_challenge_debug", function(ply, cmd, args)
    local key = args[1]
	local randomchal = ""
    local challenges = {
		["ghillie1"] = { "GHILLIE", 1, "DESC_GHILLIE", 50, 0},
		["ghillie2"] = { "GHILLIE", 2, "DESC_GHILLIE", 100, 0},
		["ghillie3"] = { "GHILLIE", 3, "DESC_GHILLIE", 200, 0},
		["flyswatter"] = { "FLYSWATTER", nil, "SHOOT_DOWN_AN_ENEMY_HELICOPTER", nil, 0},
    }
	
    if challenges[key] then QueueNotification("debug", challenges[key][1], challenges[key][2], challenges[key][3], challenges[key][4], challenges[key][5]) end
	
	if key == "random" then
		local keys = {}

		for k, _ in pairs(challenges) do
			table.insert(keys, k)
		end

		local randomKey = keys[math.random(#keys)]
		local randomchal = challenges[randomKey]

		QueueNotification("debug", randomchal[1], randomchal[2], randomchal[3], randomchal[4], randomchal[5])
	end
	
	if key == "testvar" then
		local testChallenges = {
			["test1"] = { "Test Challenge!", nil, "Testing Subtext, single line.", nil, 1 },
			["test2"] = { "Test Challenge! II", nil, "Testing Subtext\nTwo lines.", nil, 1 },
			["test3"] = { "Test Challenge! III", nil, "Testing Subtext\nVersion two\nThree lines.", nil, 1 },
			["test4"] = { "Debug Challenge Testing!\nTest Challenge! IV", nil, nil, nil, 1 },
			["test5"] = { "Test Challenge! V", nil, "This challenge is aligned to the right.", nil, 1, "right" },
			["test6"] = { "Test Challenge! VI", nil, "This challenge is aligned to the left.", nil, 1, "left" },
		}

		for _, v in pairs(testChallenges) do
			QueueNotification("debug", v[1], v[2], v[3], v[4], v[5], v[6])
		end
		return
	end
end)

concommand.Add("codhud_challenge_clear", function()
    CoDHUD_Stats.challengescompleted = {}
    CoDHUD_SaveStats()
    print("[CoDHUD] Cleared Client Challenges.")
	CoDHUD_AddKillfeedMessage("CoDHUD.System.ChallengeReset")
end)