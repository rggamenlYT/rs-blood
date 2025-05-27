local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('rs-blood:client:TakeBlood', function()
    local playerPed = PlayerPedId()
    local target = nil

    if Config.Debug then
        target = GetPlayerServerId(PlayerId())
    else
        target = GetClosestPlayerServerId(2.0) 
    end

    if not target then
        QBCore.Functions.Notify("No player around!", "error")
        return
    end

    
    QBCore.Functions.TriggerCallback('rs-blood:server:CheckItems', function(hasItems)
        if not hasItems then
            QBCore.Functions.Notify("You are missing a needle or empty blood bag.", "error")
            return
        end

        
        RequestAnimDict("amb@medic@standing@tendtodead@idle_a")
        while not HasAnimDictLoaded("amb@medic@standing@tendtodead@idle_a") do Wait(10) end
        TaskPlayAnim(playerPed, "amb@medic@standing@tendtodead@idle_a", "idle_a", 8.0, -8, Config.ProgressBarTime*1000, 1, 0, false, false, false)

       
        QBCore.Functions.Progressbar("take_blood", "Taking blood...", Config.ProgressBarTime * 1000, false, true, {}, {}, {}, {}, function()
            ClearPedTasks(playerPed)
            TriggerServerEvent('rs-blood:server:FinishBloodDraw', target)
        end)
    end)
end)


RegisterNetEvent('rs-blood:client:ApplyHPLoss', function(amount)
    local ped = PlayerPedId()
    local hp = GetEntityHealth(ped)
    SetEntityHealth(ped, math.max(0, hp - amount))
end)


RegisterNetEvent('rs-blood:client:DrunkEffect', function(duration)
    
    RequestAnimSet("move_m@drunk@verydrunk")
    while not HasAnimSetLoaded("move_m@drunk@verydrunk") do Wait(10) end
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", 1.0)
    ShakeGameplayCam("DRUNK_SHAKE", 0.5)
    Wait(duration * 1000)
    ResetPedMovementClipset(PlayerPedId(), 0.0)
    StopGameplayCamShaking(true)
end)


RegisterNetEvent('rs-blood:client:FallEffect', function()
    SetPedToRagdoll(PlayerPedId(), 2000, 2000, 0, false, false, false)
end)


function GetClosestPlayerServerId(radius)
    local players = QBCore.Functions.GetPlayers()
    local closestDist, closestPlayer = -1, nil
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    for _,v in pairs(players) do
        local targetPed = GetPlayerPed(GetPlayerFromServerId(v))
        if targetPed ~= plyPed then
            local dist = #(GetEntityCoords(targetPed) - plyCoords)
            if closestDist == -1 or dist < closestDist then
                if dist <= (radius or 2.0) then
                    closestDist = dist
                    closestPlayer = v
                end
            end
        end
    end
    return closestPlayer
end


exports.ox_inventory:displayMetadata({
    bloodtype = 'Bloedtype',
})
