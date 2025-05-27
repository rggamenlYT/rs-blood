Config = {}

Config.BloodTypes = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"}

Config.Debug = true -- true = test on yourself, false = on nearest player

Config.HPLoss = 5 -- HP loss on blood sampling (0-100)
Config.FallChance = 10 -- % chance of falling (0-100)
Config.DrunkChance = 25 -- % chance of getting dizzy (0-100)
Config.ProgressBarTime = 7 -- seconds progress bar
Config.DrunkTime = 5 -- seconds drunk effect

Config.Discord = {
    Webhook = "",
    Logo = "https://link.to/logo.png",
    Name = "Medisch Log",
    Text = "Bloedafname Log"
}

Config.RequiredItems = {
    Needle = "needle",
    BloodBag = "empty_blood_bag"
}

Config.UseNeedleItem = true