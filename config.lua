Config = {}

-- Стоимость вызова медика
Config.MedicCost = 1000

-- Время отката (в секундах) перед повторным вызовом
Config.CooldownTime = 300

-- Модель медика
Config.MedicModel = `s_m_m_paramedic_01`

-- Расстояние для спавна медика (в метрах)
Config.SpawnDistance = 20.0

-- Время ожидания медика (в миллисекундах)
Config.MedicTimeout = 30000 -- 30 секунд

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