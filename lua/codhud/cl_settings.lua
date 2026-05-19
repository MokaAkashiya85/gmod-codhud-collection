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
CreateClientConVar("codhud_enable_challenges", "1", true, false, "Enable or disable the Challenge prompts.")
CreateClientConVar("codhud_enable_scoreboard", "1", true, false, "Enable or disable the Scoreboard.")

CreateClientConVar("codhud_enable_iff", "1", true, false, "Enable/Disable target identification labels")
CreateClientConVar("codhud_enable_deathicon", "1", true, false, "Show death icon when a friendly dies")

CreateClientConVar("codhud_enable_outlinedtext", "0", true, false, "Enable or disable outlines on certain HUD texts.")

CreateClientConVar("codhud_menu_fullscreen", "0", true, false, "If enabled, the CoD HUD Menu will open in full screen.")
CreateClientConVar("codhud_menu_sounds", "1", true, false, "Enable or disable sounds in the CoD HUD Menu.")

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

local CoDHUD_SETTINGS = {
	{ name = "#CoDHUD.Client", subtabs = {
			{ name = "#CoDHUD.Faction.Select", categories = {
				{ name = "#CoDHUD.Faction.Select", type = "factions" } }
			},

			{ name = "#CoDHUD.HUD", categories = {
					{ name = "#CoDHUD.Quick.title", controls = {
							{ type = "checkbox",	label = "#CoDHUD.Quick.DisableHUD",				convar = "codhud_quickdisable_hud",			tooltip = "CoDHUD.Quick.DisableHUD.desc" },
							{ type = "checkbox",	label = "#CoDHUD.HUD.Outline",					convar = "codhud_enable_outlinedtext",		tooltip = "CoDHUD.HUD.Outline.desc" }, -- TEMP
						}
					},
					{ name = "#CoDHUD.HUD.Scoreboard", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.Scoreboard.Enable",		convar = "codhud_enable_scoreboard",		tooltip = "CoDHUD.HUD.Scoreboard.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.Scorecounter", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.Scorecounter.Enable",		convar = "codhud_enable_scorebar",			tooltip = "CoDHUD.HUD.Scorecounter.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.Medals", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.Medals.Enable",			convar = "codhud_enable_medals",			tooltip = "CoDHUD.HUD.Medals.Enable.desc" },
							{ type = "checkbox",	label = "#CoDHUD.HUD.Medals.Speedup",			convar = "codhud_enable_medal_faster",		tooltip = "CoDHUD.HUD.Medals.Speedup.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.Killfeed", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.Killfeed.Enable",		convar = "codhud_enable_killfeed",				tooltip = "CoDHUD.HUD.Killfeed.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.Minimap", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.Minimap.Enable",		convar = "codhud_enable_minimap",				tooltip = "CoDHUD.HUD.Minimap.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.Hitmarker", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.Hitmarker.Enable",		convar = "codhud_enable_hitmarker",				tooltip = "CoDHUD.HUD.Hitmarker.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.WeaponInfo", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.WeaponInfo.Enable",		convar = "codhud_enable_weaponinfo",		tooltip = "CoDHUD.HUD.WeaponInfo.Enable.desc" },
							{ type = "checkbox",	label = "#CoDHUD.HUD.WeaponPrompts.Enable",		convar = "codhud_enable_prompts",			tooltip = "CoDHUD.HUD.WeaponPrompts.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.XP", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.XP.Enable",		convar = "codhud_enable_xp",			tooltip = "CoDHUD.HUD.XP.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.IFF", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.IFF.Enable",		convar = "codhud_enable_iff",			tooltip = "CoDHUD.HUD.IFF.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.DeathIcon", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.DeathIcon.Enable",		convar = "codhud_enable_deathicon",			tooltip = "CoDHUD.HUD.DeathIcon.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.Chat", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.Chat.Enable",		convar = "codhud_enable_chat",			tooltip = "CoDHUD.HUD.Chat.Enable.desc" },
						}
					},
					{ name = "#CoDHUD.HUD.Challenges", controls = {
							{ type = "checkbox",	label = "#CoDHUD.HUD.Challenges.Enable",		convar = "codhud_enable_challenges",			tooltip = "CoDHUD.HUD.Challenges.Enable.desc" },
						}
					},
				}
			},
			
			{ name = "#CoDHUD.Settings", categories = {
					{ name = "#CoDHUD.Audio.Announcer", controls = {
							{ type = "checkbox", label = "#CoDHUD.Audio.Announcer.Enable", convar = "codhud_enable_announcer", tooltip = "#CoDHUD.Audio.Announcer.Enable.desc" },
							{ type = "checkbox", label = "#CoDHUD.Audio.Announcer.English", convar = "codhud_enable_announcer_english", tooltip = "#CoDHUD.Audio.Announcer.English.desc" },
						}
					},
					{ name = "#CoDHUD.Audio.Music", controls = {
							{ type = "checkbox", label = "#CoDHUD.Audio.Music.Enable", convar = "codhud_enable_music", tooltip = "#CoDHUD.Audio.Music.Enable.desc" },
							{ type = "checkbox", label = "#CoDHUD.Audio.Music.Ambient", convar = "codhud_enable_suspense", tooltip = "#CoDHUD.Audio.Music.Ambient.desc" },
						}
					},
					{ name = "#CoDHUD.Challenges", controls = {
							{ type = "button",	label = "#CoDHUD.Challenges.Reset",
								func = function()
									RunConsoleCommand("codhud_challenge_clear")
								end
							},
							{ type = "label", label = "#CoDHUD.Challenges.Reset.desc" },
						}
					},
					{ name = "#CoDHUD.Rank", controls = {
							{ type = "button",	label = "#CoDHUD.Rank.Reset",
								func = function()
									local lp = LocalPlayer()
									if not IsValid(lp) or not lp:IsAdmin() then return end

									CoDHUD_LevelReset_OpenConfirm()

									if IsValid(codhud_menu_frame) then
										codhud_menu_frame:SetVisible(false)
									end
								end
							},
							{ type = "label", label = "#CoDHUD.Rank.Reset.desc" },
						}
					},
					
					{ name = "#CoDHUD.Menu", controls = {
							{ type = "checkbox",	label = "#CoDHUD.Menu.Fullscreen", convar = "codhud_menu_fullscreen", tooltip = "CoDHUD.Menu.Fullscreen.desc" },
						}
					},
				}
			},

		}
	},

    { name = "#CoDHUD.Server", subtabs = {
            { name = "#CoDHUD.Server", adminOnly = true, categories = {
                    { name = "#CoDHUD.General", adminOnly = true, controls = {
                            { type = "checkbox", label = "#CoDHUD.Admin.EndScreen", server = true, convar = "codhud_enable_roundend", tooltip = "CoDHUD.Admin.EndScreen.desc" },
                            { type = "checkbox", label = "#CoDHUD.Admin.EndScreen.StartNext", server = true, convar = "codhud_enable_roundend_startnext", tooltip = "CoDHUD.Admin.EndScreen.StartNext.desc" },
							{ type = "checkbox", label = "#CoDHUD.Admin.FriendlyFire", server = true, convar = "codhud_friendly_fire", tooltip = "CoDHUD.Admin.FriendlyFire.desc" },
                            { type = "combobox", label = "#CoDHUD.Autobalance.Amount", tooltip = "CoDHUD.Autobalance.Amount.desc", choices = {
									{"CoDHUD.Autobalance.Amount.disable", "0"},
									{"CoDHUD.Autobalance.Amount.2", "2"},
									{"CoDHUD.Autobalance.Amount.3", "3"},
									{"CoDHUD.Autobalance.Amount.4", "4"},
								},
								getCurrent = function() return GetConVar("codhud_autofaction_limit"):GetString() end,

								onSelect = function(_, data)
									net.Start("CoDHUD_SetAutoFaction")
									net.WriteString(data)
									net.SendToServer()
								end
							},
							{ type = "combobox", label = "#CoDHUD.Admin.RestrictFactionChance", tooltip = "CoDHUD.Admin.RestrictFactionChance.desc", choices = {
									{"CoDHUD.Admin.RestrictFactionChance.disable", "0"},
									{"CoDHUD.Admin.RestrictFactionChance.freely", "1"},
									{"CoDHUD.Admin.RestrictFactionChance.pool", "2"},
								},
								getCurrent = function()
									return GetConVar("codhud_restrictfactions"):GetString()
								end,
								onSelect = function(_, data)
									RunConsoleCommand("codhud_restrictfactions", data)
								end
							}
                        }
                    },
					
					{ name = "#CoDHUD.RoundStart", adminOnly = true, controls = {

							{ type = "combobox", label = "#CoDHUD.RoundStart.Gamemode", tooltip = "CoDHUD.RoundStart.Info",
								-- choices = function() return CoDHUD.Gamemodes[CoDHUD_GetHUDType()] or {} end,
								choices = {
									{"#MW2_MPUI_WAR", "war"},
									{"#MW2_MPUI_DEATHMATCH", "dm"},
								},
								getCurrent = function() return GetConVar("codhud_selected_gamemode"):GetString() end,
								onSelect = function(_, data)
									net.Start("CoDHUD_SetGamemode")
									net.WriteString(data)
									net.SendToServer()
								end
							},
							
                            { type = "slider", label = "#CoDHUD.Scorelimit", server = true, convar = "codhud_score_limit", tooltip = "CoDHUD.Scorelimit.desc", min = 1, max = 150 },
							
                            { type = "slider", label = "#CoDHUD.Timelimit", server = true, convar = "codhud_time_limit", tooltip = "CoDHUD.Timelimit.desc", min = 0, max = 30 },
							
                            { type = "slider", label = "#CoDHUD.RoundStart.Timer", server = true, convar = "codhud_matchstart_timer", tooltip = "CoDHUD.RoundStart.Timer.desc", min = 0, max = 15 },
							
							{ type = "checkbox", label = "#CoDHUD.RoundStart.Autobalance", server = true, convar = "codhud_autobalance_on_roundstart", tooltip = "CoDHUD.RoundStart.Autobalance.desc" },
							
							{ type = "button", label = "#CoDHUD.RoundStart.Start", 
								func = function()
									local lp = LocalPlayer()
									if not IsValid(lp) or not lp:IsAdmin() then return end

									CoDHUD_RS_OpenConfirm()

									if IsValid(codhud_menu_frame) then
										codhud_menu_frame:SetVisible(false)
									end
								end
							},

							{ type = "button", label = "#CoDHUD.ForceEndRound", 
								func = function()
									local lp = LocalPlayer()
									if not IsValid(lp) or not lp:IsAdmin() then return end
                                    if not _G.CoDHUD_RoundActiveCL then return end

									CoDHUD_RS_OpenForceEndConfirm()

									if IsValid(codhud_menu_frame) then
										codhud_menu_frame:SetVisible(false)
									end
								end
							}
						}
					},
					
                    { name = "#CoDHUD.Admin.RestrictType", adminOnly = true, controls = {
                            { type = "combobox", label = "#CoDHUD.Admin.RestrictType.Choose", tooltip = "CoDHUD.Admin.RestrictType.desc", choices = CoDHUD.GetHUDList(),
								getCurrent = function() return GetConVar("codhud_game"):GetString() end,
								onSelect = function(_, data)
									local current = GetConVar("codhud_game"):GetString()

									if data == current then return end

									CoDHUD_OpenGameConfirm(data)
								end
							},
                        }
                    },
                }
            }
        }
    },

	{ name = "#CoDHUD.Stats", getSubtabs = function()
			local tabs = {}

			for _, hud in pairs(CoDHUD.TypeRegistry or {}) do
				table.insert(tabs, {
					name = hud.name,
					categories = {
						{
							name = hud.name,
							type = "playerstats",
							hud = hud.codename
						}
					}
				})
			end

			table.sort(tabs, function(a, b)
				return a.name < b.name
			end)

			return tabs
		end
	},
}

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

local function CreateCategory(parent, data)
    if data.adminOnly and not LocalPlayer():IsAdmin() then return end

    local cat = vgui.Create("DCollapsibleCategory", parent)

    cat:SetLabel(data.name)
	
    cat:Dock(TOP)
    cat:DockMargin(5, 5, 5, 0)
	cat.Paint = nil
	
	cat.Header.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, (w * 0.33), h, Color(0, 0, 0))
	end
	
	-- cat.Paint = function(self, w, h)
		-- draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
	-- end

    local inner = vgui.Create("DPanel", cat)
    inner:Dock(TOP)
    inner:DockPadding(5, 5, 5, 5)		
	inner.Paint = nil
	
	-- inner.Paint = function(self, w, h)
		-- draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
	-- end

    cat:SetContents(inner)

    -- Special case: Factions
    if data.type == "factions" then
        local grid = vgui.Create("DGrid", inner)
        grid:SetCols(3)
        grid:SetColWide(CoDHUD_S(64))
        grid:SetRowHeight(CoDHUD_S(64))
        grid:Dock(TOP)

		local sorted = {}
		local factions = CoDHUD.Factions[CoDHUD_GetHUDType()] or {}
		local factionCounts = {}

		for _, ply in ipairs(player.GetAll()) do
			local fac = ply:GetNW2String("CoDHUD_Faction", "rangers")
			if fac == "" then fac = "rangers" end

			factionCounts[fac] = (factionCounts[fac] or 0) + 1
		end

		for id, factionData in pairs(factions) do
			table.insert(sorted, {id = id, data = factionData})
		end

		table.sort(sorted, function(a, b)
			return (a.data.order or 0) < (b.data.order or 0)
		end)

		for _, entry in ipairs(sorted) do
			local id = entry.id
			local faction = entry.data
			local count = factionCounts[id] or 0

			local btn = vgui.Create("DImageButton")
			btn:SetSize(CoDHUD_S(64), CoDHUD_S(64))
			if faction.scoreIcon then
				btn:SetImage(faction.scoreIcon)
			else
				print("[CoDHUD] Missing scoreIcon for faction:", id)
			end
            btn:SetToolTip(language.GetPhrase(faction.name) or id:upper())

			local current = LocalPlayer():GetNW2String("CoDHUD_Faction", "rangers")

			btn.DoClick = function()
				local current = LocalPlayer():GetNW2String("CoDHUD_Faction", "rangers")
				if id == current then return end

				local mode = CoDHUD.RestrictFactions

				-- 0 = blocked
				if mode == 0 then return end

				-- 2 = pool restriction
				if mode == 2 then
					local pool = CoDHUD.Factions.ActivePool or {}
					if not table.HasValue(pool, id) then return end
				end

				CoDHUD_OpenFactionConfirm(id)
				surface.PlaySound("ui/buttonclick.wav")
			end

			btn.PaintOver = function(self, w, h)
				local current = LocalPlayer():GetNW2String("CoDHUD_Faction", "rangers")
				local mode = CoDHUD.RestrictFactions

				local blocked = false

				if id ~= current then
					if mode == 0 then
						blocked = true
					elseif mode == 2 then
						local pool = CoDHUD.Factions.ActivePool or {}
						if not table.HasValue(pool, id) then
							blocked = true
						end
					end
				end

				-- Darken blocked factions
				if blocked then
					surface.SetDrawColor(0, 0, 0, 180)
					surface.DrawRect(0, 0, w, h)
				end

				-- Existing selection highlight
				if current == id then
					surface.SetDrawColor(255, 255, 255, 60)
					surface.DrawOutlinedRect(0, 0, w, h, 4)

					surface.SetDrawColor(255, 255, 255, 255)
					surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
				end

				-- Player count (keep your existing code below)
				if count > 0 then
					local txt = tostring(count)

					surface.SetFont("DermaDefaultBold")
					local tw, th = surface.GetTextSize(txt)

					local pad = 6
					local bx = w - tw - pad * 2 - 4
					local by = 4

					-- background box
					draw.RoundedBox(4, bx, by, tw + pad * 2, th + pad, Color(0, 0, 0, 225))

					-- text
					draw.SimpleText(txt, "DermaDefaultBold", bx + (tw + pad * 2) / 2, by + (th + pad) / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			end

            grid:AddItem(btn)
        end
				
		local helper = vgui.Create("DLabel", inner)
		helper:SetText("#CoDHUD.Faction.Select.desc")
		helper:SetWrap(true)
		helper:SetAutoStretchVertical(true)
		helper:Dock(TOP)
		helper:DockMargin(5, 5, 5, 0)
		helper:SetContentAlignment(7) -- top-left

    end

    -- Player Stats
    if data.type == "playerstats" then
        local lines = CoDHUD_GetPlayerStatsLines(data.hud)

        for _, line in ipairs(lines) do
            local lbl = vgui.Create("DLabel", inner)

            lbl:SetText(line)
            lbl:SetFont("CoDHUD_Settings_Sec")

            lbl:SetWrap(true)
            lbl:SetAutoStretchVertical(true)

            lbl:Dock(TOP)
            lbl:DockMargin(5, 4, 5, 4)

            function lbl:PerformLayout()
                self:SetFGColor(Color(255,255,255))
            end
        end
    end
	
    -- Controls
    PopulateControls(inner, data.controls)

    -- Children (nested categories)
    for _, child in ipairs(data.children or {}) do
        CreateCategory(inner, child)
    end
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
				-- { type = "bool", text = "CoDHUD.Menu.Music", desc = "CoDHUD.Menu.Music.desc", convar = "codhud_menu_music" },
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
				{ type = "bool", text = "CoDHUD.HUD.Challenges.Enable", desc = "CoDHUD.HUD.Challenges.Enable.desc", convar = "codhud_enable_challenges", requireparentconvar = "codhud_quickdisable_hud", parentinvert = true, noprefix = true },


				{ type = "label", text = "CoDHUD.Reset" },
				{ type = "button", text = "CoDHUD.Rank.Reset", desc = "CoDHUD.Rank.Reset.desc", playsfx = "clickopen", prompts = {"CoDHUD.Glyph.OpenMenu"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.ConfirmRankReset, true) end },
				{ type = "button", text = "CoDHUD.Challenges.Reset", desc = "CoDHUD.Challenges.Reset.desc", playsfx = "clickopen", prompts = {"CoDHUD.Glyph.OpenMenu"}, func = function()
					RunConsoleCommand("codhud_challenge_clear")
				end },

			},
			
			{ TabName = "CoDHUD.Server", sv = true, NoTitle = true, playsfx = "confirm", -- Welcome Page
				{ type = "label", text = "CoDHUD.General" },
				{ type = "bool", text = "CoDHUD.Admin.EndScreen", desc = "CoDHUD.Admin.EndScreen.desc", convar = "codhud_enable_roundend", sv = true },
				{ type = "bool", text = "CoDHUD.Admin.EndScreen.StartNext", desc = "CoDHUD.Admin.EndScreen.StartNext.desc", convar = "codhud_enable_roundend_startnext", sv = true },
				{ type = "bool", text = "CoDHUD.Admin.FriendlyFire", desc = "CoDHUD.Admin.FriendlyFire.desc", convar = "codhud_friendly_fire", sv = true },
				
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
				
				{ type = "label", text = "CoDHUD.RoundStart" },
				{ type = "combo", text = "CoDHUD.RoundStart.Gamemode", desc = "CoDHUD.RoundStart.Info", convar = "codhud_selected_gamemode", sv = true, content = {
					{"#MW2_MPUI_WAR", "war"},
					{"#MW2_MPUI_DEATHMATCH", "dm"},
				}},
				{ type = "slider", text = "CoDHUD.Scorelimit", desc = "CoDHUD.Scorelimit.desc", convar = "codhud_score_limit", sv = true, min = 1, max = 150, decimals = 0 },
				{ type = "slider", text = "CoDHUD.Timelimit", desc = "CoDHUD.Timelimit.desc", convar = "codhud_time_limit", sv = true, min = 0, max = 30, decimals = 0 },
				{ type = "slider", text = "CoDHUD.RoundStart.Timer", desc = "CoDHUD.RoundStart.Timer.desc", convar = "codhud_matchstart_timer", sv = true, min = 0, max = 15, decimals = 0 },
				{ type = "bool", text = "CoDHUD.RoundStart.Autobalance", desc = "CoDHUD.RoundStart.Autobalance.desc", convar = "codhud_autobalance_on_roundstart", sv = true },
				-- { type = "bool", text = "CoDHUD.Admin.EndScreen", desc = "CoDHUD.Admin.EndScreen.desc", convar = "codhud_enable_roundend", sv = true },
				{ type = "button", text = "CoDHUD.RoundStart.Start", desc = "CoDHUD.RoundStart.Start.desc", playsfx = "clickopen", prompts = {"CoDHUD.Glyph.OpenMenu"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.ConfirmRoundStart, true) end, sv = true },
				
				{ type = "button", text = "CoDHUD.ForceEndRound", desc = "CoDHUD.ForceEndRound.desc", playsfx = "clickopen", prompts = {"CoDHUD.Glyph.OpenMenu"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.ConfirmRoundStop, true) end, cond = function() return _G.CoDHUD_RoundActiveCL end, sv = true },

				{ type = "label", text = "CoDHUD.Admin.RestrictType" },
				{ type = "combo", text = "CoDHUD.Admin.RestrictType.Choose", desc = "CoDHUD.Admin.RestrictType.desc", convar = "codhud_game", sv = true, content = CoDHUD.GetHUDList(), func = function(_, _, data)
					local current = GetConVar("codhud_game"):GetString()
					if data == current then return end

					CoDHUDMenu.ConfirmGameChange(data)
				end}
			},
			
			-- { TabName = "CoDHUD.Close", Prompts = { "CoDHUD.Glyph.OpenMenu" }, func = function()
					-- CoDHUDMenu.OpenStatsMenu()
				-- end,
			-- },
			
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
				end, sv = true },
				
				{ type = "button", text = "dialog.cancel", playsfx = "confirm", prompts = {"CoDHUD.Glyph.Return"}, func = function()
					CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true) 
					pendingFaction = nil
				end, sv = true },
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
				{ type = "button", text = "CoDHUD.RoundStart.Yes", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					net.Start("CoDHUD_StartRound")
					net.SendToServer()
					
					CoDHUDMenu.CloseCurrentMenu()
				end, sv = true },
				{ type = "button", text = "CoDHUD.RoundStart.No", playsfx = "clickback", prompts = {"CoDHUD.Glyph.Return"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true) end, sv = true },
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
				{ type = "button", text = "CoDHUD.ForceEndRound.Yes", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					net.Start("CoDHUD_EndRound")
					net.SendToServer()
					
					CoDHUDMenu.CloseCurrentMenu()
				end, sv = true },
				{ type = "button", text = "CoDHUD.ForceEndRound.No", playsfx = "clickback", prompts = {"CoDHUD.Glyph.Return"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true) end, sv = true },
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
					CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true)
				end, sv = true },
				{ type = "button", text = "dialog.cancel", playsfx = "clickback", prompts = {"CoDHUD.Glyph.Return"}, func = function()
					CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true)
				end, sv = true },
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
				{ type = "button", text = "CoDHUD.ForceEndRound.Yes", prompts = {"CoDHUD.Glyph.Confirm"}, func = function()
					net.Start("CoDHUD_SetGame")
					net.WriteString(pendingGame)
					net.SendToServer()
					
					CoDHUDMenu.CloseCurrentMenu()
				end, sv = true },
				{ type = "button", text = "CoDHUD.ForceEndRound.No", playsfx = "clickback", prompts = {"CoDHUD.Glyph.Return"}, func = function() CoDHUDMenu.OpenMenu(CoDHUDMenu.Main, true) end, sv = true },
			},
		}
	})
end

function CoDHUDMenu.OpenStatsMenu()
    local fs = GetConVar("codhud_menu_fullscreen"):GetBool()
    local menusize = fs and 1 or 0.75
	

    local tabs = {}

    for gameId, stats in pairs(CoDHUD.Stats or {}) do
        table.insert(tabs, {
            TabName = "Game: " .. gameId,
            NoTitle = true,

            {
                type = "infosimple",
                text = "CoDHUD.Stats.Header"
            },

            {
                type = "playerstats",
                hud = gameId
            }
        })
    end

    CoDHUDMenu.CurrentMenu = CoDHUDMenu:Open({
        Name = CoDHUDString("CoDHUD.Title") .. " - Stats",
        Width  = ScrW() * menusize,
        Height = ScrH() * menusize,
        Tabs = tabs
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

	--[[

	local fs = GetConVar("codhud_menu_fullscreen"):GetBool()
	local menusize = fs and 1 or 0.55
	
	codhud_menu_frame = vgui.Create("DFrame")
	local frame = codhud_menu_frame
	frame:SetSize(ScrW() * menusize, ScrH() * menusize)
	frame:Center()
	frame:SetTitle("#CoDHUD.Title")
	frame:MakePopup()
	
	local closebtn
	
	if fs then
		frame:SetDraggable(false)
		frame:ShowCloseButton(false)
		
		-- Close Button (Fullscreen only)
		closebtn = vgui.Create("DButton", frame)
		closebtn:Dock(BOTTOM)
		closebtn:SetWide(150)
		closebtn:SetText("#close")

		closebtn.DoClick = function()
			if IsValid(codhud_menu_frame) then
				codhud_menu_frame:Close()
			end
		end
	end

	frame.Paint = function(self, w, h)
		if CoDHUD[CoDHUD_GetHUDType()] and CoDHUD[CoDHUD_GetHUDType()].SettingsMenu then
			CoDHUD[CoDHUD_GetHUDType()].SettingsMenu(w, h)
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(100,100,100))

			surface.SetDrawColor(255, 255, 255, 125)
			surface.SetMaterial( Material("mw2/settings/menu_anim") )
			surface.DrawTexturedRect(0, 0, w, h)
			
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial( Material("mw2/settings/menu_bg") )
			surface.DrawTexturedRect(0, 0, w, h)
		end
    end

	local sheet = vgui.Create("DPropertySheet", frame)
	sheet:Dock(FILL)
	sheet.Paint = nil

	for _, tab in ipairs(CoDHUD_SETTINGS) do
		local tabPanel = vgui.Create("DPanel", sheet)
		tabPanel:Dock(FILL)
		tabPanel.Paint = nil

		local subSheet = vgui.Create("DPropertySheet", tabPanel)
		subSheet:Dock(FILL)
		subSheet.Paint = nil

		local subtabs = tab.subtabs

		if tab.getSubtabs then
			subtabs = tab.getSubtabs()
		end

		for _, subtab in ipairs(subtabs or {}) do
			local subPanel = vgui.Create("DScrollPanel", subSheet)
			subPanel.Paint = nil

			for _, catData in ipairs(subtab.categories or {}) do
				CreateCategory(subPanel, catData)
			end

			subSheet:AddSheet(language.GetPhrase(subtab.name), subPanel)
		end

		sheet:AddSheet(language.GetPhrase(tab.name), tabPanel)
	end
	]]--
end)