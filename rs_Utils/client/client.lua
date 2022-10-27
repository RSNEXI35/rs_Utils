ESX = nil 
local player = GetPlayerPed(-1)
local coords = GetEntityCoords(player)


-- NE PAS TOUCHER


Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
        end)
    end
end)



---- Désactiver les roulades 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsControlPressed(0, 25)
            then DisableControlAction(0, 22, true)
        end
    end
end) 


--- Activation du train 

Citizen.CreateThread(function()
    SwitchTrainTrack(0, true)
    SwitchTrainTrack(3, true)
    N_0x21973bbf8d17edfa(0, 120000)
    SetRandomTrains(true)
end) 

--- /id

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local id = GetPlayerServerId(PlayerId())

RegisterCommand("id", function() 
    ESX.ShowNotification('Votre ID est le : ~r~'..id)
end)

--- DESACTIVER COUPS DE CROSS 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
           DisableControlAction(1, 140, true)
              DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)

------- No drop arme pnj  

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    -- List of pickup hashes (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
  end
end)

Citizen.CreateThread(function() -- Remove Police NPC
    while true do
        Citizen.Wait(10)
        local playerPed = GetPlayerPed(-1)
        local playerLocalisation = GetEntityCoords(playerPed)
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
        DisablePlayerVehicleRewards(PlayerId()) -- No drop weapon in car
    end
end)


-------- Changement de place 1 2 3 4

Citizen.CreateThread(function()
    while true do
    local plyPed = PlayerPedId()
    if IsPedSittingInAnyVehicle(plyPed) then
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On d�finit la vitesse du v�hicule en km/h
    if CarSpeed <= 300.0 then -- On ne peux pas changer de place si la vitesse du v�hicule est au dessus ou �gale � 300 km/h
    if IsControlJustReleased(0, 157) then -- conducteur : 1
    SetPedIntoVehicle(plyPed, plyVehicle, -1)
    Citizen.Wait(10)
    end
    if IsControlJustReleased(0, 158) then -- avant droit : 2
    SetPedIntoVehicle(plyPed, plyVehicle, 0)
    Citizen.Wait(10)
    end
    if IsControlJustReleased(0, 160) then -- arriere gauche : 3
    SetPedIntoVehicle(plyPed, plyVehicle, 1)
    Citizen.Wait(10)
    end
    if IsControlJustReleased(0, 164) then -- arriere droite : 4
    SetPedIntoVehicle(plyPed, plyVehicle, 2)
    Citizen.Wait(10)
    end
    end
    end
    Citizen.Wait(10) -- anti crash
    end
end)

---- Fonction K.O

local knockedOut = false
local wait = 15
local count = 60

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local myPed = GetPlayerPed(-1)
        if IsPedInMeleeCombat(myPed) then
            if GetEntityHealth(myPed) < 115 then
                SetPlayerInvincible(PlayerId(), true)
                SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                ShowNotification("~r~Vous etes KO!")
                wait = 15
                knockedOut = true
                SetEntityHealth(myPed, 116)
            end
        end
        if knockedOut == true then
            SetPlayerInvincible(PlayerId(), true)
            DisablePlayerFiring(PlayerId(), true)
            SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
            ResetPedRagdollTimer(myPed)
            
            if wait >= 0 then
                count = count - 1
                if count == 0 then
                    count = 60
                    wait = wait - 1
                    SetEntityHealth(myPed, GetEntityHealth(myPed)+4)
                end
            else
                SetPlayerInvincible(PlayerId(), false)
                knockedOut = false
            end
        end
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

---- Menu Pause

function SetData()
    players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert( players, player )
end

    
    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', "LS DEV • https://discord.gg/6WWU2kgx44 ID: "..id.." • ".. #players .." connecté(e)s") -- Mettre le nom de votre serveur et votre invite Discord
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        SetData()
    end
end)

Citizen.CreateThread(function()
    while true do
        AddTextEntry('PM_SCR_MAP', '~b~Carte de Los Santos')
        AddTextEntry('PM_SCR_GAM', '~r~Prendre l\'avion')
        AddTextEntry('PM_SCR_INF', '~g~Logs')
        AddTextEntry('PM_SCR_SET', '~p~Configuration')
        AddTextEntry('PM_SCR_STA', '~b~Statistiques')
        AddTextEntry('PM_SCR_GAL', '~y~Galerie')
        AddTextEntry('PM_SCR_RPL', '~y~Éditeur ∑')
        AddTextEntry('PM_PANE_CFX', '~y~SERVEUR') -- MEttre le nom de votre serveur
        AddTextEntry('PM_PANE_LEAVE', '~p~Se déconnecter de SERVEUR'); -- Mettre le nom de votre serveur
        AddTextEntry('PM_PANE_QUIT', '~r~Quitter FiveM');
        Citizen.Wait(5000)
    end
end)

--- Fonction pour enlever la reticule

Citizen.CreateThread(function()
    local isSniper = false
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        local currentWeaponHash = GetSelectedPedWeapon(ped)

        if currentWeaponHash == 100416529 then
            isSniper = true
        elseif currentWeaponHash == 205991906 then
            isSniper = true
        elseif currentWeaponHash == -952879014 then
            isSniper = true
        elseif currentWeaponHash == GetHashKey('WEAPON_HEAVYSNIPER_MK2') then
            isSniper = true
        else
            isSniper = false
        end

        if not isSniper then
            HideHudComponentThisFrame(14)
        end
    end
end)

--- Anti Head-Shot 

Citizen.CreateThread(function()
    while true do
        Wait(5)

        SetPedSuffersCriticalHits(PlayerPedId(), false)
    end
end)

--- Anti Bunny Hop

local NumberJump = 10

Citizen.CreateThread(function()
  local Jump = 0
  while true do

      Citizen.Wait(1)

      local ped = PlayerPedId()

      if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then

        Jump = Jump + 1

          if Jump == NumberJump then

              SetPedToRagdoll(ped, 5000, 1400, 2)

              Jump = 0

          end

      else 

          Citizen.Wait(500)
          
      end
  end
end)

--- /discord

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local discord = "https://discord.gg/6WWU2kgx44"

RegisterCommand("discord", function() 
    ESX.ShowNotification("Voici le discord : https://discord.gg/6WWU2kgx44"..discord)
end)


--- Désactivation des pnj gang attaquent

SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_LOST"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))

SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))

--- Désactivation des DriveBy

local passengerDriveBy = false

Citizen.CreateThread(function()
    while true do
        Wait(1)

        playerPed = GetPlayerPed(-1)
        car = GetVehiclePedIsIn(playerPed, false)
        if car then
            if GetPedInVehicleSeat(car, -1) == playerPed then
                SetPlayerCanDoDriveBy(PlayerId(), false)
            elseif passengerDriveBy then
                SetPlayerCanDoDriveBy(PlayerId(), true)
            else
                SetPlayerCanDoDriveBy(PlayerId(), false)
            end
        end
    end
end)

---Cayo Perico sans mapping
Citizen.CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(GetPlayerPed(-1))        
            local distance1 = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4840.571, -5174.425, 2.0, false)
            if distance1 < 2000.0 then
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- load the map and removes the city
            Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map
            else
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
            Citizen.InvokeNative("0x5E1460624D194A38", false)
            end
        Citizen.Wait(5000)
    end
end)

---Anti vol pnj
Citizen.CreateThread(function()
    while true do
        Wait(800)

        local player = GetPlayerPed(-1)
        local PlayerPedId = PlayerPedId(player)

        local veh = GetVehiclePedIsTryingToEnter(PlayerPedId)
        if veh ~= nil and DoesEntityExist(veh) then

            local lockStatus = GetVehicleDoorLockStatus(veh)
            if lockStatus == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end

            local ped = GetPedInVehicleSeat(veh, -1)
            if ped then
                SetPedCanBeDraggedOut(ped, false)
            end

        end
    end
end)

----Commande Twitter
Citizen.CreateThread(function()
function notify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end
function hardNotify(title, subject, msg, icon, iconType)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    SetNotificationMessage(icon, icon, false, iconType, title, subject)
    DrawNotification(false, false)
end
end)

---Neige
Citizen.CreateThread(function()
    while true 
        do
        
        SetWeatherTypePersist("XMAS")
        SetWeatherTypeNowPersist("XMAS")
        SetWeatherTypeNow("XMAS")
        SetOverrideWeather("XMAS")
        
        Citizen.Wait(1)
    end

end)

---carkill
local carkill = { 133987706, -1553120962 }

  function verif (a, val)
    for name, value in ipairs(a) do
        if value == val then
            return true
        end
    end
    return false
end

RegisterCommand('carkill', function()
local ped = GetPlayerPed(-1)
local cd = GetPedCauseOfDeath(ped)
    if verif(carkill, cd) then
        TriggerEvent('esx_ambulancejob:revive')
        TriggerEvent('esx:showNotification', '~g~Vous avez été réanimé suite à une mort causé par un véhicule.')
        Citizen.Wait(2500)
        TriggerEvent('esx:showNotification', '~y~Si le carkill était justifié et justifiable, un admin pourra décider de votre sanction.')
    else
        TriggerEvent('esx:showNotification', '~r~Vous n\'avez pas été tué suite à un accident causé par un véhicule.')
    end
end, false)
