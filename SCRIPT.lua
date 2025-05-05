local debugX = false -- Hide debug prints

--// Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// GitHub Key System
local validKeysURL = "https://raw.githubusercontent.com/Sourthecoder/adsafgwefesefw/main/keys.txt"
local gui

--// Fetch Keys From GitHub
local function fetchValidKeys()
    local success, result = pcall(function()
        return game:HttpGet(validKeysURL)
    end)

    if success then
        local keys = {}
        for line in string.gmatch(result, "[^\r\n]+") do
            local trimmedKey = line:match("^%s*(.-)%s*$")
            if trimmedKey ~= "" then
                table.insert(keys, trimmedKey)
            end
        end
        return keys
    else
        return {}
    end
end

--// Validate Key
local function validateKey(userKey)
    local validKeys = fetchValidKeys()
    for _, key in pairs(validKeys) do
        if userKey == key then
            return true
        end
    end
    return false
end

--// Main GUI
local function createMainGUI()
    local Window = Rayfield:CreateWindow({
        Name = "Penguin Hub",
        LoadingTitle = "Penguin Hub",
        LoadingSubtitle = "Founded by Armosy",
        Theme = "Dark Blue",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil,
            FileName = "Penguin Hub"
        }
    })

    -- Autofarm Tab
    local AutofarmTab = Window:CreateTab("Autofarm", 4483362458)
    AutofarmTab:CreateSection("Printer Autofarm")

    AutofarmTab:CreateButton({
        Name = "Start Autofarm",
        Callback = function()
            local owned_printer_amount = 0
            local buying_printers = false

            local function tw(target, changes, style, dir, tim)
                game:GetService('TweenService'):Create(target, TweenInfo.new(tim, Enum.EasingStyle[style], Enum.EasingDirection[dir]), changes):Play()
            end

            tw(game.Players.LocalPlayer.Character.HumanoidRootPart, {CFrame = CFrame.new(1172.96, 94.122, -878.75)}, 'Linear', 'InOut', 30)
            task.wait(32)

            workspace.Entities.ChildRemoved:Connect(function(obj)
                if string.find(tostring(obj.Name):lower(), 'printer') and tostring(obj.Properties.Owner.Value) == game.Players.LocalPlayer.Name then
                    owned_printer_amount -= 1
                end
            end)

            while task.wait() do
                pcall(function()
                    spawn(function()
                        if owned_printer_amount < 3 and not buying_printers then
                            buying_printers = true
                            repeat
                                game:GetService("ReplicatedStorage")["_CS.Events"].PurchaseTeamItem:FireServer("Simple Printer", "Single", Color3.new(0, 0, 0))
                                owned_printer_amount += 1
                                task.wait(3)
                            until owned_printer_amount == 6
                            buying_printers = false
                        end
                    end)

                    for _, v in pairs(workspace.Entities:GetChildren()) do
                        if string.find(tostring(v.Name):lower(), 'printer') and tostring(v.Properties.Owner.Value) == game.Players.LocalPlayer.Name and tonumber(v.Properties.CurrentPrinted.Value) >= 200 then
                            game:GetService("ReplicatedStorage")["_CS.Events"].LockPrinter:FireServer(v)
                            game:GetService("ReplicatedStorage")["_CS.Events"].UsePrinter:FireServer(v)
                            game:GetService("ReplicatedStorage")["_CS.Events"].LockPrinter:FireServer(v)
                        end
                    end
                end)
            end
        end,
    })

    -- Visuals Tab
    local VisualsTab = Window:CreateTab("Visuals", 4483362458)
    VisualsTab:CreateSection("ESP")

    VisualsTab:CreateButton({
        Name = "Toggle ESP",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ArmosyScripts/ESP/main/main.lua"))()
        end,
    })
end

--// Create Key GUI
local function createCustomKeyGUI()
    gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "KeyInputGUI"
    gui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Active = true
    mainFrame.Draggable = true

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "u lucky ur ass payed"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 18

    local keyTextbox = Instance.new("TextBox", mainFrame)
    keyTextbox.Size = UDim2.new(0.9, 0, 0, 40)
    keyTextbox.Position = UDim2.new(0.05, 0, 0.3, 0)
    keyTextbox.PlaceholderText = "Enter your key here..."
    keyTextbox.Text = ""
    keyTextbox.TextColor3 = Color3.new(1, 1, 1)
    keyTextbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    keyTextbox.BorderSizePixel = 0
    keyTextbox.ClearTextOnFocus = true

    local messageLabel = Instance.new("TextLabel", mainFrame)
    messageLabel.Size = UDim2.new(0.9, 0, 0, 30)
    messageLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    messageLabel.Text = ""

    local checkButton = Instance.new("TextButton", mainFrame)
    checkButton.Size = UDim2.new(0.4, 0, 0, 40)
    checkButton.Position = UDim2.new(0.05, 0, 0.5, 0)
    checkButton.Text = "Check Key"
    checkButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    checkButton.TextColor3 = Color3.new(1, 1, 1)
    checkButton.BorderSizePixel = 0

    local closeButton = Instance.new("TextButton", mainFrame)
    closeButton.Size = UDim2.new(0.4, 0, 0, 40)
    closeButton.Position = UDim2.new(0.55, 0, 0.5, 0)
    closeButton.Text = "Close"
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.BorderSizePixel = 0

    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    checkButton.MouseButton1Click:Connect(function()
        local userKey = keyTextbox.Text
        if validateKey(userKey) then
            messageLabel.Text = "Key Valid! Loading..."
            task.wait(0.5)
            gui:Destroy()
            createMainGUI()
        else
            messageLabel.Text = "Invalid key. Try again."
        end
    end)
end

--// Start
createCustomKeyGUI()
