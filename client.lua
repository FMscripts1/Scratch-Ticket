local display = false

RegisterNetEvent('scratch-ticket:client:sendNuiMessageTicket')
AddEventHandler('scratch-ticket:client:sendNuiMessageTicket', function(name)
    display = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "ui",
        scriptName = GetCurrentResourceName(),
        ticket = config.tickets[name]
    })
end)

CreateThread(function()
    if config.framework == "QBCore" then
        earnReward = function(money)TriggerServerEvent('scratch-ticket:server:earn-money', "QBCore", money)end
        TriggerServerEvent('scratch-ticket:server:createItems:qbcore')
    elseif config.framework == "ESX" then
        earnReward = function(money)TriggerServerEvent('scratch-ticket:server:earn-money', "ESX", money)end
        TriggerServerEvent('scratch-ticket:server:createItems:esx')
    else -- if is standalone
        RegisterCommand(config.command.name, function(__, args, __)
            local ticketsList = ""
            for k,v in pairs(config.tickets) do
                if args[1] == "list" then ticketsList = ticketsList..k.." , "
                elseif args[1] == k and buyTicket(k) then TriggerEvent('scratch-ticket:client:sendNuiMessageTicket', k) return 
                elseif args[1] == k and not buyTicket(k) then TriggerEvent('chat:addMessage', { color={255,0,0,255}, multiline = false, args = { config.command.noMoney } }) return end
            end
            if ticketsList == "" then TriggerEvent('chat:addMessage', { color={255,0,0,255}, multiline = false, args = { config.command.errorTicketName } }) else TriggerEvent('chat:addMessage', { color={255,255,0,255}, multiline = false, args = { "LIST", ticketsList } })end
        end, config.command.restriction)
        TriggerEvent('chat:addSuggestion', "/"..tostring(config.command.name), config.command.helpText, {{ name="parm1", help=config.command.parmDescription }})
    end
end)



RegisterNUICallback("js:givereward", function(data, callBack)
    display = false
    SetNuiFocus(false, false)
    earnReward(data.money)
end)
