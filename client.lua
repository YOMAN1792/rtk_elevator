Citizen.CreateThread(function()
  for _, teleportData in ipairs(Config.TeleportLocations) do
      local teleportText = teleportData[1]
      local pointA = teleportData[2]
      local pointB = teleportData[3]

      -- Function to teleport the player to a specified destination
      local function TeleportPlayer(destination)
          local player = PlayerPedId()
          DoScreenFadeOut(500) -- Fade out the screen before teleportation
          Citizen.Wait(500)
          ESX.Game.Teleport(player, destination, function ()
            print("Teleportation successful!")
          end)
          Citizen.Wait(500)
          DoScreenFadeIn(500) -- Fade in the screen after teleportation
      end

      -- Loop through both points (A → B and B → A)
      for _, point in ipairs({pointA, pointB}) do
          local targetDestination = (point == pointA) and pointB or pointA
          local canInteract = false -- Prevents repeated interaction

          -- Create an interaction point using ESX.Point
          local esxPoint = ESX.Point:new({
              coords = point,
              distance = Config.Distance or 1.5, -- Interaction distance
              hidden = Config.Hidden or false -- Whether the point is hidden
          })

          -- Register the interaction for teleportation
          ESX.RegisterInteraction('Teleport_' .. teleportText .. '_' .. tostring(point), function()
              if canInteract then
                  canInteract = false -- Temporarily disable interaction
                  ESX.HideUI() -- Hide the interaction UI
                  TeleportPlayer(targetDestination) -- Execute teleportation
              end
          end, function()
              return canInteract -- Check if interaction is allowed
          end)

          -- Triggered when the player enters the interaction zone
          function esxPoint:enter()
              if not canInteract then
                  Citizen.SetTimeout(1000, function() -- Delay to avoid immediate activation
                      canInteract = true
                      ESX.TextUI(("~g~Press %s to %s"):format(ESX.GetInteractKey(), teleportText))
                  end)
              end
          end

          -- Triggered when the player leaves the interaction zone
          function esxPoint:leave()
              canInteract = false -- Disable interaction when leaving the zone
              ESX.HideUI() -- Hide the interaction UI
          end
      end
  end
end)
