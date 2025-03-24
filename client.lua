Citizen.CreateThread(function()
  for _, teleportData in ipairs(Config.TeleportLocations) do
      local teleportText = teleportData[1]
      local pointA = teleportData[2]
      local pointB = teleportData[3]

      -- Teleportation request function
      local function requestTeleport(destination)
          -- Request the server to teleport the player
          TriggerServerEvent('RTK_Teleport:requestTeleport', destination)
      end

      -- Create two interaction points: A → B and B → A
      for _, point in ipairs({pointA, pointB}) do
          local targetDestination = (point == pointA) and pointB or pointA
          local canInteract = false

          -- Define the interaction point with ESX.Point
          local esxPoint = ESX.Point:new({
              coords = point,
              distance = Config.Distance or 1.5,
              hidden = Config.Hidden or false
          })

          -- Register the interaction
          ESX.RegisterInteraction('Teleport_' .. teleportText .. '_' .. tostring(point), function()
              if canInteract then
                  canInteract = false -- Temporarily disable interaction
                  ESX.HideUI() -- Hide TextUI to prevent repeated teleportation
                  requestTeleport(targetDestination) -- Request teleportation from the server
              end
          end, function()
              return canInteract
          end)

          -- Detect when the player enters the interaction zone
          function esxPoint:enter()
              if not canInteract then
                  Citizen.SetTimeout(1000, function() -- Wait for 1 second to avoid immediate activation
                      canInteract = true
                      ESX.TextUI(("~g~Press %s to %s"):format(ESX.GetInteractKey(), teleportText))
                  end)
              end
          end

          -- Detect when the player leaves the zone
          function esxPoint:leave()
              canInteract = false
              ESX.HideUI() -- Hide the UI when leaving the zone
          end
      end
  end
end)

-- Client-side: Perform the teleportation
RegisterNetEvent('RTK_Teleport:teleportPlayer')
AddEventHandler('RTK_Teleport:teleportPlayer', function(destination)
    local playerPed = PlayerPedId()
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    -- Use ESX.Game.Teleport to teleport the player
    ESX.Game.Teleport(playerPed, destination, function() 
        print('Player teleported to: ' .. destination.x .. ', ' .. destination.y .. ', ' .. destination.z)
    end)
    Citizen.Wait(500)
    DoScreenFadeIn(500) 
end)
