ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('volerEssence:ajouter')
AddEventHandler('volerEssence:ajouter', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.addInventoryItem('essence', math.floor(amount))
    end
end)
-- Alerte pour les policiers
RegisterNetEvent('volerEssence:alertePolice')
AddEventHandler('volerEssence:alertePolice', function(coords)
    local xPlayers = ESX.GetPlayers()

    for _, playerId in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', playerId, "~r~Une personne est en train de voler de l'essence !")
            TriggerClientEvent('volerEssence:marqueurPolice', playerId, coords)
        end
    end
end)
