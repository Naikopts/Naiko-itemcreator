----------------------------------------------- ICI LE CLIENT SCRIPT -----------------------------------------------

--- MENU INFORMATION ---
local naiko_Item = {
    nomLabel = "Aucun",
    labelLabel = "Aucun",
    quantiteLabel = "Aucun",
}
----------------------------------------------- Gestion des items-----------------------------------------------
local itemTable = {}

local item_menu = false
local menu_item = RageUI.CreateMenu("Naiko Creator", "Options :")
local menu_itemCreator = RageUI.CreateSubMenu(menu_item, "Naiko Creator", "Création d'item :")
local menu_itemDelete = RageUI.CreateSubMenu(menu_item, "Naiko Creator", "Supprimer item :")
local menu_itemBDD = RageUI.CreateSubMenu(menu_item, "Naiko Creators", "Base de donnée :")
menu_item.Closed = function()
    item_menu = false
end

function ItemMenu()
    if item_menu then
        item_menu = false
        RageUI.Visible(menu_item, false)
        return
    else
        item_menu = true
        RageUI.Visible(menu_item, true)

        Citizen.CreateThread(function()
            while item_menu do
                Citizen.Wait(1)

                RageUI.IsVisible(menu_item, function()

                    RageUI.Separator("~b~↓↓~w~  Intéraction  ~b~↓↓~w~")

                    RageUI.Button("Créer un item", nil, { RightLabel = "→→" }, true, {
                    }, menu_itemCreator)
                    RageUI.Button("Supprimer un item", nil, { RightLabel = "→→" }, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback("naiko:getItem", function(data)
                                itemTable = data
                            end)
                        end
                    }, menu_itemDelete)

                    RageUI.Line()

                    RageUI.Button("Voir les items dans la BDD", nil, { RightLabel = "→→" }, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback("naiko:getItem", function(data)
                                itemTable = data
                            end)
                        end
                    }, menu_itemBDD)
                end)

                RageUI.IsVisible(menu_itemCreator, function()

                    RageUI.Button("Nom :", nil, { RightLabel = naiko_Item.nomLabel }, true, {
                        onSelected = function()
                            local nameResult = EntrerText("Nom de l'item (~b~Par ex: burger~s~) ", "", 20)

                            if nameResult == "" then
                                naiko_Item.nomLabel = "Aucun"
                                Notification("[~r~Erreur~s~] Impossible de créer le nom de l'item.")
                            else
                                naiko_Item.nomLabel = nameResult
                            end
                        end
                    })

                    RageUI.Button("Label :", nil, { RightLabel = naiko_Item.labelLabel }, true, {
                        onSelected = function()
                            local labelResult = EntrerText("Label de l'item (~b~Par ex: Burger~s~) ", "", 20)

                            if labelResult == "" then
                                naiko_Item.labelLabel = "Aucun"
                                Notification("[~r~Erreur~s~] Impossible de créer le label de l'item.")
                            else
                                naiko_Item.labelLabel = labelResult
                            end
                        end
                    })

                    RageUI.Button("Quantité maximum :", nil, { RightLabel = naiko_Item.quantiteLabel }, true, {
                        onSelected = function()
                            local quantityResult = EntrerText("Quantité max que le joueur peux posséder ", "", 3)

                            if tonumber(quantityResult) then
                                naiko_Item.quantiteLabel = quantityResult
                            else
                                naiko_Item.quantiteLabel = "Aucun"
                                Notification("[~r~Erreur~s~] Seuls les chiffres sont tolérés.")
                            end
                        end
                    })

                    RageUI.Line()

                    if naiko_Item.nomLabel == "Aucun" or naiko_Item.labelLabel == "Aucun" or naiko_Item.quantiteLabel == "Aucun" then
                        RageUI.Button("Créer l'item", nil, { RightLabel = "→→", Color = { BackgroundColor = RageUI.ItemsColour.Red } }, false, {
                        })
                    else
                        RageUI.Button("Créer l'item", nil, { RightLabel = "→→", Color = { BackgroundColor = RageUI.ItemsColour.Green } }, true, {
                            onSelected = function()
                                TriggerServerEvent("naiko:itemBuilder", naiko_Item.nomLabel, naiko_Item.labelLabel, naiko_Item.quantiteLabel)
                                RageUI.GoBack()
                                naiko_Item.nomLabel = "Aucun"
                                naiko_Item.labelLabel = "Aucun"
                                naiko_Item.quantiteLabel = "Aucun"
                            end
                        })
                    end
                end)

                RageUI.IsVisible(menu_itemDelete, function()
                    if #itemTable >= 1 then
                        RageUI.Separator("~r~↓↓~s~  Supprimer un item dans la BDD  ~r~↓↓~s~")
                        RageUI.Line()

                        for k, v in pairs(itemTable) do
                            RageUI.Button(v.nomItem, "Appuyez sur ~g~[ENTER]~s~ pour retirer l'item de la BDD", { RightLabel = "~r~Supprimer~s~ →→" }, true, {
                                onSelected = function()
                                    local removeItem = EntrerText("Entrer 'Oui' pour supprimer cet item ", "", 3)

                                    if removeItem == "Oui" then
                                        TriggerServerEvent("naiko:removeItem", v.item)
                                        RageUI.GoBack()
                                    else
                                        Notification("[~r~Erreur~s~] Syntaxe incorrecte.")
                                    end
                                end
                            })
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucun item dans la BDD.")
                        RageUI.Separator("")
                    end
                end)

                RageUI.IsVisible(menu_itemBDD, function()
                    if #itemTable >= 1 then
                        RageUI.Separator("~y~↓↓~s~  Items dans la BDD  ~y~↓↓~s~")
                        RageUI.Line()

                        for k, v in pairs(itemTable) do
                            RageUI.Button(v.nomItem, nil, { RightLabel = "~g~Dans la BDD" }, true, {
                            })
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucun item dans la BDD.")
                        RageUI.Separator("")
                    end
                end)
            end
        end)
    end
end
----------------------------------------------- LES USERS N'ONT PAS LE DROIT D'UTILISER LE MENU DE CREATION D'ITEM -----------------------------------------------
RegisterKeyMapping("-CreationItem", "Menu Item", "keyboard", ConfigItem.Key)
RegisterCommand("-CreationItem", function()
    ESX.TriggerServerCallback('naiko:getUserGroup', function(group)
        if group ~= "user" then
            if item_menu == false then
                ItemMenu()
            end
        else
            Notification("[~r~Erreur~s~] Vous n'avez pas la permissions d'accéder à ce menu.")
        end
    end, GetPlayerServerId(PlayerId()))
end)