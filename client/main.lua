local QBCore = exports['qb-core']:GetCoreObject()
local isSpinning = false

-- Start the spinning animation
RegisterNetEvent('vehicleprize:client:startSpin', function(vehicles, wonVehicle)
    if isSpinning then return end
    
    isSpinning = true
    
    -- Show notification
    QBCore.Functions.Notify(Config.Notifications.rolling, 'info')
    
    -- Open NUI
    SetNuiFocus(false, false) -- No mouse control needed, just display
    SendNUIMessage({
        action = 'openSpin',
        vehicles = vehicles,
        wonVehicle = wonVehicle,
        spinDuration = Config.SpinDuration,
        tierColors = Config.TierColors
    })
    
    -- Auto-close after animation completes
    Wait(Config.SpinDuration + 2000) -- Extra time for celebration
    SendNUIMessage({
        action = 'closeSpin'
    })
    
    isSpinning = false
end)

-- NUI Callbacks (if needed for manual close)
RegisterNUICallback('closeSpin', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

if Config.Debug then
    print('[Vehicle Prize] Client main script loaded')
end