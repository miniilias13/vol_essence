-- Script ESX pour voler de l'essence

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Fonction pour voler de l'essence
RegisterNetEvent('volerEssence:demarrer')
AddEventHandler('volerEssence:demarrer', function()
    local ped = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(ped), 3.0, 0, 71)

    if DoesEntityExist(vehicle) then
        local playerData = ESX.GetPlayerData()
        local jerrican = false

        -- Vérifie si le joueur a un jerrican
        for k, v in pairs(playerData.inventory) do
            if v.name == 'jerrican' and v.count > 0 then
                jerrican = true
                break
            end
        end

        if jerrican then
            -- Vérifie si le véhicule a de l'essence
            local fuelLevel = GetVehicleFuelLevel(vehicle)

            if fuelLevel > 0 then
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
                ESX.ShowNotification("Vous commencez à voler l'essence...")

                Citizen.Wait(10000) -- Temps pour voler l'essence (10 secondes)

                ClearPedTasksImmediately(ped)

                local essenceVolée = math.min(10.0, fuelLevel) -- Max 10 unités volées
                TriggerServerEvent('volerEssence:ajouter', essenceVolée)

                -- Réduit le niveau d'essence du véhicule
                SetVehicleFuelLevel(vehicle, fuelLevel - essenceVolée)
                ESX.ShowNotification("Vous avez volé ~g~" .. essenceVolée .. "L d'essence")

                -- Notifie la police
                TriggerServerEvent('volerEssence:alertePolice', GetEntityCoords(ped))

            else
                ESX.ShowNotification("Ce véhicule n'a plus d'essence !")
            end
        else
            ESX.ShowNotification("Vous avez besoin d'un ~r~jerrican~s~ pour voler de l'essence.")
        end
    else
        ESX.ShowNotification("Aucun véhicule proche !")
    end
end)

-- Commande pour démarrer le vol d'essence
RegisterCommand('voleressence', function()
    TriggerEvent('volerEssence:demarrer')
end, false)

-- Ajout du key mapping
RegisterKeyMapping('voleressence', 'Voler l'essence d'un véhicule', 'keyboard', 'E')

-- SERVER-SIDE SCRIPT --

-- Server-side pour ajouter l'essence au joueur
RegisterNetEvent('volerEssence:ajouter')
AddEventHandler('volerEssence:ajouter', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.addInventoryItem('essence', math.floor(amount))
    end
end)
