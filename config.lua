--[[ ===================================================== ]] --
--[[             MH Restarter Script by MaDHouSe           ]] --
--[[ ===================================================== ]] --
Locales = {}
Config = {}
Config.Locale = "en"

Config.ServerName = "RP Server"

Config.Settings = {
    Weather = {
        Enable = true,
        Type = "THUNDER",
        Timer = math.random(30000, 60000)
    },
    Time = {
        Enable = false,
        Hour = 00,
        Min = 00,
    },
    Sound = {
        Enable = true,
        File = 'Alert.ogg',
        Volume = 5.0,
    },
    Falldown = {
        Enable = true,
        Timer = math.random(15000, 30000),
    },
    Zombies = {
        Enable = true,
        UseBlood = true,
        UseDamage = false,
    },
}