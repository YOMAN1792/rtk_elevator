Citizen.CreateThread(function()
  for _, teleportData in ipairs(Config.TeleportLocations) do
      local teleportText = teleportData[1]
      local pointA = teleportData[2]
      local pointB = teleportData[3]

      -- Fonction de téléportation réutilisable
      local function TeleportPlayer(destination)
          local player = PlayerPedId()
          DoScreenFadeOut(500)
          Citizen.Wait(500)
          ESX.Game.Teleport(player, destination)
          Citizen.Wait(500)
          DoScreenFadeIn(500)
      end

      -- Créer deux points d'interaction : A → B et B → A
      for _, point in ipairs({pointA, pointB}) do
          local targetDestination = (point == pointA) and pointB or pointA
          local canInteract = false

          -- Définir le point d'interaction avec ESX.Point
          local esxPoint = ESX.Point:new({
              coords = point,
              distance = Config.Distance or 1.5,
              hidden = Config.Hidden or false
          })

          -- Enregistrer l'interaction
          ESX.RegisterInteraction('Teleport_' .. teleportText .. '_' .. tostring(point), function()
              if canInteract then
                  canInteract = false -- Désactiver temporairement
                  ESX.HideUI() -- Cacher TextUI pour éviter une téléportation répétée
                  TeleportPlayer(targetDestination) -- Lancer la téléportation
              end
          end, function()
              return canInteract
          end)

          -- Détecter quand le joueur entre dans la zone d'interaction
          function esxPoint:enter()
              if not canInteract then
                  Citizen.SetTimeout(1000, function() -- Attendre 1 seconde pour éviter une activation immédiate
                      canInteract = true
                      ESX.TextUI(("~g~Appuyez sur %s pour %s"):format(ESX.GetInteractKey(), teleportText))
                  end)
              end
          end

          -- Détecter quand le joueur quitte la zone
          function esxPoint:leave()
              canInteract = false
              ESX.HideUI() -- Cacher l'interface utilisateur quand on sort de la zone
          end
      end
  end
end)
