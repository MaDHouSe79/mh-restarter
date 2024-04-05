--[[ ===================================================== ]] --
--[[             MH Restarter Script by MaDHouSe           ]] --
--[[ ===================================================== ]] --
local startDropping = false
local restartByTxAdmin = false
local restartByAdmin = false
local restartBy = ""
local timer = 0

local function HowIsRestarting()
    if restartByTxAdmin then
        restartBy = String('restartByTxAdmin')
    elseif restartByAdmin then
        restartBy = String('restartByAdmin')
    end
end

local function DropAllPlayers()
    startDropping = true
    local list = GetPlayers()
    for k, v in pairs(list) do
        DropPlayer(k, String('dropMessage'))
    end
end

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    print('Scheduled Restart in ' .. eventData.secondsRemaining .. ' secs')
    if eventData.secondsRemaining >= 1 then
        local run = false
        if eventData.secondsRemaining == 900 then
            run = true
        elseif eventData.secondsRemaining == 600 then
            run = true
        elseif eventData.secondsRemaining == 300 then
            run = true
        elseif eventData.secondsRemaining == 60 then
            run = true
        end
        if run then
            restartByTxAdmin = true
            HowIsRestarting()
            timer = eventData.secondsRemaining
            TriggerClientEvent('mh-restarter:client:send', -1, timer, restartBy)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        if timer > 0 then timer = timer - 1 end
        if timer >= 60 and timer <= 300 then TriggerClientEvent('mh-restarter:client:enableZombies', -1) end
        if timer > 0 and timer < 3 and not startDropping then DropAllPlayers() end
        Citizen.Wait(1000)
    end
end)

RegisterCommand(Config.RestartCommand, function(source, args, rawCommand)
    restartByAdmin = true
    HowIsRestarting()
    timer = tonumber(args[1])
    TriggerClientEvent('mh-restarter:client:send', -1, timer, restartBy)
end, true)
