local QBCore = exports['qb-core']:GetCoreObject()
local activeRolls = {} -- Prevent spam/exploits

-- Utility: Debug print
local function DebugPrint(msg)
    if Config.Debug then
        print('[Vehicle Prize System] ' .. msg)
    end
end

-- Utility: Generate random plate
local function GeneratePlate()
    local plate = ''
    for i = 1, 8 do
        if math.random(1, 2) == 1 then
            plate = plate .. string.char(math.random(65, 90)) -- A-Z
        else
            plate = plate .. math.random(0, 9) -- 0-9
        end
    end
    return plate:sub(1, 8)
end

-- Utility: Check if plate exists
local function PlateExists(plate)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    return result ~= nil
end

-- Utility: Generate unique plate
local function GenerateUniquePlate()
    local plate = GeneratePlate()
    while PlateExists(plate) do
        plate = GeneratePlate()
    end
    return plate
end

-- Weighted random selection
local function GetRandomVehicle()
    local totalWeight = 0
    
    -- Calculate total weight
    for _, vehicle in pairs(Config.Vehicles) do
        totalWeight = totalWeight + vehicle.weight
    end
    
    -- Generate random number
    local random = math.random(1, totalWeight)
    local currentWeight = 0
    
    -- Select vehicle based on weight
    for _, vehicle in pairs(Config.Vehicles) do
        currentWeight = currentWeight + vehicle.weight
        if random <= currentWeight then
            return vehicle
        end
    end
    
    -- Fallback (should never reach here)
    return Config.Vehicles[1]
end

-- Main roll event
RegisterNetEvent('vehicleprize:server:rollVehicle', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        DebugPrint('Player not found for source: ' .. src)
        return
    end
    
    -- Prevent spam/exploits
    if activeRolls[src] then
        TriggerClientEvent('QBCore:Notify', src, 'You are already rolling!', 'error')
        return
    end
    
    activeRolls[src] = true
    
    -- Check if player has ticket
    local hasTicket = exports.ox_inventory:Search(src, 'count', Config.TicketItem)
    
    if not hasTicket or hasTicket < 1 then
        DebugPrint('Player ' .. Player.PlayerData.citizenid .. ' tried to roll without ticket')
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.noTicket, 'error')
        activeRolls[src] = nil
        return
    end
    
    -- Remove ticket
    local ticketRemoved = exports.ox_inventory:RemoveItem(src, Config.TicketItem, 1)
    
    if not ticketRemoved then
        DebugPrint('Failed to remove ticket from player ' .. Player.PlayerData.citizenid)
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.error, 'error')
        activeRolls[src] = nil
        return
    end
    
    -- Roll for vehicle
    local wonVehicle = GetRandomVehicle()
    DebugPrint('Player ' .. Player.PlayerData.citizenid .. ' won: ' .. wonVehicle.label)
    
    -- Send vehicle list and winner to client for animation
    TriggerClientEvent('vehicleprize:client:startSpin', src, Config.Vehicles, wonVehicle)
    
    -- Wait for animation to complete
    Wait(Config.SpinDuration + 1000)
    
    -- Generate unique plate
    local plate = GenerateUniquePlate()
    
    -- Insert vehicle into database
    local success = pcall(function()
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            wonVehicle.model,
            GetHashKey(wonVehicle.model),
            '{}',
            plate,
            'pillboxgarage', -- Default garage, change as needed
            0 -- 0 = in garage, 1 = out
        })
    end)
    
    if success then
        DebugPrint('Vehicle added to database for player ' .. Player.PlayerData.citizenid)
        TriggerClientEvent('QBCore:Notify', src, string.format(Config.Notifications.won, wonVehicle.label), 'success')
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.vehicleInGarage, 'info')
        
        -- Log to console/webhook (optional)
        print(string.format('[Vehicle Prize] %s (%s) won %s (Plate: %s)', 
            Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            Player.PlayerData.citizenid,
            wonVehicle.label,
            plate
        ))
    else
        DebugPrint('Failed to insert vehicle into database')
        TriggerClientEvent('QBCore:Notify', src, Config.Notifications.error, 'error')
        
        -- Refund ticket on failure
        exports.ox_inventory:AddItem(src, Config.TicketItem, 1)
    end
    
    activeRolls[src] = nil
end)

-- Verify player has ticket (for target visibility)
QBCore.Functions.CreateCallback('vehicleprize:server:hasTicket', function(source, cb)
    local hasTicket = exports.ox_inventory:Search(source, 'count', Config.TicketItem)
    cb(hasTicket and hasTicket >= 1)
end)

DebugPrint('Server script loaded successfully')