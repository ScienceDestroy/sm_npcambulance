local QBCore = exports['qb-core']:GetCoreObject()

-- Регистрация callback для проверки баланса
QBCore.Functions.CreateCallback('qb-medicnpc:checkBalance', function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then
        cb(false) -- Если игрок не найден, возвращаем false
        return
    end

    local bankBalance = player.PlayerData.money["bank"]
    if bankBalance >= Config.MedicCost then
        player.Functions.RemoveMoney("bank", Config.MedicCost, "Medic Call")
        TriggerClientEvent('QBCore:Notify', src, "С вашего счета списано $" .. Config.MedicCost .. " за вызов медика.", "success")
        cb(true)
    else
        cb(false)
    end
end)

-- Событие для воскрешения игрока
RegisterServerEvent('qb-medicnpc:revivePlayer')
AddEventHandler('qb-medicnpc:revivePlayer', function()
    local src = source
    QBCore.Functions.GetPlayer(src).Functions.SetMetaData("inlaststand", false)
    TriggerClientEvent('hospital:client:Revive', src)
end)