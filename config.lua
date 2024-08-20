config = {}
config.framework = "standalone" -- QBCore, ESX,  standalone
config.command = {} -- If your choice is standalone
config.command.name = "getTicket"
config.command.restriction = false
config.command.helpText = "buy a ticket"
config.command.parmDescription = "ticket name ( /getTicket list )"
config.command.errorTicketName = "this name doesn't exist"
config.command.noMoney = "You don't have enough money"
config.tickets = {
    ['jackpot'] = {
        image = "jackpot.jpg",
        price = 15,
        reward = {min=150, max=1000, exceptedValues={190,200}}
    },
    ['lottery'] = {
        image = "lottery.webp",
        price = 5,
        reward = {min=5, max=10, exceptedValues={6,7}}
    },
    --['exemple'] = {
    --    image = "exemple.png",
    --    price = 0,--only standalone
    --    reward = {min=0,max=1000,exeptedValues={500,890,12,900}}
    --}
}
-------CUSTOM FUNCTIONS------- 
-- [ONLY FOR STANDALONE]
function buyTicket(name) -- add your own buy function with config.tickets[name].price
    --local hasPaid = removePedMoney(PlayerPedId(), config.tickets[name].price)
    local hasPaid = true
    return hasPaid
end
-- [FOR ALL FRAMEWORKS]
function earnReward(money) -- HERE add your own system. Only standalone
    --addPedMoney(PlayerPedId(), money)
end
