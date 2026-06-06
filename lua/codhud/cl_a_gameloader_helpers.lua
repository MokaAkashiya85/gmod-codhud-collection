---- [ CLIENT GAME LOADER & GLOBAL HELPERS ] ----
CoDHUD = CoDHUD or {}
CoDHUD.Factions = CoDHUD.Factions or {}
CoDHUD.Gamemodes = CoDHUD.Gamemodes or {}

-- Fuck GMod sometimes.
function CoDHUDString(key)
    if not isstring(key) then return "" end
    if key:StartWith("#") then
        key = key:sub(2)
    end
    return string.Trim(language.GetPhrase(key))
end

-- [[ RESOLUTION SCALING ]]
local BASE_W, BASE_H = 1920, 1080

function CoDHUD_GetUIScaleMultiplier()
	local cv = GetConVar("codhud_scale")
	if cv and cv:GetFloat() then return cv:GetFloat()
	else return 1 end
end

function CoDHUD_GetUIScale()
    local scaleX = ScrW() / BASE_W * CoDHUD_GetUIScaleMultiplier()
    local scaleY = ScrH() / BASE_H * CoDHUD_GetUIScaleMultiplier()
    return math.min(scaleX, scaleY)
end

function CoDHUD_S(x)  return math.Round(x * CoDHUD_GetUIScale()) end
function CoDHUD_SX(x) return math.Round(x * CoDHUD_GetUIScale()) end
function CoDHUD_SY(y) return math.Round(y * CoDHUD_GetUIScale()) end

-- [[ FONT INIT ]]
function CoDHUD_InitiateFonts()
	-- [ SETTINGS ]
    surface.CreateFont( "CoDHUD_Settings_Header",	{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(42), weight = 10,  antialias = true })
    surface.CreateFont( "CoDHUD_Settings_Main",		{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(32), weight = 10,  antialias = true })
    surface.CreateFont( "CoDHUD_Settings_Sec",		{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(28), weight = 10,  antialias = true })
    surface.CreateFont( "CoDHUD_Settings_Tri",		{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(24), weight = 10,  antialias = true })

	-- Keybind Fonts
	surface.CreateFont("CoDHUD_KeybindFont", { font = "Destiny Keys", size = CoDHUD_S(24), weight = 500, extended = true })
	surface.CreateFont("CoDHUD_KeybindFontBig", { font = "Destiny Keys", size = CoDHUD_S(34), weight = 500, extended = true })
	surface.CreateFont("CoDHUD_KeybindFontSmall", { font = "Destiny Keys", size = CoDHUD_S(18), weight = 500, extended = true })	
	
	-- [ CoD4 ]
	-- Hitmarker / XP
	surface.CreateFont( "CoD4_Score_Main",			{ font = "Carbon Regular", size = CoDHUD_S(36), weight = 400, antialias = true, shadow = true })
	surface.CreateFont( "CoD4_Score_Plus",			{ font = "Carbon Regular", size = CoDHUD_S(32), weight = 800, antialias = true, shadow = true })
	
	-- Round End
	surface.CreateFont( "CoD4_RE_Sc_Pri",			{ font = "Carbon Regular", size = CoDHUD_S(54),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "CoD4_RE_Sc_Sec",			{ font = "Carbon Regular", size = CoDHUD_S(54),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "CoD4_RE_Sc_Shd",			{ font = "Carbon Regular", size = CoDHUD_S(54),  weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "CoD4_RE_Re_Pri",			{ font = "Carbon Regular", size = CoDHUD_S(72), weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "CoD4_RE_Re_Sec",			{ font = "Carbon Regular", size = CoDHUD_S(72), weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "CoD4_RE_Re_Shd",			{ font = "Carbon Regular", size = CoDHUD_S(72), weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "CoD4_RE_Li_Pri",			{ font = "Carbon Regular", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "CoD4_RE_Li_Sec",			{ font = "Carbon Regular", size = CoDHUD_S(48),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "CoD4_RE_Li_Shd",			{ font = "Carbon Regular", size = CoDHUD_S(48),  weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "CoD4_RE_Bonus",			{ font = "Carbon Regular", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })

	-- Round Start
    surface.CreateFont( "CoD4_RS_Timer",			{ font = "Carbon Regular", size = CoDHUD_S(80), weight = 400, antialias = true, shadow = true })

	-- Score Bar
	surface.CreateFont( "CoD4_Timer", 				{ font = "Carbon Regular", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = false, })
    surface.CreateFont( "CoD4_Status",				{ font = "Carbon Regular", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "CoD4_Font",				{ font = "Carbon Regular", size = CoDHUD_S(36), weight = 400, antialias = true, })
			
	-- Scoreboard
    surface.CreateFont( "CoD4_Scoreboard_Text",		{ font = "Carbon Regular", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "CoD4_Scoreboard_Text2",		{ font = "Carbon Regular", size = CoDHUD_S(30), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "CoD4_Scoreboard_Headers",	{ font = "Carbon Regular", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "CoD4_Scoreboard_Timer",	{ font = "BankGothic Md BT", size = CoDHUD_S(34), weight = 400, antialias = true, })
	
	-- Weapon HUD
    surface.CreateFont("CoD4_Res",					{ font = "Carbon Regular", size = CoDHUD_S(64), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("CoD4_Res_3D",				{ font = "Carbon Regular", size = CoDHUD_S(44), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("CoD4_Res_4D",				{ font = "Carbon Regular", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("CoD4_Wep_Name",				{ font = "Carbon Regular", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("CoD4_Stat_Font",			{ font = "Carbon Regular", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("CoD4_Ammo_Alt",				{ font = "Carbon Regular", size = CoDHUD_S(36), weight = 400, antialias = true, shadow = true, extended = true })
	
	-- [ WaW ]
	-- Challenges
    surface.CreateFont( "WaW_ChalHeader_Pri",		{ font = "Optima Std Roman", size = CoDHUD_S(46), weight = 10,  blursize = 0, antialias = true,  outline = false, extended = true })
    surface.CreateFont( "WaW_ChalHeader_Sec",		{ font = "Optima Std Roman", size = CoDHUD_S(46), weight = 10,  blursize = 5, antialias = true,  outline = false, extended = true })
    surface.CreateFont( "WaW_ChalHeader_Shd",		{ font = "Optima Std Roman", size = CoDHUD_S(46), weight = 400, blursize = 2, antialias = false, outline = true , extended = true })

    surface.CreateFont( "WaW_ChalHeader",			{ font = "Optima Std Roman", size = CoDHUD_S(50), weight = 800,  antialias = true, extended = true })
    surface.CreateFont( "WaW_ChalHeader_Glow",		{ font = "Optima Std Roman", size = CoDHUD_S(52), weight = 1000, blursize = CoDHUD_S(12), antialias = true, extended = true })
    surface.CreateFont( "WaW_ChalSub",				{ font = "Optima Std Roman", size = CoDHUD_S(28), weight = 400,  antialias = true, extended = true })
	
	-- Chat
	surface.CreateFont( "WaW_ChatFont",				{ font = "Optima Std Roman",  size = CoDHUD_S(22),  weight = 400,  antialias = true, shadow = true })
	
	-- Hitmarker / XP
	surface.CreateFont( "WaW_Score_Main",			{ font = "Optima Std Roman", size = CoDHUD_S(36), weight = 400, antialias = true, shadow = true })
	surface.CreateFont( "WaW_Score_Plus",			{ font = "Optima Std Roman", size = CoDHUD_S(32), weight = 800, antialias = true, shadow = true })
	
	-- Killfeed
    surface.CreateFont( "WaW_KillfeedFont",			{ font = "Optima Std Roman", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, outline = false, })
	
	-- Round End
	surface.CreateFont( "WaW_RE_Sc_Pri",			{ font = "Optima Std Roman", size = CoDHUD_S(54),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "WaW_RE_Sc_Sec",			{ font = "Optima Std Roman", size = CoDHUD_S(54),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "WaW_RE_Sc_Shd",			{ font = "Optima Std Roman", size = CoDHUD_S(54),  weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "WaW_RE_Re_Pri",			{ font = "Optima Std Roman", size = CoDHUD_S(72), weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "WaW_RE_Re_Sec",			{ font = "Optima Std Roman", size = CoDHUD_S(72), weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "WaW_RE_Re_Shd",			{ font = "Optima Std Roman", size = CoDHUD_S(72), weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "WaW_RE_Li_Pri",			{ font = "Optima Std Roman", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "WaW_RE_Li_Sec",			{ font = "Optima Std Roman", size = CoDHUD_S(48),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "WaW_RE_Li_Shd",			{ font = "Optima Std Roman", size = CoDHUD_S(48),  weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "WaW_RE_Bonus",				{ font = "Optima Std Roman", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
		
	-- Round Start	
	surface.CreateFont( "WaW_RS_H_Pri",				{ font = "Optima Std Roman", size = CoDHUD_S(64), weight = 800,  blursize = 0, antialias = true,  outline = false, extended = true })
    surface.CreateFont( "WaW_RS_H_Sec",				{ font = "Optima Std Roman", size = CoDHUD_S(64), weight = 800,  blursize = 5, antialias = true,  outline = false, extended = true })
    surface.CreateFont( "WaW_RS_H_Shd",				{ font = "Optima Std Roman", size = CoDHUD_S(64), weight = 800, blursize = 2, antialias = false, outline = true , extended = true })

    surface.CreateFont( "WaW_RS_O_Pri",				{ font = "Optima Std Roman", size = CoDHUD_S(46), weight = 10,  blursize = 0, antialias = true,  outline = false, extended = true })
    surface.CreateFont( "WaW_RS_O_Sec",				{ font = "Optima Std Roman", size = CoDHUD_S(46), weight = 10,  blursize = 5, antialias = true,  outline = false, extended = true })
    surface.CreateFont( "WaW_RS_O_Shd",				{ font = "Optima Std Roman", size = CoDHUD_S(46), weight = 400, blursize = 2, antialias = false, outline = true , extended = true })

    surface.CreateFont( "WaW_RS_S_Pri",				{ font = "Optima Std Roman", size = CoDHUD_S(32), weight = 400, antialias = true, shadow = true })

    surface.CreateFont( "WaW_RS_Timer",				{ font = "Optima Std Roman", size = CoDHUD_S(80), weight = 400, antialias = true, shadow = true })

	-- Round Start
    surface.CreateFont( "WaW_RS_Timer",				{ font = "Optima Std Roman", size = CoDHUD_S(60), weight = 400, antialias = true, shadow = true })

	-- Score Bar
	surface.CreateFont( "WaW_Timer", 				{ font = "Optima Std Roman", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = false, })
    surface.CreateFont( "WaW_Status",				{ font = "Optima Std Roman", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "WaW_Font",					{ font = "Optima Std Roman", size = CoDHUD_S(32), weight = 400, antialias = true, })

	-- Scoreboard
    surface.CreateFont( "WaW_Scoreboard_Text",		{ font = "Optima Std Roman", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "WaW_Scoreboard_Text2",		{ font = "Optima Std Roman", size = CoDHUD_S(30), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "WaW_Scoreboard_Headers",	{ font = "Optima Std Roman", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "WaW_Scoreboard_Timer",		{ font = "Optima Std Roman", size = CoDHUD_S(34), weight = 400, antialias = true, })
	
	-- Weapon HUD
    surface.CreateFont("WaW_Res",					{ font = "Optima Std Roman", size = CoDHUD_S(64), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("WaW_Res_3D",				{ font = "Optima Std Roman", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("WaW_Res_4D",				{ font = "Optima Std Roman", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("WaW_Wep_Name",				{ font = "Optima Std Roman", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("WaW_Stat_Font",			{ font = "Optima Std Roman", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("WaW_Ammo_Alt",				{ font = "Optima Std Roman", size = CoDHUD_S(36), weight = 400, antialias = true, shadow = true, extended = true })
	
	-- [ MW2 ]
	-- Challenges
    surface.CreateFont( "MW2_ChalHeader_Pri",		{ font = "Carbon Regular", size = CoDHUD_S(46), weight = 10,  blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "MW2_ChalHeader_Sec",		{ font = "Carbon Regular", size = CoDHUD_S(46), weight = 10,  blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "MW2_ChalHeader_Shd",		{ font = "Carbon Regular", size = CoDHUD_S(46), weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "MW2_ChalHeader",			{ font = "Conduit ITC", size = CoDHUD_S(50), weight = 800,  antialias = true })
    surface.CreateFont( "MW2_ChalHeader_Glow",		{ font = "Conduit ITC", size = CoDHUD_S(52), weight = 1000, blursize = CoDHUD_S(12), antialias = true })
    surface.CreateFont( "MW2_ChalSub",				{ font = "Conduit ITC", size = CoDHUD_S(28), weight = 400,  antialias = true })
	
	-- Chat
	surface.CreateFont( "MW2_ChatFont",				{ font = "Conduit ITC",  size = CoDHUD_S(22),  weight = 400,  antialias = true, shadow = true })
	
	-- Hitmarker / XP
	surface.CreateFont( "MW2_Score_Main",			{ font = "BankGothic Md BT", size = CoDHUD_S(36), weight = 400, antialias = true, shadow = true })
	surface.CreateFont( "MW2_Score_Plus",			{ font = "BankGothic Md BT", size = CoDHUD_S(32), weight = 800, antialias = true, shadow = true })
	
	-- Killfeed
    surface.CreateFont( "MW2_KillfeedFont",			{ font = "Conduit ITC", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, outline = false, })
	
	-- Medals
	surface.CreateFont( "MW2_MedalPrimary",			{ font = "Conduit ITC", size = CoDHUD_S(42), weight = 800,  antialias = true })
	surface.CreateFont( "MW2_MedalGlow",			{ font = "Conduit ITC", size = CoDHUD_S(44), weight = 1000, antialias = true, blursize = CoDHUD_S(12) })
	surface.CreateFont( "MW2_MedalOutline",			{ font = "Conduit ITC", size = CoDHUD_S(42), weight = 900,  antialias = true, outline = false })
	surface.CreateFont( "MW2_MedalPoints",			{ font = "Conduit ITC", size = CoDHUD_S(30), weight = 400,  antialias = true })
	surface.CreateFont( "MW2_MedalDesc",			{ font = "Conduit ITC", size = CoDHUD_S(26), weight = 500,  antialias = true })
	
	-- Round End
	surface.CreateFont( "MW2_RE_Sc_Pri",			{ font = "BankGothic Md BT", size = CoDHUD_S(54),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RE_Sc_Sec",			{ font = "BankGothic Md BT", size = CoDHUD_S(54),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RE_Sc_Shd",			{ font = "BankGothic Md BT", size = CoDHUD_S(54),  weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "MW2_RE_Re_Pri",			{ font = "BankGothic Md BT", size = CoDHUD_S(72), weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RE_Re_Sec",			{ font = "BankGothic Md BT", size = CoDHUD_S(72), weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RE_Re_Shd",			{ font = "BankGothic Md BT", size = CoDHUD_S(72), weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "MW2_RE_Li_Pri",			{ font = "BankGothic Md BT", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RE_Li_Sec",			{ font = "BankGothic Md BT", size = CoDHUD_S(48),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RE_Li_Shd",			{ font = "BankGothic Md BT", size = CoDHUD_S(48),  weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "MW2_RE_Bonus",				{ font = "BankGothic Md BT", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
		
	-- Round Start	
	surface.CreateFont( "MW2_RS_H_Pri",				{ font = "Carbon Regular", size = CoDHUD_S(64), weight = 800,  blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RS_H_Sec",				{ font = "Carbon Regular", size = CoDHUD_S(64), weight = 800,  blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RS_H_Shd",				{ font = "Carbon Regular", size = CoDHUD_S(64), weight = 800, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "MW2_RS_O_Pri",				{ font = "Carbon Regular", size = CoDHUD_S(46), weight = 10,  blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RS_O_Sec",				{ font = "Carbon Regular", size = CoDHUD_S(46), weight = 10,  blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "MW2_RS_O_Shd",				{ font = "Carbon Regular", size = CoDHUD_S(46), weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "MW2_RS_S_Pri",				{ font = "Carbon Regular", size = CoDHUD_S(32), weight = 400, antialias = true, shadow = true })

    surface.CreateFont( "MW2_RS_Timer",				{ font = "BankGothic Md BT", size = CoDHUD_S(80), weight = 400, antialias = true, shadow = true })

	-- Score Bar	
	surface.CreateFont( "MW2_Timer", 				{ font = "BankGothic Md BT", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = false, })
    surface.CreateFont( "MW2_Status",				{ font = "BankGothic Md BT", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "MW2_Font",					{ font = "BankGothic Md BT", size = CoDHUD_S(36), weight = 400, antialias = true, })
		
	-- Scoreboard
    surface.CreateFont( "MW2_Scoreboard_Text",		{ font = "Conduit ITC Light", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "MW2_Scoreboard_Text2",		{ font = "Conduit ITC Light", size = CoDHUD_S(30), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "MW2_Scoreboard_Rank",		{ font = "Conduit ITC Light", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "MW2_Scoreboard_Timer",		{ font = "BankGothic Md BT", size = CoDHUD_S(34), weight = 400, antialias = true, })
	
	-- IFF
    surface.CreateFont("MW2_TargetName_Primary",	{ font = "Conduit ITC",  size = CoDHUD_S(32), weight = 400, antialias = true, shadow = true })

	-- Voice Chat
	surface.CreateFont("MW2_VoiceFont",				{ font = "Conduit ITC",  size = CoDHUD_S(30),  weight = 600,  antialias = true, shadow = true })
	
	-- Weapon HUD
    surface.CreateFont("MW2_Res",					{ font = "BankGothic Md BT", size = CoDHUD_S(64), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("MW2_Res_3D",				{ font = "BankGothic Md BT", size = CoDHUD_S(48), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("MW2_Res_4D",				{ font = "BankGothic Md BT", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("MW2_Wep_Name",				{ font = "BankGothic Md BT", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("MW2_Stat_Font",				{ font = "BankGothic Md BT", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("MW2_Ammo_Alt",				{ font = "BankGothic Md BT", size = CoDHUD_S(36), weight = 400, antialias = true, shadow = true, extended = true })	

	-- [ BO1 ]
	-- Challenges
    surface.CreateFont( "BO1_ChalHeader",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(64), weight = 800,  antialias = true })
    surface.CreateFont( "BO1_ChalSub",				{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(40), weight = 400,  antialias = true })
	
	-- Chat
	surface.CreateFont( "BO1_ChatFont",				{ font = "HelveticaNeue MediumCond",  size = CoDHUD_S(22),  weight = 400,  antialias = true, shadow = true })
	
	-- Hitmarker / XP
	surface.CreateFont( "BO1_Score_Main",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(46), weight = 400, antialias = true, shadow = true })
	surface.CreateFont( "BO1_Score_Plus",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(42), weight = 800, antialias = true, shadow = true })
	
	-- Killfeed
    surface.CreateFont( "BO1_KillfeedFont",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, outline = false, })
	
	-- Medals
	surface.CreateFont( "BO1_MedalPrimary",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(72), weight = 100,  antialias = true })
	surface.CreateFont( "BO1_MedalPoints",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(28), weight = 400,  antialias = true })
	surface.CreateFont( "BO1_MedalDesc",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(32), weight = 500,  antialias = true })
	
	-- Round End
	surface.CreateFont( "BO1_RE_Sc_Pri",			{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(54),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RE_Sc_Sec",			{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(54),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RE_Sc_Shd",			{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(54),  weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "BO1_RE_Re_Pri",			{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(72), weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RE_Re_Sec",			{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(72), weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RE_Re_Shd",			{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(72), weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "BO1_RE_Li_Pri",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RE_Li_Sec",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(48),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RE_Li_Shd",			{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(48),  weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "BO1_RE_Bonus",				{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
		
	-- Round Start	
	surface.CreateFont( "BO1_RS_H_Pri",				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(64), weight = 10,  blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RS_H_Sec",				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(64), weight = 10,  blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RS_H_Shd",				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(64), weight = 10, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "BO1_RS_O_Pri",				{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(46), weight = 10,  blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RS_O_Sec",				{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(46), weight = 10,  blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO1_RS_O_Shd",				{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(46), weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "BO1_RS_S_Pri",				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(28), weight = 1, antialias = true, shadow = true })

    surface.CreateFont( "BO1_RS_Timer",				{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(64), weight = 400, antialias = true, shadow = true })

	-- Score Bar	
	surface.CreateFont( "BO1_Timer", 				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = false, })
    surface.CreateFont( "BO1_Status",				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(28), weight = 0, antialias = true, shadow = true, })
    surface.CreateFont( "BO1_Font",					{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(40), weight = 0, antialias = true, })
    surface.CreateFont( "BO1_Font2",					{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(30), weight = 400, antialias = true, })
		
	-- Scoreboard
    surface.CreateFont( "BO1_Scoreboard_Text",		{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(28), weight = 100, antialias = true, shadow = true, })
    surface.CreateFont( "BO1_Scoreboard_Text2",		{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(24), weight = 100, antialias = true, shadow = true, })
    surface.CreateFont( "BO1_Scoreboard_Score",		{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(64), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "BO1_Scoreboard_Timer",		{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(34), weight = 400, antialias = true, })
	
	-- IFF
    surface.CreateFont("BO1_TargetName_Primary",	{ font = "HelveticaNeue MediumCond",  size = CoDHUD_S(32), weight = 400, antialias = true, shadow = true })

	-- Voice Chat
	surface.CreateFont("BO1_VoiceFont",				{ font = "HelveticaNeue MediumCond",  size = CoDHUD_S(30),  weight = 600,  antialias = true, shadow = true })
	
	-- Weapon HUD
    surface.CreateFont("BO1_Res",					{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("BO1_Res_Large",				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(56), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("BO1_Wep_Name",				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(38), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("BO1_Stat_Font",				{ font = "MorrisSansW04-MediumCond", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont("BO1_Ammo_Alt",				{ font = "HelveticaNeue MediumCond", size = CoDHUD_S(20), weight = 400, antialias = true, shadow = true, extended = true })
	
	-- [ BO2 ]
	-- Challenges
    surface.CreateFont( "BO2_ChalHeader",			{ font = "AgencyFB", size = CoDHUD_S(48), weight = 800,  antialias = true })
    surface.CreateFont( "BO2_ChalSub",				{ font = "AgencyFB", size = CoDHUD_S(32), weight = 400,  antialias = true })
	
	-- Chat
	surface.CreateFont( "BO2_ChatFont",				{ font = "AgencyFB",  size = CoDHUD_S(22),  weight = 400,  antialias = true, shadow = true })
	
	-- Hitmarker / XP
	surface.CreateFont( "BO2_Score_Main",			{ font = "AgencyFB", size = CoDHUD_S(46), weight = 400, antialias = true, shadow = true })
	surface.CreateFont( "BO2_Score_Plus",			{ font = "AgencyFB", size = CoDHUD_S(42), weight = 800, antialias = true, shadow = true })
	
	-- Killfeed
    surface.CreateFont( "BO2_KillfeedFont",			{ font = "AgencyFB", size = CoDHUD_S(34), weight = 400, antialias = true, shadow = true, outline = false, })
	
	-- Medals
	surface.CreateFont( "BO2_MedalPrimary",			{ font = "AgencyFB", size = CoDHUD_S(32), weight = 100,  antialias = true })
	
	-- Round End
	surface.CreateFont( "BO2_RE_Sc_Pri",			{ font = "AgencyFB", size = CoDHUD_S(54),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RE_Sc_Sec",			{ font = "AgencyFB", size = CoDHUD_S(54),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RE_Sc_Shd",			{ font = "AgencyFB", size = CoDHUD_S(54),  weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "BO2_RE_Re_Pri",			{ font = "AgencyFB", size = CoDHUD_S(72), weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RE_Re_Sec",			{ font = "AgencyFB", size = CoDHUD_S(72), weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RE_Re_Shd",			{ font = "AgencyFB", size = CoDHUD_S(72), weight = 400, blursize = 2, antialias = false, outline = true  })
    
    surface.CreateFont( "BO2_RE_Li_Pri",			{ font = "AgencyFB", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RE_Li_Sec",			{ font = "AgencyFB", size = CoDHUD_S(48),  weight = 400, blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RE_Li_Shd",			{ font = "AgencyFB", size = CoDHUD_S(48),  weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "BO2_RE_Bonus",				{ font = "AgencyFB", size = CoDHUD_S(48),  weight = 400, blursize = 0, antialias = true,  outline = false })
		
	-- Round Start	
	surface.CreateFont( "BO2_RS_H_Pri",				{ font = "AgencyFB", size = CoDHUD_S(32), weight = 10,  blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RS_H_Sec",				{ font = "AgencyFB", size = CoDHUD_S(32), weight = 10,  blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RS_H_Shd",				{ font = "AgencyFB", size = CoDHUD_S(32), weight = 10, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "BO2_RS_O_Pri",				{ font = "AgencyFB", size = CoDHUD_S(46), weight = 10,  blursize = 0, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RS_O_Sec",				{ font = "AgencyFB", size = CoDHUD_S(46), weight = 10,  blursize = 5, antialias = true,  outline = false })
    surface.CreateFont( "BO2_RS_O_Shd",				{ font = "AgencyFB", size = CoDHUD_S(46), weight = 400, blursize = 2, antialias = false, outline = true  })

    surface.CreateFont( "BO2_RS_S_Pri",				{ font = "AgencyFB", size = CoDHUD_S(36), weight = 1, antialias = true, shadow = true })
    surface.CreateFont( "BO2_RS_Timer",				{ font = "AgencyFB", size = CoDHUD_S(48), weight = 400, antialias = true, shadow = true })

	-- Score Bar
	surface.CreateFont( "BO2_Timer", 				{ font = "AgencyFB", size = CoDHUD_S(34), weight = 400, antialias = true, italic = true, })
    surface.CreateFont( "BO2_Status",				{ font = "AgencyFB", size = CoDHUD_S(34), weight = 0, antialias = true, italic = true, })
    surface.CreateFont( "BO2_Font",					{ font = "AgencyFB", size = CoDHUD_S(72), weight = 0, antialias = true, italic = true, })
    surface.CreateFont( "BO2_Font2",				{ font = "AgencyFB", size = CoDHUD_S(48), weight = 400, antialias = true, italic = true, })
		
	-- Scoreboard
    surface.CreateFont( "BO2_Scoreboard_Text",		{ font = "AgencyFB", size = CoDHUD_S(32), weight = 100, antialias = true, shadow = true, })
    surface.CreateFont( "BO2_Scoreboard_Text2",		{ font = "AgencyFB", size = CoDHUD_S(36), weight = 100, antialias = true, shadow = true, })
    surface.CreateFont( "BO2_Scoreboard_Score",		{ font = "AgencyFB", size = CoDHUD_S(72), weight = 400, antialias = true, shadow = true, })
    surface.CreateFont( "BO2_Scoreboard_Timer",		{ font = "AgencyFB", size = CoDHUD_S(34), weight = 400, antialias = true, })
	
	-- IFF
    surface.CreateFont( "BO2_TargetName_Primary",	{ font = "AgencyFB",  size = CoDHUD_S(32), weight = 400, antialias = true, shadow = true })

	-- Voice Chat
	surface.CreateFont( "BO2_VoiceFont",			{ font = "AgencyFB",  size = CoDHUD_S(30),  weight = 600,  antialias = true, shadow = true })
	
	-- Weapon HUD
    surface.CreateFont( "BO2_Res",					{ font = "AgencyFB", size = CoDHUD_S(54), weight = 400, antialias = true, shadow = true, italic = true, extended = true })
    surface.CreateFont( "BO2_Res_Large",			{ font = "AgencyFB", size = CoDHUD_S(73), weight = 400, antialias = true, shadow = true, italic = true, extended = true })
    surface.CreateFont( "BO2_Wep_Name",				{ font = "AgencyFB", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, italic = true, extended = true })
    surface.CreateFont( "BO2_Stat_Font",			{ font = "AgencyFB", size = CoDHUD_S(28), weight = 400, antialias = true, shadow = true, extended = true })
    surface.CreateFont( "BO2_Ammo_Alt",				{ font = "AgencyFB", size = CoDHUD_S(26), weight = 400, antialias = true, shadow = true, italic = true, extended = true })
end

hook.Add("InitPostEntity", "CoDHUD_InitFonts", function() timer.Simple(0, function() CoDHUD_InitiateFonts() end) end) -- Delay initial font creation until convars are loaded
hook.Add("OnScreenSizeChanged", "CoDHUD_ReinitFonts", function() CoDHUD_InitiateFonts() end) -- Rebuild when resolution changes
cvars.AddChangeCallback("codhud_scale", function() CoDHUD_InitiateFonts() end, "CoDHUD_ScaleChanged") -- Rebuild when the scale cvar changes

function CoDHUD_GetFactionColor(ent)
    if not IsValid(ent) then return Color(255,255,255) end
    local faction = ent:GetNW2String("CoDHUD_Faction", "rangers")

	if CoDHUD_ActiveGamemodeCL == "dm" then return Color(255,255,255) end

    if CoDHUD.Factions[CoDHUD_GetHUDType()][faction] and CoDHUD.Factions[CoDHUD_GetHUDType()][faction].killfeedcol then 
		return CoDHUD.Factions[CoDHUD_GetHUDType()][faction].killfeedcol
	end

    return Color(255,255,255)
end

local utf8_upper_map = {
-- This shit sucks but it's necessary due to GMod's bullshit

-- Latin-1 Supplement
["à"]="À",["á"]="Á",["â"]="Â",["ã"]="Ã",["ä"]="Ä",["å"]="Å",["æ"]="Æ",["ç"]="Ç",["è"]="È",["é"]="É",["ê"]="Ê",
["ë"]="Ë",["ì"]="Ì",["í"]="Í",["î"]="Î",["ï"]="Ï",["ð"]="Ð",["ñ"]="Ñ",["ò"]="Ò",["ó"]="Ó",["ô"]="Ô",
["õ"]="Õ", ["ö"]="Ö", ["ø"]="Ø", ["ù"]="Ù", ["ú"]="Ú", ["û"]="Û", ["ü"]="Ü", ["ý"]="Ý", ["þ"]="Þ", ["ß"]="SS",

-- Latin Extended-A (common EU letters)
["ą"]="Ą",["ć"]="Ć",["ę"]="Ę",["ł"]="Ł",["ń"]="Ń",["ś"]="Ś",["ź"]="Ź",["ż"]="Ż",["č"]="Č",["ď"]="Ď",
["ě"]="Ě",["ň"]="Ň",["ř"]="Ř",["š"]="Š",["ť"]="Ť",["ů"]="Ů",["ž"]="Ž",["ā"]="Ā",["ē"]="Ē",["ī"]="Ī",["ū"]="Ū",["ō"]="Ō",

-- Greek
["α"]="Α",["β"]="Β",["γ"]="Γ",["δ"]="Δ",["ε"]="Ε",["ζ"]="Ζ",["η"]="Η",["θ"]="Θ",["ι"]="Ι",["κ"]="Κ",["λ"]="Λ",["μ"]="Μ",
["ν"]="Ν",["ξ"]="Ξ",["ο"]="Ο",["π"]="Π",["ρ"]="Ρ",["σ"]="Σ",["ς"]="Σ",["τ"]="Τ",["υ"]="Υ",["φ"]="Φ",["χ"]="Χ",["ψ"]="Ψ",["ω"]="Ω",

-- Cyrillic
["а"]="А",["б"]="Б",["в"]="В",["г"]="Г",["д"]="Д",["е"]="Е",["ё"]="Ё",["ж"]="Ж",["з"]="З",["и"]="И",["й"]="Й",["к"]="К",["л"]="Л",
["м"]="М",["н"]="Н",["о"]="О",["п"]="П",["р"]="Р",["с"]="С",["т"]="Т",["у"]="У",["ф"]="Ф",["х"]="Х",["ц"]="Ц",["ч"]="Ч",["ш"]="Ш",["щ"]="Щ",
["ъ"]="Ъ",["ы"]="Ы",["ь"]="Ь",["э"]="Э",["ю"]="Ю",["я"]="Я",
}

function CoDHUD_UpperText(str)
    if not str then return "" end

    -- First pass: ASCII upper (fast + handles A-Z)
    str = string.upper(str)

    -- UTF-8 pass
    return (str:gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
        return utf8_upper_map[c] or c
    end))
end


-- Carried over from Unit Vehicles
function CoDHUDBindButtonName(var)
	local keyName = input.GetKeyName(var)
	if not keyName then return "UNKNOWN" end
	local upperKeyName = string.upper(keyName)
	return upperKeyName
end

-- Glyph tables
CoDHUDKeyGlyphs = {}

-- Keyboard & Mouse
CoDHUDKeyGlyphs.kb = {
	["MOUSE1"] = "<color=51,150,218></color>" .. "", 
	["MOUSE2"] = "<color=51,150,218></color>" .. "", 
	["MOUSE3"] = "<color=51,150,218></color>" .. "", 
	["MOUSE4"] = "<color=51,150,218></color>" .. "", 
	["MOUSE5"] = "<color=51,150,218></color>" .. "", 
	["MWHEELDOWN"] = "<color=51,150,218></color>" .. "",
	["MWHEELUP"] = "<color=51,150,218></color>" .. "",
	
	["ö"] = "<color=51,51,51><color=255,255,255></color></color>",
	["ä"] = "<color=51,51,51><color=255,255,255></color></color>",
	["ì"] = "<color=51,51,51><color=255,255,255></color></color>",
	["è"] = "<color=51,51,51><color=255,255,255></color></color>",
	["é"] = "<color=51,51,51><color=255,255,255></color></color>",
	["ß"] = "<color=51,51,51><color=255,255,255></color></color>",
	["c"] = "<color=51,51,51><color=255,255,255></color></color>",
	["ò"] = "<color=51,51,51><color=255,255,255></color></color>",
	["à"] = "<color=51,51,51><color=255,255,255></color></color>",
	["ù"] = "<color=51,51,51><color=255,255,255></color></color>",
	["a"] = "<color=51,51,51><color=255,255,255></color></color>",
	["b"] = "<color=51,51,51><color=255,255,255></color></color>",
	["c"] = "<color=51,51,51><color=255,255,255></color></color>",
	["d"] = "<color=51,51,51><color=255,255,255></color></color>",
	["e"] = "<color=51,51,51><color=255,255,255></color></color>",
	["f"] = "<color=51,51,51><color=255,255,255></color></color>",
	["g"] = "<color=51,51,51><color=255,255,255></color></color>",
	["h"] = "<color=51,51,51><color=255,255,255></color></color>",
	["i"] = "<color=51,51,51><color=255,255,255></color></color>",
	["j"] = "<color=51,51,51><color=255,255,255></color></color>",
	["k"] = "<color=51,51,51><color=255,255,255></color></color>",
	["l"] = "<color=51,51,51><color=255,255,255></color></color>",
	["m"] = "<color=51,51,51><color=255,255,255></color></color>",
	["n"] = "<color=51,51,51><color=255,255,255></color></color>",
	["o"] = "<color=51,51,51><color=255,255,255></color></color>",
	["p"] = "<color=51,51,51><color=255,255,255></color></color>",
	["q"] = "<color=51,51,51><color=255,255,255></color></color>",
	["r"] = "<color=51,51,51><color=255,255,255></color></color>",
	["s"] = "<color=51,51,51><color=255,255,255></color></color>",
	["t"] = "<color=51,51,51><color=255,255,255></color></color>",
	["u"] = "<color=51,51,51><color=255,255,255></color></color>",
	["v"] = "<color=51,51,51><color=255,255,255></color></color>",
	["w"] = "<color=51,51,51><color=255,255,255></color></color>",
	["x"] = "<color=51,51,51><color=255,255,255></color></color>",
	["y"] = "<color=51,51,51><color=255,255,255></color></color>",
	["z"] = "<color=51,51,51><color=255,255,255></color></color>",
	["ü"] = "<color=51,51,51><color=255,255,255></color></color>",
	
	["0"] = "<color=51,51,51><color=255,255,255></color></color>",
	["1"] = "<color=51,51,51><color=255,255,255></color></color>",
	["2"] = "<color=51,51,51><color=255,255,255></color></color>",
	["3"] = "<color=51,51,51><color=255,255,255></color></color>",
	["4"] = "<color=51,51,51><color=255,255,255></color></color>",
	["5"] = "<color=51,51,51><color=255,255,255></color></color>",
	["6"] = "<color=51,51,51><color=255,255,255></color></color>",
	["7"] = "<color=51,51,51><color=255,255,255></color></color>",
	["8"] = "<color=51,51,51><color=255,255,255></color></color>",
	["9"] = "<color=51,51,51><color=255,255,255></color></color>",
	["'"] = "<color=51,51,51><color=255,255,255></color></color>",
	["*"] = "<color=51,51,51><color=255,255,255></color></color>",
	["+"] = "<color=51,51,51><color=255,255,255></color></color>",
	[","] = "<color=51,51,51><color=255,255,255></color></color>",
	["-"] = "<color=51,51,51><color=255,255,255></color></color>",
	
	["KP_SLASH"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_MULTIPLY"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_INS"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_END"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_DOWNARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_PGDN"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_LEFTARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_5"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_RIGHTARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_HOME"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_UPARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_PGUP"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_MINUS"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_PLUS"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_ENTER"] = "<color=51,51,51><color=255,255,255></color></color>",
	["KP_DEL"] = "<color=51,51,51><color=255,255,255></color></color>",
	
	["SPACE"] = "<color=51,51,51><color=255,255,255></color></color>",
	["DEL"] = "<color=51,51,51><color=255,255,255></color></color>",
	["BACKSPACE"] = "<color=51,51,51><color=255,255,255></color></color>",
	["TAB"] = "<color=51,51,51><color=255,255,255></color></color>",
	["ENTER"] = "<color=51,51,51><color=255,255,255></color></color>",
	["SHIFT"] = "<color=51,51,51><color=255,255,255></color></color>",
	["RSHIFT"] = "<color=51,51,51><color=255,255,255></color></color>",
	["CTRL"] = "<color=51,51,51><color=255,255,255></color></color>",
	["RCTRL"] = "<color=51,51,51><color=255,255,255></color></color>",
	["ALT"] = "<color=51,51,51><color=255,255,255></color></color>",
	["RALT"] = "<color=51,51,51><color=255,255,255></color></color>",
	["UPARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
	["DOWNARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
	["LEFTARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
	["RIGHTARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
	["INS"] = "<color=51,51,51><color=255,255,255></color></color>",
	["END"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F1"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F2"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F3"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F4"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F5"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F6"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F7"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F8"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F9"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F10"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F11"] = "<color=51,51,51><color=255,255,255></color></color>",
	["F12"] = "<color=51,51,51><color=255,255,255></color></color>",
	
	["["] = "<color=51,51,51><color=255,255,255></color></color>",
	["]"] = "<color=51,51,51><color=255,255,255></color></color>",
	["/"] = "<color=51,51,51><color=255,255,255></color></color>",
	["SEMICOLON"] = "<color=51,51,51><color=255,255,255></color></color>",
	["="] = "<color=51,51,51><color=255,255,255></color></color>",
	["\\"] = "<color=51,51,51><color=255,255,255></color></color>",
	["."] = "<color=51,51,51><color=255,255,255></color></color>",
	-- ["."] = "<color=51,51,51><color=255,255,255></color></color>",
	["CAPSLOCK"] = "<color=51,51,51><color=255,255,255></color></color>",
}

local lastGlyphUpdate = -1
local CoDHUDCommandFallbacks = {
	invnext = "MWHEELDOWN",  -- default glyph key
	invprev = "MWHEELUP",
	slot1   = "1",
	slot2   = "2",
	lastinv = "q",
}

-- The main functions
function CoDHUDKeybindIcon(key, size)
	local font = "CoDHUD_KeybindFont"  -- default
	if size == "Big" then
		font = "CoDHUD_KeybindFontBig"
	elseif size == "Small" then
		font = "CoDHUD_KeybindFontSmall"
	end
	
	local alpha = alpha or 255

	local wrap = function(str)
		return "<font=" .. font .. ">" .. str .. "</font>"
	end

	local parts = string.Split(key, ".")
	local glyph = "[" .. key .. "]"

	if #parts == 1 then
		if CoDHUDKeyGlyphs.kb[parts[1]] then
			glyph = CoDHUDKeyGlyphs.kb[parts[1]]
		end
	elseif #parts == 2 then
		local family, subkey = parts[1], parts[2]
		if family == "kb" and CoDHUDKeyGlyphs.kb[subkey] then
			glyph = CoDHUDKeyGlyphs.kb[subkey]
		elseif family == "mouse" and CoDHUDKeyGlyphs.mouse[subkey] then
			glyph = CoDHUDKeyGlyphs.mouse[subkey]
		elseif family == "xbox" and CoDHUDKeyGlyphs.xbox[subkey] then
			glyph = CoDHUDKeyGlyphs.xbox[subkey]
		elseif family == "ps" and CoDHUDKeyGlyphs.ps[subkey] then
			glyph = CoDHUDKeyGlyphs.ps[subkey]
		elseif family == "switch" and CoDHUDKeyGlyphs.switch[subkey] then
			glyph = CoDHUDKeyGlyphs.switch[subkey]
		elseif subkey == "all" then
			local tbl = CoDHUDKeyGlyphs[family]
			if tbl then
				local out = {}
				for _, glyph in pairs(tbl) do
					out[#out + 1] = glyph
				end
				glyph = table.concat(out, "")
			end
		end
	end

	return wrap(glyph)
end

local function ResolveKeybind(token)
	if token:sub(1, 1) == "+" then -- console command (+use, +jump, etc.)
		return input.LookupBinding(token, true)
	end

	local cv = GetConVar(token)
	if cv then
		return input.GetKeyName(cv:GetInt())
	end

	return nil
end

local function ResolveCommandGlyph(cmd)
	local clean = cmd:gsub("^%+", "")
	-- Check fallback table
	if CoDHUDCommandFallbacks[clean] then return CoDHUDCommandFallbacks[clean] end

	-- Fallback to normal keybind
	return ResolveKeybind(cmd) or "???"
end

function CoDHUDReplaceKeybinds(str, glyphsize)
	local glyphsize = glyphsize or nil

	-- [+use] or [command]
	str = str:gsub("%[([%+]?[%w_]+)%]", function(cmd)
		return CoDHUDKeybindIcon(ResolveCommandGlyph(cmd), glyphsize)
	end)

	-- [key:convar_name]
	str = str:gsub("%[key:([%w_]+)%]", function(cvar)
		local key = ResolveKeybind(cvar)
		if not key then return "???" end
		return CoDHUDKeybindIcon(key, glyphsize)
	end)

	-- [string:phrase]
	str = str:gsub("%[string:([^%]]+)%]", function(locstring)
		return "<color=255,255,0>" .. CoDHUDString(locstring) .. "</color>"
	end)

	-- [ncstring:phrase] -- Without colour
	str = str:gsub("%[ncstring:([^%]]+)%]", function(locstring)
		return CoDHUDString(locstring)
	end)

	-- [glyph:phrase]
	str = str:gsub("%[glyph:([^%]]+)%]", function(glyph)
		return CoDHUDKeybindIcon(glyph, glyphsize)
	end)

	return str
end

function CoDHUDDiscordTextFormat(str)
	str = str:gsub("%*%*(.-)%*%*", "<font=CoDHUDSettingsFontSmall-Bold>%1</font>")
	str = str:gsub("(%s)%*(.-)%*", "<font=CoDHUDSettingsFontSmall-Italic> %2 </font>")
	str = str:gsub("^%*(.-)%*", "[i]%1[/i]")
	str = str:gsub("__(.-)__", "[u]%1[/u]")
	str = str:gsub("^#%s*(.-)\n", "<font=CoDHUDSettingsFontBig>%1</font>\n")
	str = str:gsub("\n#%s*(.-)\n", "\n<font=CoDHUDSettingsFontBig>%1</font>\n")
	return str
end

CoDHUD_MapNameTable = {
	--[[ BASE GAME & MOUNTABLES ]] --
	-- Base GMod 
	gm_construct = "Construct",
	gm_flatgrass = "Flatgrass",
		
	-- CS:S
	cs_assault = "Assault",
	cs_havana = "Havana",
	cs_italy = "Italy",
	cs_militia = "Militia",
	cs_office = "Office",
	de_aztec = "Aztec",
	de_cbble = "Cobblestone",
	de_chateau = "Chateau",
	de_dust = "Dust",
	de_dust2 = "Dust II",
	de_inferno = "Inferno",
	de_nuke = "Nuke",
	de_piranesi = "Piranesi",
	de_port = "Port",
	de_prodigy = "Prodigy",
	de_tides = "Tides",
	de_train = "Train",

	-- Day of Defeat: Source
	dod_anzio = "Anzio",
	dod_argentan = "Argentan",
	dod_avalanche = "Avalanche",
	dod_colmar = "Colmar",
	dod_donner = "Donner",
	dod_flash = "Flash",
	dod_jagd = "Jagd",
	dod_kalt = "Kalt",
	dod_palermo = "Palermo",

	-- Half-Life 2: Deathmatch
	dm_lockdown = "Lockdown",
	dm_overwatch = "Overwatch",
	dm_powerhouse = "Powerhouse",
	dm_resistance = "Resistance",
	dm_runoff = "Runoff",
	dm_steamlab = "Steamlab",
	dm_underpass = "Underpass",

	-- Team Fortress 2
	["2koth_abbey"] = "Abbey",
	arena_afterlife = "Afterlife",
	arena_badlands = "Badlands",
	arena_byre = "Byre",
	arena_granary = "Granary",
	arena_lumberyard = "Lumberyard",
	arena_lumberyard_event = "Lumberyard (Event)",
	arena_nucleus = "Nucleus",
	arena_offblast_final = "Offblast",
	arena_perks = "Perks",
	arena_ravine = "Ravine",
	arena_sawmill = "Sawmill",
	arena_watchtower = "Watchtower",
	arena_well = "Well",
	cppl_gavle = "Gavle",
	cp_5gorge = "5-Gorge",
	cp_altitude = "Altitude",
	cp_ambush_event = "Ambush (Event)",
	cp_badlands = "Badlands",
	cp_brew = "Brew",
	cp_burghausen = "Burghausen",
	cp_canaveral_5cp = "Canaveral",
	cp_cargo = "Cargo",
	cp_carrier = "Carrier",
	cp_cloak = "Cloak",
	cp_coldfront = "Coldfront",
	cp_conifer = "Conifer",
	cp_cowerhouse = "Cowerhouse",
	cp_darkmarsh = "Darmarsh",
	cp_degrootkeep = "Degroot Keep",
	cp_degrootkeep_rats = "Degroot Keep (Rats)",
	cp_dustbowl = "Dustbowl",
	cp_egypt_final = "Egypt",
	cp_fastlane = "Fastlane",
	cp_fortezza = "Fortezza",
	cp_foundry = "Foundry",
	cp_freaky_fair = "Freaky Fair",
	cp_freight_final1 = "Freight",
	cp_frostwatch = "Frostwatch",
	cp_fulgur = "Fulgur",
	cp_gorge = "Gorge",
	cp_gorge_event = "Gorge (Event)",
	cp_granary = "Granary",
	cp_gravelpit = "Gravelpit",
	cp_gravelpit_snowy = "Gravelpit (Snowy)",
	cp_gullywash_final1 = "Gullywash",
	cp_hadal = "Hadal",
	cp_hardwood_final = "Hardwood",
	cp_junction_final = "Junction",
	cp_lavapit_final = "Lavapit",
	cp_manor_event = "Manor",
	cp_mercenarypark = "Mercenary Park",
	cp_metalworks = "Metalworks",
	cp_mossrock = "Mossrock",
	cp_mountainlab = "Mountain Lab",
	cp_overgrown = "Overgrown",
	cp_powerhouse = "Powerhouse",
	cp_process_final = "Process",
	cp_reckoner = "Reckoner",
	cp_snakewater_final1 = "Snakewater",
	cp_snowplow = "Snowplow",
	cp_spookeyridge = "Spookey Ridge",
	cp_standin_final = "Standin",
	cp_steel = "Steel",
	cp_sulfur = "Sulfur",
	cp_sunshine = "Sunshine",
	cp_sunshine_event = "Sunshine (Event)",
	cp_vanguard = "Vanguard",
	cp_well = "Well",
	cp_yukon_final = "Yukon",
	ctf_2fort = "2Fort",
	ctf_2fort_invasion = "2Fort (Invasion)",
	ctf_applejack = "Applejack",
	ctf_crasher = "Crasher",
	ctf_doublecross = "Doublecross",
	ctf_doublecross_event = "Doublecross (Event)",
	ctf_doublecross_snowy = "Doublecross (Snowy)",
	ctf_foundry = "Foundry",
	ctf_frosty = "Frosty",
	ctf_gorge = "Gorge",
	ctf_haarp = "Haarp",
	ctf_hellfire = "Hellfire",
	ctf_helltrain_event = "Hellfire (Event)",
	ctf_landfall = "Landfall",
	ctf_pelican_peak = "Pelican",
	ctf_penguin_peak = "Penguin Peak",
	ctf_pressure = "Pressure",
	ctf_sawmill = "Sawmill",
	ctf_sidewinder = "Sidewinder",
	ctf_snowfall_final = "Snowfall",
	ctf_thundermountain = "Thunder Mountain",
	ctf_turbine = "Turbine",
	ctf_turbine_winter = "Turbine (Winter)",
	ctf_well = "Well",
	htf_marshlands = "Marshlands",
	koth_badlands = "Badlands",
	koth_bagel_event = "Bagel (Event)",
	koth_blowout = "Blowout",
	koth_boardwalk = "Boardwalk",
	koth_brazil = "Brazil",
	koth_cachoeira = "Cachoeira",
	koth_cascade = "Cascade",
	koth_demolition = "Demolition",
	koth_dusker = "Dusker",
	koth_harvest_event = "Harvest (Event)",
	koth_harvest_final = "Harvest",
	koth_highpass = "Highpass",
	koth_king = "King",
	koth_krampus = "Krampus",
	koth_lakeside_event = "Lakeside (Event)",
	koth_lakeside_final = "Lakeside",
	koth_lazarus = "Lazarus",
	koth_los_muertos = "Los Muertos",
	koth_mannhole = "Mannhole",
	koth_maple_ridge_event = "Maple Ridge",
	koth_megalo = "Megalo",
	koth_megaton = "Megaton",
	koth_moonshine_event = "Moonshine (Event)",
	koth_nucleus = "Nucleus",
	koth_overcast_final = "Overcast",
	koth_probed = "Probed",
	koth_rotunda = "Rotunda",
	koth_sawmill = "Sawmill",
	koth_sawmill_event = "Sawmill (Event)",
	koth_sharkbay = "Shark Bay",
	koth_slasher = "Slasher",
	koth_slaughter_event = "Slasher (Event)",
	koth_slime = "Slime",
	koth_snowtower = "Snowtower",
	koth_suijin = "Suijin",
	koth_synthetic_event = "Synthetic (Event)",
	koth_toxic = "Toxic",
	koth_undergrove_event = "Undergrove (Event)",
	koth_viaduct = "Viaduct",
	koth_viaduct_event = "Viaduct (Event)",
	koth_winter_ridge = "Winter Ridge",
	mvm_bigrock = "Big Rock",
	mvm_coaltown = "Coal Town",
	mvm_decoy = "Decoy",
	mvm_ghost_town = "Ghost Town",
	mvm_mannhattan = "Mannhattan",
	mvm_mannworks = "Mannworks",
	mvm_rottenburg = "Rottenburg",
	pass_brickyard = "Brickyard",
	pass_district = "District",
	pass_timbertown = "Timber Town",
	pd_atom_smash = "Atom Smash",
	pd_circus = "Circus",
	pd_cursed_cove_event = "Cursed Cove (Event)",
	pd_farmageddon = "Farmageddon",
	pd_galleria = "Galleria",
	pd_mannsylvania = "Mannsylvania",
	pd_monster_bash = "Monster Bash",
	pd_nutcracker = "Nutcracker",
	pd_pit_of_death_event = "Pit of Death (Event)",
	pd_selbyen = "Selbyen",
	pd_snowville_event = "Snowville (Event)",
	pd_watergate = "Watergate",
	plr_bananabay = "Banana Bay",
	plr_cutter = "Cutter",
	plr_hacksaw = "Hacksaw",
	plr_hacksaw_event = "Hacksaw (Event)",
	plr_hightower = "Hightower",
	plr_hightower_event = "Hightower (Event)",
	plr_matterhorn = "Matterhorn",
	plr_nightfall_final = "Nightfall",
	plr_pipeline = "Pipeline",
	pl_aquarius = "Aquarius",
	pl_badwater = "Badwater",
	pl_barnblitz = "Barnblitz",
	pl_bloodwater = "Bloodwater",
	pl_borneo = "Borneo",
	pl_breadspace = "Breadspace",
	pl_cactuscanyon = "Cactus Canyon",
	pl_camber = "Camber",
	pl_cashworks = "Cashworks",
	pl_chilly = "Chilly",
	pl_citadel = "Citadel",
	pl_coal_event = "Coal (Event)",
	pl_corruption = "Corruption",
	pl_embargo = "Embargo",
	pl_emerge = "Emerge",
	pl_enclosure_final = "Enclosure",
	pl_fifthcurve_event = "Fifth Curve (Event)",
	pl_frontier_final = "Frontier",
	pl_frostcliff = "Frostcliff",
	pl_goldrush = "Goldrush",
	pl_hasslecastle = "Hassle Castle",
	pl_hoodoo_final = "Hoodoo",
	pl_millstone_event = "Millstone (Event)",
	pl_odyssey = "Odyssey",
	pl_patagonia = "Patagonia",
	pl_phoenix = "Phoenix",
	pl_pier = "Pier",
	pl_precipice_event_final = "Precipice (Event)",
	pl_rumble_event = "Rumble",
	pl_rumford_event = "Rumford",
	pl_sludgepit_event = "Sludgepit",
	pl_snowycoast = "Snowy Coast",
	pl_spineyard = "Spineyard",
	pl_swiftwater_final1 = "Swiftwater",
	pl_terror_event = "Terror (Event)",
	pl_thundermountain = "Thunder Mountain",
	pl_upward = "Upward",
	pl_venice = "Venice",
	pl_wutville_event = "Wutville (Event)",
	rd_asteroid = "Asteroid",
	sd_doomsday = "Doomsday",
	sd_doomsday_event = "Doomsday (Event)",
	tc_hydro = "Hydro",
	tow_dynamite = "Dynamite",
	tr_dustbowl = "Dustbowl",
	tr_target = "Target Practice",
	vsh_distillery = "Distillery",
	vsh_maul = "Maul",
	vsh_nucleus = "Nucleus",
	vsh_outburst = "Outburst",
	vsh_skirmish = "Skirmish",
	vsh_tinyrock = "Tinyrock",
	zi_atoll = "Atoll",
	zi_blazehattan = "Blazehattan",
	zi_devastation_final1 = "Devastation",
	zi_murky = "Murky",
	zi_sanitarium = "Sanitarium",
	zi_woods = "Woods",

	-- Insurgency (Standalone)
	buhriz = "Buhriz",
	buhriz_hunt = "Buhriz (Hunt)",
	buhriz_coop = "Buhriz (Checkpoint)",
	buhriz_night = "Buhriz Night",
	contact = "Contact",
	contact_night = "Contact Night",
	contact_coop = "Contact (Checkpoint)",
	contact_hunt = "Contact (Hunt)",
	district = "District",
	district_coop = "District (Checkpoint)",
	district_hunt = "District (Hunt)",
	district_survival = "District (Survival)",
	district_night = "District Night",
	drycanal = "Dry Canal",
	drycanal_night = "Dry Canal Night",
	drycanal_coop = "Dry Canal (Checkpoint)",
	embassy = "Embassy",
	embassy_coop = "Embassy (Checkpoint)",
	embassy_night = "Embassy Night",
	embassy_outpost = "Embassy (Outpost)",
	embassy_survival = "Embassy (Survival)",
	embassy_hunt = "Embassy (Hunt)",
	heights = "Heights",
	heights_coop = "Heights (Checkpoint)",
	heights_hunt = "Heights (Hunt)",
	heights_night = "Heights Night",
	heights_survival = "Heights (Survival)",
	heights_outpost = "Heights (Outpost)",
	kandagal = "Kandagal",
	kandagal_night = "Kandagal Night",
	market = "Market",
	market_coop = "Market (Checkpoint)",
	market_hunt = "Market (Hunt)",
	market_survival = "Market (Survival)",
	market_night = "Market Night",
	market_outpost = "Market (Outpost)",
	ministry = "Ministry",
	ministry_coop = "Ministry (Checkpoint)",
	ministry_hunt = "Ministry (Hunt)",
	ministry_night = "Ministry Night",
	ministry_survival = "Ministry (Survival)",
	ministry_outpost = "Ministry (Outpost)",
	range = "Firing Range",
	siege = "Siege",
	siege_night = "Siege Night",
	siege_coop = "Siege (Checkpoint)",
	panj = "Panj",
	panj_hunt = "Panj (Hunt)",
	panj_night = "Panj Night",
	panj_outpost = "Panj (Outpost)",
	peak = "Peak",
	peak_coop = "Peak (Checkpoint)",
	peak_hunt = "Peak (Hunt)",
	peak_night = "Peak Night",
	peak_outpost = "Peak (Outpost)",
	revolt = "Revolt",
	revolt_coop = "Revolt (Checkpoint)",
	revolt_hunt = "Revolt (Hunt)",
	revolt_night = "Revolt Night",
	sinjar = "Sinjar",
	sinjar_coop = "Sinjar (Checkpoint)",
	sinjar_hunt = "Sinjar (Hunt)",
	sinjar_night = "Sinjar Night",
	sinjar_survival = "Sinjar (Survival)",
	sinjar_outpost = "Sinjar (Outpost)",
	station = "Station",
	station_night = "Station Night",
	station_hunt = "Station (Hunt)",
	tell = "Tell",
	tell_coop = "Tell (Checkpoint)",
	tell_night = "Tell Night",
	tell_hunt = "Tell (Hunt)",
	tell_survival = "Tell (Survival)",
	uprising = "Uprising",
	uprising_hunt = "Uprising (Hunt)",
	uprising_night = "Uprising Night",
	verticality = "Verticality",
	verticality_coop = "Verticality (Checkpoint)",
	verticality_hunt = "Verticality (Hunt)",
	verticality_night = "Verticality Night",
	verticality_survival = "Verticality (Survival)",
	verticality_outpost = "Verticality (Outpost)",
	training = "Training Warehouse",

	--[[ CUSTOM MAPS ]] --

}

function CoDHUD_MapName(name)
	return CoDHUD_MapNameTable[name] or string.NiceName(name)
end