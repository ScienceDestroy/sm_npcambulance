local QBCore = exports['qb-core']:GetCoreObject()
local medicSpawned = false
local medicPed = nil
local lastCallTime = 0

-- Функция для вызова медика
function CallMedic()
    local currentTime = GetGameTimer()

    -- Проверка отката
    if currentTime - lastCallTime < Config.CooldownTime * 1000 then
        QBCore.Functions.Notify("Вы не можете вызвать медика так быстро. Подождите " .. Config.CooldownTime .. " секунд.", "error")
        return
    end

    -- Проверка количества медиков онлайн
    QBCore.Functions.TriggerCallback('qb-medicnpc:checkMedics', function(canCallNPC)
        if not canCallNPC then
            QBCore.Functions.Notify("На сервере достаточно медиков. Вызовите живого медика!", "error")
            return
        end

        -- Проверка баланса через серверный callback
        QBCore.Functions.TriggerCallback('qb-medicnpc:checkBalance', function(hasEnoughMoney)
            if not hasEnoughMoney then
                QBCore.Functions.Notify("У вас недостаточно денег на счету.", "error")
                return
            end

            -- Получаем координаты игрока
            local playerCoords = GetEntityCoords(PlayerPedId())

            -- Вычисляем точку спавна медика неподалеку
            local spawnCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, Config.SpawnDistance, 0.0)

            -- Загружаем модель медика
            RequestModel(Config.MedicModel)
            while not HasModelLoaded(Config.MedicModel) do
                Wait(1)
            end

            -- Спавним медика
            medicPed = CreatePed(4, Config.MedicModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true)
            TaskGoToEntity(medicPed, PlayerPedId(), -1, 1.0, 10.0, 1073741824, 0)
            medicSpawned = true

            QBCore.Functions.Notify("Медик вызван и направляется к вам.", "success")

            -- Таймер для проверки, смог ли медик добраться до игрока
            local timeout = GetGameTimer() + 30000 -- 30 секунд на попытку добраться
            local hasReachedPlayer = false

            while GetGameTimer() < timeout do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(medicPed), GetEntityCoords(PlayerPedId()), true)
                if distance <= 2.0 then
                    hasReachedPlayer = true
                    break
                end
                Wait(100)
            end

            -- Если медик не смог добраться, воскрешаем игрока автоматически
            if not hasReachedPlayer then
                QBCore.Functions.Notify("Медик не смог добраться до вас. Вы будете воскрешены автоматически.", "primary")
            end

            -- Анимация медика
            RequestAnimDict(Config.MedicHealAnim.dict)
            while not HasAnimDictLoaded(Config.MedicHealAnim.dict) do
                Wait(1)
            end
            TaskPlayAnim(medicPed, Config.MedicHealAnim.dict, Config.MedicHealAnim.name, 8.0, -8.0, -1, 1, 0, false, false, false)

            -- Анимация игрока
            RequestAnimDict(Config.PlayerReviveAnim.dict)
            while not HasAnimDictLoaded(Config.PlayerReviveAnim.dict) do
                Wait(1)
            end
            TaskPlayAnim(PlayerPedId(), Config.PlayerReviveAnim.dict, Config.PlayerReviveAnim.name, 8.0, -8.0, -1, 1, 0, false, false, false)

            -- Воскрешение игрока
            Wait(5000) -- Имитация времени на воскрешение
            TriggerServerEvent('qb-medicnpc:revivePlayer')
            medicSpawned = false
            DeleteEntity(medicPed)

            -- Установка времени последнего вызова
            lastCallTime = GetGameTimer()
        end)
    end)
end

-- Команда для вызова медика
RegisterCommand("callmedic", function()
    CallMedic()
end, false)