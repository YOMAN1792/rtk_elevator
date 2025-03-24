RegisterServerEvent('RTK_Teleport:requestTeleport')
AddEventHandler('RTK_Teleport:requestTeleport', function(destination)
  local xPlayer = ESX.GetPlayerFromId(source)

  -- Check if the player is valid
  if not xPlayer then
    print('^1Error: Invalid player attempting teleport.')
    return
  end

  -- Add a source check here
  if source == 65535 then return end  -- 65535 is the ID reserved for server events

  -- Add additional checks here if needed (e.g., check if the player is in a valid zone)

  -- If everything is valid, request the client to proceed with the teleportation
  TriggerClientEvent('RTK_Teleport:teleportPlayer', source, destination)
end)
