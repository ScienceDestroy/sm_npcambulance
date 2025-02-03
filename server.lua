local QBCore = exports['qb-core']:GetCoreObject()

-- Функция для отправки логов в Discord
function SendDiscordLog(playerName, action, details)
    local embed = {
        {
            ["title"] = Config.DiscordWebhookName,
            ["color"] = Config.DiscordWebhookColor,
            ["fields"] = {
                {
                    ["name"] = "Игрок",
                    ["value"] = playerName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Действие",
                    ["value"] = action,
                    ["inline"] = true
                },
                {
                    ["name"] = "Детали",
                    ["value"] = details,
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end

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

        -- Логирование вызова медика
        SendDiscordLog(player.PlayerData.name, "Вызов медика", "Игрок вызвал медика. Стоимость: $" .. Config.MedicCost)
        cb(true)
    else
        cb(false)
    end
end)

-- Событие для воскрешения игрока
RegisterServerEvent('qb-medicnpc:revivePlayer')
AddEventHandler('qb-medicnpc:revivePlayer', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if player then
        player.Functions.SetMetaData("inlaststand", false)
        TriggerClientEvent('hospital:client:Revive', src)

        -- Логирование воскрешения
        SendDiscordLog(player.PlayerData.name, "Воскрешение", "Игрок был воскрешен медиком.")
    end
end)