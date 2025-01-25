ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('volerEssence:ajouter')
AddEventHandler('volerEssence:ajouter', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.addInventoryItem('essence', math.floor(amount))
    end
end)
