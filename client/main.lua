--[[ ===================================================== ]] --
--[[             MH Restarter Script by MaDHouSe           ]] --
--[[ ===================================================== ]] --
local setWeather = false
local restartEnable = false
local zombiesEnable = false
local isShooting = false
local isRunning  = false

--- Reset
local function Reset()
    setWeather = false
    restartEnable = false
    zombiesEnable = false
    isShooting = false
    isRunning  = false
end

--- Set Weather
local function SetWeather()
    if Config.Settings.Weather.Enable then
        Wait(Config.Settings.Weather.Timer)
        setWeather = true
        TriggerServerEvent('qb-weathersync:server:setWeather', Config.Settings.Weather.Type)
    end
    if Config.Settings.Time.Enable then
        TriggerServerEvent('qb-weathersync:server:setTime', Config.Settings.Time.Hour, Config.Settings.Time.Min)
        TriggerServerEvent('qb-weathersync:server:toggleFreezeTime', true)
    end
end

--- Fall Down
local function FallDown()
    if Config.Settings.Falldown.Enable then
        Wait(Config.Settings.Falldown.Timer)
        RestorePlayerStamina(PlayerId(), 1.0)
        if not IsPedRagdoll(PlayerPedId()) and IsPedOnFoot(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) then
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
            SetPedToRagdollWithFall(PlayerPedId(), 0, 0, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    end
end

-- Reset Relationship Between Groups
local function ResetRelationshipBetweenGroups()
    SetRelationshipBetweenGroups(1, 'ZOMBIE', 'PLAYER')
    SetRelationshipBetweenGroups(1, 'PLAYER', 'ZOMBIE')
end

--- Set Zombies Relationship
local function SetZombiesRelationship()
    DecorRegister('RegisterZombie', 2)
    AddRelationshipGroup('ZOMBIE')
    SetRelationshipBetweenGroups(0, GetHashKey('ZOMBIE'), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GetHashKey('ZOMBIE'))
end

--- Set All Peds Bloody
local function SetAllPedsBloody()
    if Config.Settings.Zombies.UseBlood then
        local peds= GetGamePool('CPed')
        for i = 1, #peds, 1 do
            local ped = peds[i]
            if DoesEntityExist(ped) and ped ~= PlayerPedId() then
                ApplyPedDamagePack(ped, "TD_SHOTGUN_FRONT_KILL", 0, 10)
                ApplyPedDamagePack(ped, "BigRunOverByVehicle ", 0, 10)
                ApplyPedDamagePack(ped, "Dirt_Mud", 0, 10)
                ApplyPedDamagePack(ped, "Explosion_Large", 0, 10)
                ApplyPedDamagePack(ped, "RunOverByVehicle", 0, 10)
                ApplyPedDamagePack(ped, "Splashback_Face_0", 0, 10)
                ApplyPedDamagePack(ped, "Splashback_Face_1", 0, 10)
                ApplyPedDamagePack(ped, "SCR_Shark", 0, 10)
                ApplyPedDamagePack(ped, "SCR_Cougar", 0, 10)
                ApplyPedDamagePack(ped, "Car_Crash_Heavy", 0, 10)
                ApplyPedDamagePack(ped, "TD_SHOTGUN_REAR_KILL", 0, 10)
                ApplyPedDamagePack(ped, "SCR_Torture", 0, 10)
                ApplyPedDamagePack(ped, "TD_melee_face_l", 0, 10)
                ApplyPedDamagePack(ped, "MTD_melee_face_r", 0, 10)
                ApplyPedDamagePack(ped, "MTD_melee_face_jaw", 0, 10)
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    Reset()
end)

AddEventHandler('onResourceStart', function(resource)
    Reset()
end)

RegisterNetEvent('mh-restarter:client:send', function(count, restartBy)
    if not restartEnable then
        restartEnable = true
        SendNUIMessage({open = true, secs = count + 1, message = String('restartMessage'), restartBy = restartBy})
        if Config.Settings.Sound.Enable then SendNUIMessage({type = 'play', file = Config.Settings.Sound.File, volume = Config.Settings.Sound.Volume}) end
    else
        if Config.Settings.Sound.Enable then SendNUIMessage({type = 'play', file = Config.Settings.Sound.File, volume = Config.Settings.Sound.Volume}) end
    end
    if not setWeather then SetWeather() end
end)

RegisterNetEvent("mh-restarter:client:enableZombies", function(source)
    if Config.Settings.Zombies.Enable then
        if not zombiesEnable then
            zombiesEnable = true
            SetZombiesRelationship()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if restartEnable then FallDown() end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Settings.Zombies.Enable and zombiesEnable then
            -- Peds
            SetPedDensityMultiplierThisFrame(1.0)
            SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)
            -- Vehicles
            SetRandomVehicleDensityMultiplierThisFrame(1.0)
            SetParkedVehicleDensityMultiplierThisFrame(1.0)
            SetVehicleDensityMultiplierThisFrame(1.0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Settings.Zombies.Enable and zombiesEnable then
            if IsPedShooting(PlayerPedId()) then
                isShooting = true
                Citizen.Wait(5000)
                isShooting = false
            end
            if IsPedSprinting(PlayerPedId()) or IsPedRunning(PlayerPedId()) then
                if isRunning == false then
                    isRunning = true
                end
            else
                if isRunning == true then
                    isRunning = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Config.Settings.Zombies.Enable and zombiesEnable then
            SetAllPedsBloody()
            local Zombie = -1
            local Success = false
            local Handler, Zombie = FindFirstPed()
            repeat
                Citizen.Wait(50) 
                if IsPedHuman(Zombie) and not IsPedAPlayer(Zombie) and not IsPedDeadOrDying(Zombie, true) then
                    if not DecorExistOn(Zombie, 'RegisterZombie') then
                        ClearPedTasks(Zombie)
                        ClearPedSecondaryTask(Zombie)
                        ClearPedTasksImmediately(Zombie)
                        TaskWanderStandard(Zombie, 10.0, 10)
                        SetPedRelationshipGroupHash(Zombie, 'ZOMBIE')
                        ApplyPedDamagePack(Zombie, 'BigHitByVehicle', 0.0, 1.0)
                        SetEntityHealth(Zombie, 200)
                        RequestAnimSet('move_m@drunk@verydrunk')
                        while not HasAnimSetLoaded('move_m@drunk@verydrunk') do
                            Wait(0)
                        end
                        SetPedMovementClipset(Zombie, 'move_m@drunk@verydrunk', 1.0)
                        SetPedConfigFlag(Zombie, 100, false)
                        DecorSetBool(Zombie, 'RegisterZombie', true)
                    end
                    SetPedRagdollBlockingFlags(Zombie, 1)
                    SetPedCanRagdollFromPlayerImpact(Zombie, false)
                    SetPedSuffersCriticalHits(Zombie, true)
                    SetPedEnableWeaponBlocking(Zombie, true)
                    DisablePedPainAudio(Zombie, true)
                    StopPedSpeaking(Zombie, true)
                    SetPedDiesWhenInjured(Zombie, false)
                    StopPedRingtone(Zombie)
                    SetPedMute(Zombie)
                    SetPedIsDrunk(Zombie, true)
                    SetPedConfigFlag(Zombie, 166, false)
                    SetPedConfigFlag(Zombie, 170, false)
                    SetBlockingOfNonTemporaryEvents(Zombie, true)
                    SetPedCanEvasiveDive(Zombie, false)
                    RemoveAllPedWeapons(Zombie, true)
                    local PlayerCoords = GetEntityCoords(PlayerPedId())
                    local PedCoords = GetEntityCoords(Zombie)
                    local Distance = #(PedCoords - PlayerCoords)
                    local DistanceTarget
                    if isShooting then
                        DistanceTarget = 250.0
                    elseif isRunning then
                        DistanceTarget = 150.0
                    else
                        DistanceTarget = 50.0
                    end
                    if Distance <= DistanceTarget and not IsPedInAnyVehicle(PlayerPedId(), false) then
                        TaskGoToEntity(Zombie, PlayerPedId(), -1, 0.0, 2.0, 1073741824, 0)
                    end
                    if Distance <= 1.3 then
                        if not IsPedRagdoll(Zombie) and not IsPedGettingUp(Zombie) then
                            local health = GetEntityHealth(PlayerPedId())
                            if health <= 0 then health = 0 end
                            if health == 0 then
                                ClearPedTasks(Zombie)
                                TaskWanderStandard(Zombie, 10.0, 10)
                            else
                                RequestAnimSet('melee@unarmed@streamed_core_fps')
                                while not HasAnimSetLoaded('melee@unarmed@streamed_core_fps') do
                                    Wait(10)
                                end
                                TaskPlayAnim(Zombie, 'melee@unarmed@streamed_core_fps', 'ground_attack_0_psycho', 8.0, 1.0, -1, 48, 0.001, false, false, false)
                                if Config.Settings.Zombies.UseDamage then
                                    ApplyDamageToPed(PlayerPedId(), 5, false)
                                end
                            end
                        end
                    end
                    if not NetworkGetEntityIsNetworked(Zombie) then
                        DeleteEntity(Zombie)
                    end
                end
                Success, Zombie = FindNextPed(Handler)
            until not (Success)
            EndFindPed(Handler)
        end
    end
end)
