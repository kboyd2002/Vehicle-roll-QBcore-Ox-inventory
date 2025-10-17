local QBCore = exports['qb-core']:GetCoreObject()
local prizePed = nil
local pedSpawned = false

-- Spawn the prize ped
local function SpawnPrizePed()
    if pedSpawned then return end
    
    local pedModel = Config.PedLocation.model
    
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(10)
    end
    
    prizePed = CreatePed(4, pedModel, Config.PedLocation.coords.x, Config.PedLocation.coords.y, Config.PedLocation.coords.z - 1.0, Config.PedLocation.coords.w, false, true)
    
    SetEntityHeading(prizePed, Config.PedLocation.coords.w)
    FreezeEntityPosition(prizePed, true)
    SetEntityInvincible(prizePed, true)
    SetBlockingOfNonTemporaryEvents(prizePed, true)
    
    if Config.PedLocation.scenario then
        TaskStartScenarioInPlace(prizePed, Config.PedLocation.scenario, 0, true)
    end
    
    pedSpawned = true
    
    -- Setup qb-target
    if Config.UseTarget == 'qb-target' then
        exports['qb-target']:AddTargetEntity(prizePed, {
            options = {
                {
                    type = "client",
                    event = "vehicleprize:client:checkTicket",
                    icon = Config.TargetIcon,
                    label = Config.TargetLabel,
                    canInteract = function()
                        -- This gets checked every frame, so we use a callback for performance
                        return true
                    end
                }
            },
            distance = Config.TargetDistance
        })
    elseif Config.UseTarget == 'ox_target' then
        exports.ox_target:addLocalEntity(prizePed, {
            {
                name = 'vehicle_prize_ped',
                icon = Config.TargetIcon,
                label = Config.TargetLabel,
                onSelect = function()
                    TriggerEvent('vehicleprize:client:checkTicket')
                end,
                distance = Config.TargetDistance
            }
        })
    end
    
    if Config.Debug then
        print('[Vehicle Prize] Ped spawned at: ' .. Config.PedLocation.coords)
    end
end

-- Delete the ped
local function DeletePrizePed()
    if DoesEntityExist(prizePed) then
        DeleteEntity(prizePed)
    end
    prizePed = nil
    pedSpawned = false
end

-- Check if player has ticket before rolling
RegisterNetEvent('vehicleprize:client:checkTicket', function()
    QBCore.Functions.TriggerCallback('vehicleprize:server:hasTicket', function(hasTicket)
        if hasTicket then
            -- Player has ticket, start the roll
            TriggerServerEvent('vehicleprize:server:rollVehicle')
        else
            QBCore.Functions.Notify(Config.Notifications.noTicket, 'error')
        end
    end)
end)

-- Spawn ped on resource start
CreateThread(function()
    Wait(1000) -- Wait for game to load
    SpawnPrizePed()
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeletePrizePed()
    end
end)

if Config.Debug then
    print('[Vehicle Prize] Client ped script loaded')
end