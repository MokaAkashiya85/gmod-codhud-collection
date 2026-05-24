---- [ CLIENT SETTINGS FILE ] ----
CoDHUDMenu = CoDHUDMenu or {}

-- [[ CLIENT CONVARS ]]
CreateClientConVar("codhud_quickdisable_hud", "0", true, false, "Quickly disable all HUD options.")
CreateClientConVar("codhud_quickdisable_audio", "0", true, false, "Quickly disable all Audio options.")

CreateClientConVar("codhud_enable_announcer", "1", true, false, "Enable or disable the announcer voices.")
CreateClientConVar("codhud_enable_announcer_english", "0", true, false, "Force the announcer voice to use English ones, regardless of language.")
CreateClientConVar("codhud_enable_music", "1", true, false, "Enable or disable the end-game music.")
CreateClientConVar("codhud_enable_suspense", "1", true, false, "Enable or disable the ambient music.")

CreateClientConVar("codhud_enable_medals", "1", true, false, "Enable or disable Kill Medals.")
CreateClientConVar("codhud_enable_minimap", "1", true, false, "Enable or disable the Minimap.")
CreateClientConVar("codhud_enable_medal_faster", "0", true, false, "Enable or disable Kill Medals moving by faster if there's many queued up at once.")
CreateClientConVar("codhud_enable_scorebar", "1", true, false, "Enable or disable the Scorebar.")
CreateClientConVar("codhud_enable_hitmarker", "1", true, false, "Enable or disable the Hitmarker.")
CreateClientConVar("codhud_enable_xp", "1", true, false, "Enable or disable XP text.")
CreateClientConVar("codhud_enable_killfeed", "1", true, false, "Enable or disable the Kill Feed.")
CreateClientConVar("codhud_enable_weaponinfo", "1", true, false, "Enable or disable the Weapon Info and Compass.")
CreateClientConVar("codhud_enable_prompts", "1", true, false, "Enable or disable Weapon Prompts.")
CreateClientConVar("codhud_enable_chat", "1", true, false, "Enable or disable the Chat.")
CreateClientConVar("codhud_enable_headers", "1", true, false, "Enable or disable Header notifications.")
CreateClientConVar("codhud_enable_scoreboard", "1", true, false, "Enable or disable the Scoreboard.")

CreateClientConVar("codhud_enable_iff", "1", true, false, "Enable/Disable target identification labels")
CreateClientConVar("codhud_enable_deathicon", "1", true, false, "Show death icon when a friendly dies")

CreateClientConVar("codhud_enable_outlinedtext", "0", true, false, "Enable or disable outlines on certain HUD texts.")

CreateClientConVar("codhud_scale", 1, true, false, "What scale all of the CoD HUD elements should be in.")

CreateClientConVar("codhud_menu_fullscreen", "0", true, false, "If enabled, the CoD HUD Menu will open in full screen.")
CreateClientConVar("codhud_menu_sounds", "1", true, false, "Enable or disable sounds in the CoD HUD Menu.")
CreateClientConVar("codhud_menu_music", "1", true, false, "Enable or disable music in the CoD HUD Menu.")

CreateClientConVar("codhud_menu_hide_desc", 0, true, false)
CreateClientConVar("codhud_menu_hide_prompts", 0, true, false)

CreateClientConVar("codhud_menu_openspeed", 0.15, true, false)
CreateClientConVar("codhud_menu_closespeed", 0.15, true, false)

-- [[ MENU POPULATION ]] -- Only done to present button to open proper menu
hook.Add("PopulateToolMenu", "CoDHUD_SETTINGSMenu", function()

    spawnmenu.AddToolMenuOption("Options", "CoDHUD.Title", "MW2_ClientSettings", "#CoDHUD.Title", "", "", function(panel)
        panel:ClearControls()
		panel:Button("Open CoD HUD Menu", "codhud_openmenu")
    end)

end)

local codhud_menu_frame = nil
local rs_confirm = nil
local levelreset_confirm = nil
local pendingFaction = nil
local pendingGame = nil

CoDHUD.RestrictFactions = 1

net.Receive("CoDHUD_RestrictFactionsSync", function()
    CoDHUD.RestrictFactions = net.ReadUInt(2)
end)

function CoDHUD.GetHUDList()
	local mainHUDs = {}

	timer.Simple( 0.25, function()
		for _, hud in pairs(CoDHUD.TypeRegistry or {}) do
			table.insert(mainHUDs, {
				hud.name,       -- display text
				hud.codename    -- convar value
			})
		end

		table.sort(mainHUDs, function(a, b)
			return a[1] < b[1]
		end)
	end)

	return mainHUDs
end

local function CoDHUD_GetPlayerStatsLines(hud)
    local stats = CoDHUD_GetStats(hud) or {}

    local level = stats.level or {}

    local levelIndex = level.level or 1

    local levelName = level.name
	
	if CoDHUD[hud].LevelData and CoDHUD[hud].LevelData.nameprefix then
		levelName = CoDHUD[hud].LevelData.nameprefix .. levelName
	end

    if not levelName or levelName == CoDHUD[hud].LevelData.nameprefix then
        levelName = "CoDHUD.Stats.Unknown"
    end

	levelName = language.GetPhrase(levelName)

    local nextXP = math.max((level.nextxp or 0) - (stats.xp or 0), 0)

    local completedChallenges = 0

    for _ in pairs(CoDHUD_Stats.challengescompleted or {}) do
        completedChallenges = completedChallenges + 1
    end

    return {
        string.format( language.GetPhrase("CoDHUD.Stats.Rank"), levelIndex, tostring(levelName) ),
        string.format( language.GetPhrase("CoDHUD.Stats.XPNext"), nextXP ),
        string.format( language.GetPhrase("CoDHUD.Stats.XP"), stats.xp or 0 ),
        string.format( language.GetPhrase("CoDHUD.Stats.Kills"), stats.kills or 0 ),
        string.format( language.GetPhrase("CoDHUD.Stats.Headshots"), stats.headshots or 0 ),
        string.format( language.GetPhrase("CoDHUD.Stats.Deaths"), stats.deaths or 0 ),
        string.format( language.GetPhrase("CoDHUD.Stats.Challenges"), completedChallenges )
    }
end

-- Menus
CoDHUDMenu.Main = function()
	local fs = GetConVar("codhud_menu_fullscreen"):GetBool()
	local menusize = fs and 1 or 0.75

	CoDHUDMenu.CurrentMenu = CoDHUDMenu:Open({
		Name = CoDHUDString("CoDHUD.Title"),
		Width  = ScrW() * menusize,
		Height = ScrH() * menusize,
		Description = true,
		UnfocusClose = true,
		Tabs = {
		
			{ TabName = "CoDHUD.Faction.Select", NoTitle = true, playsfx = "confirm", -- Welcome Page
				{ type = "factions", text = "REPLACEME" },
			},
			
			{ TabName = "CoDHUD.Client", NoTitle = true, playsfx = "confirm", -- Welcome Page
				{ type = "label", text = "CoDHUD.Quick.title" },
				{ type = "bool", text = "CoDHUD.Quick.DisableHUD", desc = "CoDHUD.Quick.DisableHUD.desc", convar = "codhud_quickdisable_hud" },
				{ type = "bool", text = "CoDHUD.HUD.Outline", desc = "CoDHUD.HUD.Outline.desc", convar = "codhud_enable_outlinedtext" },
				
				{ type = "slider", text = "CoDHUD.HUD.Scale.Enable", desc = "CoDHUD.HUD.Scale.Enable.desc", convar = "codhud_scale", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true, min = 0.5, max = 1.5, decimals = 2, func = function()
					CoDHUD_InitiateFonts()
					CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true)
				end },
				

				{ type = "label", text = "CoDHUD.Audio" },
				{ type = "bool", text = "CoDHUD.Audio.Announcer.Enable", desc = "CoDHUD.Audio.Announcer.Enable.desc", convar = "codhud_enable_announcer" },
				{ type = "bool", text = "CoDHUD.Audio.Announcer.English", desc = "CoDHUD.Audio.Announcer.English.desc", convar = "codhud_enable_announcer_english" },
				
				{ type = "bool", text = "CoDHUD.Audio.Music.Enable", desc = "CoDHUD.Audio.Music.Enable.desc", convar = "codhud_enable_music" },
				{ type = "bool", text = "CoDHUD.Audio.Music.Ambient", desc = "CoDHUD.Audio.Music.Ambient.desc", convar = "codhud_enable_suspense" },

				{ type = "label", text = "CoDHUD.Menu" },
				{ type = "bool", text = "CoDHUD.Menu.Fullscreen", desc = "CoDHUD.Menu.Fullscreen.desc", convar = "codhud_menu_fullscreen", func = function()
					CoDHUDMenu.OpenMenu(CoDHUDMenu.Main)
				end },
				{ type = "bool", text = "CoDHUD.Menu.SFX", desc = "CoDHUD.Menu.SFX.desc", convar = "codhud_menu_sounds" },
				{ type = "bool", text = "CoDHUD.Menu.Music", desc = "CoDHUD.Menu.Music.desc", convar = "codhud_menu_music" },
				{ type = "bool", text = "CoDHUD.Menu.HideDesc", desc = "CoDHUD.Menu.HideDesc.desc", convar = "codhud_menu_hide_desc" },
				{ type = "bool", text = "CoDHUD.Menu.HidePrompts", desc = "CoDHUD.Menu.HidePrompts.desc", convar = "codhud_menu_hide_prompts" },
				{ type = "slider", text = "CoDHUD.Menu.OpenSpeed", desc = "CoDHUD.Menu.OpenSpeed.desc", convar = "codhud_menu_openspeed", min = 0, max = 1, decimals = 2 },
				{ type = "slider", text = "CoDHUD.Menu.CloseSpeed", desc = "CoDHUD.Menu.CloseSpeed.desc", convar = "codhud_menu_closespeed", min = 0, max = 1, decimals = 2 },
				
				{ type = "label", text = "CoDHUD.HUD", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.Scoreboard.Enable", desc = "CoDHUD.HUD.Scoreboard.Enable.desc", convar = "codhud_enable_scoreboard", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.Scorecounter.Enable", desc = "CoDHUD.HUD.Scorecounter.Enable.desc", convar = "codhud_enable_scorebar", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.Medals.Enable", desc = "CoDHUD.HUD.Medals.Enable.desc", convar = "codhud_enable_medals", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.Medals.Speedup", desc = "CoDHUD.HUD.Medals.Speedup.desc", convar = "codhud_enable_medal_faster", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true },

				{ type = "bool", text = "CoDHUD.HUD.Killfeed.Enable", desc = "CoDHUD.HUD.Killfeed.Enable.desc", convar = "codhud_enable_killfeed", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.Minimap.Enable", desc = "CoDHUD.HUD.Minimap.Enable.desc", convar = "codhud_enable_minimap", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.Hitmarker.Enable", desc = "CoDHUD.HUD.Hitmarker.Enable.desc", convar = "codhud_enable_hitmarker", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.WeaponInfo.Enable", desc = "CoDHUD.HUD.WeaponInfo.Enable.desc", convar = "codhud_enable_weaponinfo", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.WeaponPrompts.Enable", desc = "CoDHUD.HUD.WeaponPrompts.Enable.desc", convar = "codhud_enable_prompts", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.XP.Enable", desc = "CoDHUD.HUD.XP.Enable.desc", convar = "codhud_enable_xp", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.IFF.Enable", desc = "CoDHUD.HUD.IFF.Enable.desc", convar = "codhud_enable_iff", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.DeathIcon.Enable", desc = "CoDHUD.HUD.DeathIcon.Enable.desc", convar = "codhud_enable_deathicon", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.Chat.Enable", desc = "CoDHUD.HUD.Chat.Enable.desc", convar = "codhud_enable_chat", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
				{ type = "bool", text = "CoDHUD.HUD.Headers.Enable", desc = "CoDHUD.HUD.Headers.Enable.desc", convar = "codhud_enable_headers", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },
			},
			
			{ TabName = "CoDHUD.Server", sv = true, NoTitle = true, playsfx = "confirm", -- Welcome Page
							
				{ type = "label", text = "CoDHUD.RoundStart" },
				{ type = "combo", text = "CoDHUD.RoundStart.Gamemode", desc = "CoDHUD.RoundStart.Info", convar = "codhud_selected_gamemode", sv = true, content = {
					{"#MW2_MPUI_WAR", "war"},
					{"#MW2_MPUI_DEATHMATCH", "dm"},
				}},
				{ type = "bool", text = "CoDHUD.Admin.FriendlyFire", desc = "CoDHUD.Admin.FriendlyFire.desc", convar = "codhud_friendly_fire", sv = true, requireparentconvarvariable = "codhud_selected_gamemode", requireparentconvarvalue = "war" },
				{ type = "slider", text = "CoDHUD.Scorelimit", desc = "CoDHUD.Scorelimit.desc", convar = "codhud_score_limit", sv = true, min = 1, max = 150, decimals = 0 },
				{ type = "slider", text = "CoDHUD.Timelimit", desc = "CoDHUD.Timelimit.desc", convar = "codhud_time_limit", sv = true, min = 0, max = 30, decimals = 0 },
				{ type = "slider", text = "CoDHUD.RoundStart.Timer", desc = "CoDHUD.RoundStart.Timer.desc", convar = "codhud_matchstart_timer", sv = true, min = 0, max = 15, decimals = 0 },
				{ type = "button", text = "CoDHUD.RoundStart.Start", desc = "CoDHUD.RoundStart.Start.desc", playsfx = "clickopen", prompts = {"CoDHUD.Glyph.OpenMenu"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.ConfirmRoundStart, true) end, sv = true },
				
				{ type = "button", text = "CoDHUD.ForceEndRound", desc = "CoDHUD.ForceEndRound.desc", playsfx = "clickopen", prompts = {"CoDHUD.Glyph.OpenMenu"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.ConfirmRoundStop, true) end, cond = function() return _G.CoDHUD_RoundActiveCL end, sv = true },

				{ type = "label", text = "CoDHUD.General" },
				{ type = "bool", text = "CoDHUD.Admin.EndScreen", desc = "CoDHUD.Admin.EndScreen.desc", convar = "codhud_enable_roundend", sv = true },
				{ type = "bool", text = "CoDHUD.Admin.EndScreen.StartNext", desc = "CoDHUD.Admin.EndScreen.StartNext.desc", convar = "codhud_enable_roundend_startnext", sv = true },
				{ type = "bool", text = "CoDHUD.RoundStart.Autobalance", desc = "CoDHUD.RoundStart.Autobalance.desc", convar = "codhud_autobalance_on_roundstart", sv = true },
				
				{ type = "combo", text = "CoDHUD.Autobalance.Amount", desc = "CoDHUD.Autobalance.Amount.desc", convar = "codhud_autofaction_limit", sv = true, content = {
					{"CoDHUD.Autobalance.Amount.disable", "0"},
					{"CoDHUD.Autobalance.Amount.2", "2"},
					{"CoDHUD.Autobalance.Amount.3", "3"},
					{"CoDHUD.Autobalance.Amount.4", "4"},
				}},
				
				{ type = "combo", text = "CoDHUD.Admin.RestrictFactionChance", desc = "CoDHUD.Admin.RestrictFactionChance.desc", convar = "codhud_restrictfactions", sv = true, content = {
					{"CoDHUD.Admin.RestrictFactionChance.disable", "0"},
					{"CoDHUD.Admin.RestrictFactionChance.freely", "1"},
					{"CoDHUD.Admin.RestrictFactionChance.pool", "2"},
				}},

				{ type = "label", text = "CoDHUD.Admin.RestrictType" },
				{ type = "combo", text = "CoDHUD.Admin.RestrictType.Choose", desc = "CoDHUD.Admin.RestrictType.desc", convar = "codhud_game", sv = true, content = CoDHUD.GetHUDList(), func = function(_, _, data)
					local current = GetConVar("codhud_game"):GetString()
					if data == current then return end

					CoDHUDMenu.ConfirmGameChange(data)
				end}
			},
			
			{ TabName = "CoDHUD.Stats", NoTitle = true, playsfx = "confirm", -- Welcome Page
				{ type = "label", text = "CoDHUD.Type." .. CoDHUD_GetHUDType() },
				{ type = "info", text = table.concat( CoDHUD_GetPlayerStatsLines(CoDHUD_GetHUDType()), "\n" ), },
				
				{ type = "label", text = "CoDHUD.Reset" },
				{ type = "button", text = "CoDHUD.Rank.Reset", desc = "CoDHUD.Rank.Reset.desc", playsfx = "clickopen", prompts = {"CoDHUD.Glyph.OpenMenu"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.ConfirmRankReset, true) end },
				{ type = "button", text = "CoDHUD.Challenges.Reset", desc = "CoDHUD.Challenges.Reset.desc", playsfx = "clickopen", prompts = {"CoDHUD.Glyph.OpenMenu"}, func = function()
					RunConsoleCommand("codhud_challenge_clear")
				end },

			},
						
			{ TabName = "DEBUG", developer = true, sv = true, NoTitle = true, playsfx = "confirm", -- Welcome Page
				{ type = "label", text = "Debug commands" },
				{ type = "button", text = "Random challenge header", desc = "Creates a random challenge header.\n\nThese will play after the menu has closed.", playsfx = "confirm", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					RunConsoleCommand("codhud_challenge_debug", "random")
				end },
				{ type = "button", text = "Give 1 mil XP", desc = "Grants 1 million XP.", playsfx = "confirm", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					if _G.CoDHUD_AddScore then
						_G.CoDHUD_AddScore(1000000)
					end
				end },

			},
			
			{ TabName = "CoDHUD.Close", Prompts = { "CoDHUD.Glyph.Close" }, func = function()
					CoDHUDMenu.CloseCurrentMenu()
				end,
			},
		}
	})
end

function CoDHUDMenu.ConfirmFactionChange(factionID)
    pendingFaction = factionID

    local factionData = CoDHUD.Factions[CoDHUD_GetHUDType()][factionID]

	local fs = GetConVar("codhud_menu_fullscreen"):GetBool()
	local menusize = fs and 1 or 0.5

	CoDHUDMenu.CurrentMenu = CoDHUDMenu:Open({
		Name = CoDHUDString("CoDHUD.Title") .. " - " .. CoDHUDString("CoDHUD.Faction.Select"),
		Width  = ScrW() * menusize,
		Height = ScrH() * menusize,
		Description = false,
		UnfocusClose = false,
		Tabs = {

			{ TabName = "CoDHUD.RoundStart", NoTitle = true, -- Welcome Page
				{ type = "infosimple", text = factionData.name },
				{ type = "image", image = factionData.scoreIcon, mode = "icon", fixedSize = 128 },
				{ type = "info", text = "CoDHUD.Faction.ChangeWarning" },
				{ type = "button", text = "dialog.ok", prompts = {"CoDHUD.Glyph.Confirm"}, playsfx = "confirm", func = function()
					net.Start("CoDHUD_RequestFactionChange")
					net.WriteString(pendingFaction or "")
					net.SendToServer()

					pendingFaction = nil
					
					CoDHUDMenu.CloseCurrentMenu()
				end },
				
				{ type = "button", text = "dialog.cancel", playsfx = "confirm", prompts = {"CoDHUD.Glyph.Return"}, func = function()
					CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true) 
					pendingFaction = nil
				end },
			},
		}
	})
end

CoDHUDMenu.ConfirmRoundStart = function()
	local fs = GetConVar("codhud_menu_fullscreen"):GetBool()
	local menusize = fs and 1 or 0.5

	CoDHUDMenu.CurrentMenu = CoDHUDMenu:Open({
		Name = CoDHUDString("CoDHUD.Title") .. " - " .. CoDHUDString("CoDHUD.RoundStart"),
		Width  = ScrW() * menusize,
		Height = ScrH() * menusize,
		Description = false,
		UnfocusClose = false,
		Tabs = {
					
			{ TabName = "CoDHUD.RoundStart", NoTitle = true, -- Welcome Page
				{ type = "infosimple", text = "CoDHUD.RoundStart.Notice" },
				{ type = "button", text = "dialog.ok", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					net.Start("CoDHUD_StartRound")
					net.SendToServer()
					
					CoDHUDMenu.CloseCurrentMenu()
				end, sv = true },
				{ type = "button", text = "dialog.cancel", playsfx = "confirm", prompts = {"CoDHUD.Glyph.Return"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true) end, sv = true },
			},
		}
	})
end

CoDHUDMenu.ConfirmRoundStop = function()
	local fs = GetConVar("codhud_menu_fullscreen"):GetBool()
	local menusize = fs and 1 or 0.5

	CoDHUDMenu.CurrentMenu = CoDHUDMenu:Open({
		Name = CoDHUDString("CoDHUD.Title") .. " - " .. CoDHUDString("CoDHUD.ForceEndRound"),
		Width  = ScrW() * menusize,
		Height = ScrH() * menusize,
		Description = false,
		UnfocusClose = false,
		Tabs = {
					
			{ TabName = "CoDHUD.ForceEndRound", NoTitle = true, -- Welcome Page
				{ type = "infosimple", text = "CoDHUD.ForceEndRound.Notice" },
				{ type = "button", text = "dialog.ok", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					net.Start("CoDHUD_EndRound")
					net.SendToServer()
					
					CoDHUDMenu.CloseCurrentMenu()
				end, sv = true },
				{ type = "button", text = "dialog.cancel", playsfx = "confirm", prompts = {"CoDHUD.Glyph.Return"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true) end, sv = true },
			},
		}
	})
end

CoDHUDMenu.ConfirmRankReset = function()
	local fs = GetConVar("codhud_menu_fullscreen"):GetBool()
	local menusize = fs and 1 or 0.5

	CoDHUDMenu.CurrentMenu = CoDHUDMenu:Open({
		Name = CoDHUDString("CoDHUD.Title") .. " - " .. CoDHUDString("CoDHUD.Rank.Reset"),
		Width  = ScrW() * menusize,
		Height = ScrH() * menusize,
		Description = false,
		UnfocusClose = false,
		Tabs = {
					
			{ TabName = "CoDHUD.Rank.Reset", NoTitle = true, -- Welcome Page
				{ type = "infosimple", text = "CoDHUD.Rank.Reset.Warning" },
				{ type = "button", text = "dialog.ok", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					RunConsoleCommand("codhud_rank_clear")
					timer.Simple( 0.05, function()
						CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true)
					end)
				end },
				{ type = "button", text = "dialog.cancel", playsfx = "confirm", prompts = {"CoDHUD.Glyph.Return"}, func = function()
					CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true)
				end },
			},
		}
	})
end

function CoDHUDMenu.ConfirmGameChange(data)
	local fs = GetConVar("codhud_menu_fullscreen"):GetBool()
	local menusize = fs and 1 or 0.5

    local currentGame = GetConVar("codhud_game"):GetString()
	pendingGame = data

	CoDHUDMenu.CurrentMenu = CoDHUDMenu:Open({
		Name = CoDHUDString("CoDHUD.Title") .. " - " .. CoDHUDString("CoDHUD.Admin.RestrictType.Choose"),
		Width  = ScrW() * menusize,
		Height = ScrH() * menusize,
		Description = false,
		UnfocusClose = false,
		Tabs = {
					
			{ TabName = "CoDHUD.ForceEndRound", NoTitle = true, -- Welcome Page
				{ type = "infosimple", text = string.format(
						"%s -> %s",
						language.GetPhrase("CoDHUD.Type." .. currentGame),
						language.GetPhrase("CoDHUD.Type." .. pendingGame)
					)
				},
				{ type = "info", text = "CoDHUD.Admin.RestrictType.Warning" },
				{ type = "button", text = "dialog.ok", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					net.Start("CoDHUD_SetGame")
					net.WriteString(pendingGame)
					net.SendToServer()
					
					CoDHUDMenu.CloseCurrentMenu()
				end, sv = true },
				{ type = "button", text = "dialog.cancel", playsfx = "confirm", prompts = {"CoDHUD.Glyph.Return"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true) end, sv = true },
			},
		}
	})
end

if CLIENT then
    list.Set("DesktopWindows", "CoDHUDMenu", {
        title = "#CoDHUD.Title",
        icon  = "mw2/factions/faction_128_taskforce141_fade.png",
        init = function(icon, window)
			RunConsoleCommand("codhud_openmenu")
        end
    })
end

concommand.Add("codhud_openmenu", function()
	CoDHUDMenu.OpenMenu(CoDHUDMenu.Main)
	CoDHUDMenu.PlaySFX("menuopen")
end)