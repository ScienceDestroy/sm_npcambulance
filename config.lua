Config = {}

-- Стоимость вызова медика
Config.MedicCost = 200

-- Время отката (в секундах) перед повторным вызовом
Config.CooldownTime = 300

-- Модель медика
Config.MedicModel = `s_m_m_paramedic_01`

-- Расстояние для спавна медика (в метрах)
Config.SpawnDistance = 20.0

-- Время ожидания медика (в миллисекундах)
Config.MedicTimeout = 10000 -- 15 секунд

-- Максимальное количество медиков онлайн, при котором NPC будет недоступен
Config.MaxMedicsForNPC = 2

-- Анимация медика при воскрешении
Config.MedicHealAnim = {
    dict = "mini@cpr@char_a@cpr_str",
    name = "cpr_pumpchest"
}

-- Анимация игрока при воскрешении
Config.PlayerReviveAnim = {
    dict = "mini@cpr@char_a@cpr_str",
    name = "cpr_success"
}

-- Discord Webhook
Config.DiscordWebhook = "https://discord.com/api/webhooks/1336108432578707456/QsZAm-k9qYeh03JEs6ZVZ5CHGxvDezieU6X_M0Ijzd_WT4ttGwm7TutrJD9isxRNiE5E"
Config.DiscordWebhookName = "NPC MEDIC"
Config.DiscordWebhookColor = 16711680 -- Красный цвет (в формате HEX)