RegisterNetEvent('scratch-ticket:server:earn-money')
RegisterNetEvent('scratch-ticket:server:createItems:qbcore')
RegisterNetEvent('scratch-ticket:server:createItems:esx')

AddEventHandler('scratch-ticket:server:earn-money', function(framework, money)
    if framework == "QBCore" then
        local QBCore = exports['qb-core']:GetCoreObject()
        local bool = QBCore.Functions.GetPlayer(source).Functions.AddMoney('cash', money, "banking-quick-withdraw")
    elseif framework == "ESX" then
        local ESX = exports["es_extended"]:getSharedObject()
        ESX.GetPlayerFromId(source).addMoney(money)
    end
end)

AddEventHandler('scratch-ticket:server:createItems:qbcore', function()
    local QBCore = exports['qb-core']:GetCoreObject()
    for k,v in pairs(config.tickets) do
        QBCore.Functions.AddItem(k, {
            name = k,
            label = k,
            weight = 200,
            type = 'item',
            image = v.image,
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Scratch Ticket'
        })

        QBCore.Functions.CreateUseableItem(k, function(source, item)
            local Player = QBCore.Functions.GetPlayer(source)
            if not Player.Functions.GetItemByName(item.name) then return end
            Player.Functions.RemoveItem(item.name, 1)
            TriggerClientEvent('scratch-ticket:client:sendNuiMessageTicket', source, item.name)
        end)
    end
end)

AddEventHandler('scratch-ticket:server:createItems:esx', function()
    local ESX = exports["es_extended"]:getSharedObject()
    for k,v in pairs(config.tickets) do
        ESX.RegisterUsableItem(k, function(playerId)
            local xPlayer = ESX.GetPlayerFromId(playerId)
            xPlayer.removeInventoryItem(k, 1)
            TriggerClientEvent('scratch-ticket:client:sendNuiMessageTicket', playerId, k)
        end)
    end
end)
