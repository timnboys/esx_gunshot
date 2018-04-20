ESX               = nil
local hasShot 	  = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

-----

RegisterNetEvent('esx_guntest:hasShotGun')
AddEventHandler('esx_guntest:hasShotGun', function()
	gunIsShot = true
end)

RegisterNetEvent('esx_guntest:hasNotShotGun')
AddEventHandler('esx_guntest:hasNotShotGun', function()
	gunIsShot = false
end)


RegisterNetEvent('esx_guntest:checkGun')
AddEventHandler('esx_guntest:checkGun', function(source)

	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then	
		
		TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
		
		Citizen.Wait(10000)
		
		ClearPedTasksImmediately(playerPed)

		if (gunIsShot) then
			ESX.ShowNotification('Personen har krutstänk på sina kläder')
		else
			ESX.ShowNotification('Inga spår av krut hittades')
		end

		gunIsShot = false	

	else
		ESX.ShowNotification('Ingen person i närheten.')
	end
end)

RegisterCommand("guntest", function(source)
    TriggerEvent("esx_guntest:checkGun", source)
end, false)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		
		if IsPedShooting(GetPlayerPed(-1)) then
			hasShot = true
		else
			hasShot = false
		end

		if (hasShot) then
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('esx_guntest:storeStatusTrue', GetPlayerServerId(player))
			end
		else
			TriggerServerEvent('esx_guntest:storeStatusFalse', GetPlayerServerId(player))
		end
	end
end)
