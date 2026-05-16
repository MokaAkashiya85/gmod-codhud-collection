---- [ SHARED ROUND END ] ----

CreateConVar("codhud_enable_roundend", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Enable or disable the MW2 round end screen.")
CreateConVar("codhud_enable_roundend_startnext", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Immediately starts a new 'Round' once the current one ends.")

if SERVER then
    util.AddNetworkString("CoDHUD_RoundEnd")
    util.AddNetworkString("CoDHUD_EndRound")
end