local QBCore = exports['qb-core']:GetCoreObject()

-- Admin command to give vehicle tickets
QBCore.Commands.Add('giveticket', 'Give vehicle ticket to a player (Admin Only)', {
    {name = 'id', help = 'Player ID'},
    {name = 'amount', help = 'Amount of tickets (default: 1)'}
}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check if player is admin
    if not QBCore.Functions.HasPermission(src, 'admin') then
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have permission!', 'error')
        return
    end
    
    local targetId = tonumber(args[1])
    local amount = tonumber(args[2]) or 1
    
    if not targetId then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid player ID', 'error')
        return
    end
    
    local Target = QBCore.Functions.GetPlayer(targetId)
    
    if not Target then
        TriggerClientEvent('QBCore:Notify', src, 'Player not found', 'error')
        return
    end
    
    -- Give ticket
    local success = exports.ox_inventory:AddItem(targetId, Config.TicketItem, amount)
    
    if success then
        TriggerClientEvent('QBCore:Notify', src, string.format('Gave %dx %s to %s', amount, Config.TicketItem, Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname), 'success')
        TriggerClientEvent('QBCore:Notify', targetId, string.format('You received %dx vehicle ticket(s)!', amount), 'success')
        
        print(string.format('[Vehicle Prize] %s gave %dx tickets to %s (%s)', 
            Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            amount,
            Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname,
            Target.PlayerData.citizenid
        ))
    else
        TriggerClientEvent('QBCore:Notify', src, 'Failed to give ticket', 'error')
    end
end, 'admin')

-- Command to check vehicle prize statistics (Admin)
QBCore.Commands.Add('prizesstats', 'View vehicle prize statistics', {}, false, function(source, args)
    local src = source
    
    if not QBCore.Functions.HasPermission(src, 'admin') then
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have permission!', 'error')
        return
    end
    
    -- Calculate total weight
    local totalWeight = 0
    local stats = {}
    
    for _, vehicle in pairs(Config.Vehicles) do
        totalWeight = totalWeight + vehicle.weight
    end
    
    -- Calculate percentages
    for _, vehicle in pairs(Config.Vehicles) do
        local chance = (vehicle.weight / totalWeight) * 100
        table.insert(stats, {
            label = vehicle.label,
            tier = vehicle.tier,
            chance = string.format("%.2f%%", chance)
        })
    end
    
    -- Sort by chance (highest first)
    table.sort(stats, function(a, b)
        return tonumber(a.chance:match("([%d.]+)")) > tonumber(b.chance:match("([%d.]+)"))
    end)
    
    -- Print to console
    print("========== VEHICLE PRIZE STATISTICS ==========")
    print(string.format("Total Vehicles: %d", #Config.Vehicles))
    print(string.format("Total Weight: %d", totalWeight))
    print("----------------------------------------------")
    
    for _, stat in ipairs(stats) do
        print(string.format("[%s] %s - %s", stat.tier:upper(), stat.label, stat.chance))
    end
    
    print("==============================================")
    
    TriggerClientEvent('QBCore:Notify', src, 'Statistics printed to server console', 'info')
end, 'admin')

-- Self-service command for players to check if they have tickets
QBCore.Commands.Add('checktickets', 'Check how many vehicle tickets you have', {}, false, function(source, args)
    local src = source
    local ticketCount = exports.ox_inventory:Search(src, 'count', Config.TicketItem)
    
    if ticketCount and ticketCount > 0 then
        TriggerClientEvent('QBCore:Notify', src, string.format('You have %d vehicle ticket(s)', ticketCount), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have any vehicle tickets', 'error')
    end
end)

if Config.Debug then
    print('[Vehicle Prize] Commands loaded successfully')
end