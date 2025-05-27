local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('rs-blood:server:CheckItems', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then
        cb(false)
        return
    end
    local hasNeedle = Player.Functions.GetItemByName(Config.RequiredItems.Needle)
    local hasBag = Player.Functions.GetItemByName(Config.RequiredItems.BloodBag)
    cb(hasNeedle ~= nil and hasBag ~= nil)
end)

function GetPlayerSteamName(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, string.len("steam:")) == "steam:" then
            return id
        end
    end
    return "unknown"
end

function GenerateRandomBloodType()
    local types = Config.BloodTypes
    return types[math.random(1, #types)]
end


function EnsureBloodType(citizenid, steamname, firstname, lastname, cb)
    exports.oxmysql:execute('SELECT * FROM player_bloodtypes WHERE citizenid = ?', {citizenid}, function(result)
        if result and result[1] then
            cb(result[1].bloodtype)
        else
            local bloodtype = GenerateRandomBloodType()
            local now = os.date('%Y-%m-%d %H:%M:%S')
            exports.oxmysql:insert('INSERT INTO player_bloodtypes (citizenid, steamname, firstname, lastname, bloodtype, created_at) VALUES (?, ?, ?, ?, ?, ?)', {
                citizenid, steamname, firstname, lastname, bloodtype, now
            }, function()
                cb(bloodtype)
            end)
        end
    end)
end

QBCore.Commands.Add('takeblood', 'Take blood from the nearest person (ambulance only)', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name ~= "ambulance" then
        TriggerClientEvent('QBCore:Notify', source, "Only ambulance personnel can do this.", "error")
        return
    end
    TriggerClientEvent('rs-blood:client:TakeBlood', source)
end)

RegisterNetEvent('rs-blood:server:FinishBloodDraw', function(targetId)
    local src = source
    local srcPlayer = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not targetPlayer then return end

    -- Verwijder items bij afnemer
    if not srcPlayer.Functions.RemoveItem(Config.RequiredItems.Needle, 1) or not srcPlayer.Functions.RemoveItem(Config.RequiredItems.BloodBag, 1) then
        TriggerClientEvent('QBCore:Notify', src, "You are missing a needle or empty blood bag.", "error")
        return
    end

    local citizenid = targetPlayer.PlayerData.citizenid
    local steamname = GetPlayerSteamName(targetPlayer.PlayerData.source)
    local firstname = targetPlayer.PlayerData.charinfo.firstname
    local lastname = targetPlayer.PlayerData.charinfo.lastname

    EnsureBloodType(citizenid, steamname, firstname, lastname, function(bloodtype)
        
        srcPlayer.Functions.AddItem("blood_bag", 1, false, {
            bloodtype = bloodtype,
            firstname = firstname,
            lastname = lastname
        })

        
        TriggerClientEvent('rs-blood:client:ApplyHPLoss', targetId, Config.HPLoss)

        
        if math.random(1,100) <= Config.DrunkChance then
            TriggerClientEvent('rs-blood:client:DrunkEffect', targetId, Config.DrunkTime)
        end
        if math.random(1,100) <= Config.FallChance then
            TriggerClientEvent('rs-blood:client:FallEffect', targetId)
        end

        
        local embed = {
            {
                ["color"] = 16711680,
                ["title"] = Config.Discord.Text,
                ["description"] = string.format("Blood taken from **%s %s**\nSteam: `%s`\nBloedtype: **%s**\nDatum: %s", firstname, lastname, steamname, bloodtype, os.date("%Y-%m-%d %H:%M:%S")),
                ["footer"] = {["text"] = os.date("%c"), ["icon_url"] = Config.Discord.Logo}
            }
        }
        PerformHttpRequest(Config.Discord.Webhook, function() end, 'POST', json.encode({username = Config.Discord.Name, embeds = embed}), {['Content-Type'] = 'application/json'})
    end)
end)


QBCore.Functions.CreateUseableItem(Config.RequiredItems.Needle, function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name ~= "ambulance" then
        TriggerClientEvent('QBCore:Notify', source, "Only ambulance personnel can use this.", "error")
        return
    end
    TriggerClientEvent('rs-blood:client:TakeBlood', source)
end)

