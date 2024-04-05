--[[ ===================================================== ]] --
--[[             MH Restarter Script by MaDHouSe           ]] --
--[[ ===================================================== ]] --
Locales = {}
Config = {}
Config.Locale = "en"

Config.RestartCommand = "restart-server"

Config.Settings = {
    Weather = {
        Enable = true,
        Type = "THUNDER",
        Timer = math.random(30000, 60000)
    },
    Time = {
        Enable = false,
        Hour = 00,
        Min = 00
    },
    Sound = {
        Enable = true,
        File = 'Alert.ogg',
        Volume = 5.0
    },
    Falldown = {
        Enable = true,
        Timer = math.random(15000, 30000)
    },
    Zombies = {
        Enable = true,
        UseBlood = true,
        UseDamage = false
    }
}

function CreateString(str, ...)
    if Locales[Config.Locale] ~= nil then
        if Locales[Config.Locale][str] ~= nil then
            return string.format(Locales[Config.Locale][str], ...)
        else
            return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
        end
    else
        return 'Locale [' .. Config.Locale .. '] does not exist'
    end
end

-- Translate string first char uppercase
function String(str, ...)
    return tostring(CreateString(str, ...):gsub("^%l", string.upper))
end
