--[[ ===================================================== ]] --
--[[             MH Restarter Script by MaDHouSe           ]] --
--[[ ===================================================== ]] --
local startDropping = false
local timer = 0

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
        timer = eventData.secondsRemaining
        TriggerClientEvent('mh-restarter:client:send', -1, timer)
        TriggerClientEvent('mh-restarter:client:enableZombies', -1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if timer > 0 then timer = timer - 1 end
        if timer > 0 and timer < 3 and not startDropping then DropAllPlayers() end
        Citizen.Wait(1000)
    end
end)
