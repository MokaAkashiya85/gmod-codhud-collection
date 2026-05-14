---- [ SERVER HITMARKER & XP ] ----

-- Network Strings
util.AddNetworkString("CoDHUD_HitNotification")

-- ==========================================
-- CONFIGURATION: REWARDS
-- ==========================================
local XP_PER_KILL = 100
local XP_PER_HIT  = 10  -- Optional: small XP for just hitting
-- ==========================================

hook.Add( "CoDHUD_OnDamage", "CoDHUD_OnDamage_HitMarker", function(target, attacker, isKill, dmginfo)
    net.Start( "CoDHUD_HitNotification" )
        net.WriteBool( isKill )
        net.WriteInt( isKill and XP_PER_KILL or XP_PER_HIT, 32 )
    net.Send( attacker )
end )