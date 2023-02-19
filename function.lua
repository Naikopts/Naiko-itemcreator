----------------------------------------------- CE CLIENTS SCRIPTS EST A JOURS POUR LEGACY 1.9 -----------------------------------------------

ESX = exports["es_extended"]:getSharedObject()


function Notification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end


function EntrerText(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ":")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Wait(0) end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Wait(500) 
		return result
	else
		Wait(500) 
		return nil 
	end
end