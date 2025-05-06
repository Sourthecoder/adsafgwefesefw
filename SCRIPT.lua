l
local validKeysURL = "https://raw.githubusercontent.com/Sourthecoder/adsafgwefesefw/main/keys.txt"
local savedKeyPath = "penguinhub_key.txt"
local loaded = false
local guiElements = {}

--// Utility: Validate Key from GitHub
local function fetchValidKeys()
    local success, result = pcall(function()
        return game:HttpGet(validKeysURL)
    end)
    if not success then return {} end

    local keys = {}
    for line in string.gmatch(result, "[^\r\n]+") do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed ~= "" then
            table.insert(keys, trimmed)
        end
    end
    return keys
end

local function validateKey(userKey)
    local keys = fetchValidKeys()
    for _, key in ipairs(keys) do
        if userKey == key then
            return true
        end
    end
    return false
end

--// ESP Code
local ESPs = {}
local function createESP(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "ESP"
        BillboardGui.Parent = targetPlayer.Character.Head
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 100, 0, 40)
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)

        local NameTag = Instance.new("TextLabel", BillboardGui)
        NameTag.BackgroundTransparency = 1
        NameTag.Size = UDim2.new(1, 0, 0.5, 0)
        NameTag.Text = targetPlayer.Name
        NameTag.TextColor3 = Color3.new(1, 1, 1)
        NameTag.TextStrokeTransparency = 0.5
        NameTag.TextScaled = true

        local HealthTag = Instance.new("TextLabel", BillboardGui)
        HealthTag.BackgroundTransparency = 1
        HealthTag.Position = UDim2.new(0, 0, 0.5, 0)
        HealthTag.Size = UDim2.new(1, 0, 0.5, 0)
        HealthTag.TextColor3 = Color3.fromRGB(255, 0, 0)
        HealthTag.TextStrokeTransparency = 0.5
        HealthTag.TextScaled = true

        game:GetService("RunService").RenderStepped:Connect(function()
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                HealthTag.Text = "HP: " .. math.floor(targetPlayer.Character.Humanoid.Health)
                local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
                NameTag.Text = targetPlayer.Name .. " (" .. math.floor(dist) .. "m)"
            end
        end)

        table.insert(ESPs, BillboardGui)
    end
end

local function enableESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            createESP(p)
        end
    end
    game.Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            wait(1)
            createESP(p)
        end)
    end)
end

local function disableESP()
    for _, esp in ipairs(ESPs) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    ESPs = {}
end

--// FluxLib GUI Setup
local function createMainGUI()
    local Flux = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt"))()
    local win = Flux:Window("Penguin Hub", " Founded by Armosy ", Color3.fromRGB(255, 110, 48), Enum.KeyCode.LeftControl)

    local autofarmTab = win:Tab("Autofarm", "http://www.roblox.com/asset/?id=6023426915")
    autofarmTab:Button("Start Autofarm", "Begins farming loop.", function()
        local owned_printer_amount = 0
        local buying = false

        local function tw(target, props, style, dir, time)
            game:GetService('TweenService'):Create(target, TweenInfo.new(time, Enum.EasingStyle[style], Enum.EasingDirection[dir]), props):Play()
        end

        tw(game.Players.LocalPlayer.Character.HumanoidRootPart, {CFrame = CFrame.new(1172.96, 94.122, -878.75)}, 'Linear', 'InOut', 30)
        task.wait(32)

        workspace.Entities.ChildRemoved:Connect(function(obj)
            if tostring(obj.Name):lower():find("printer") and obj.Properties.Owner.Value == game.Players.LocalPlayer.Name then
                owned_printer_amount -= 1
            end
        end)

        while task.wait() do
            pcall(function()
                spawn(function()
                    if owned_printer_amount < 3 and not buying then
                        buying = true
                        repeat
                            game:GetService("ReplicatedStorage")["_CS.Events"].PurchaseTeamItem:FireServer("Simple Printer", "Single", Color3.new(0, 0, 0))
                            owned_printer_amount += 1
                            task.wait(3)
                        until owned_printer_amount == 6
                        buying = false
                    end
                end)

                for _, v in pairs(workspace.Entities:GetChildren()) do
                    if tostring(v.Name):lower():find("printer") and v.Properties.Owner.Value == game.Players.LocalPlayer.Name and v.Properties.CurrentPrinted.Value >= 200 then
                        local rs = game:GetService("ReplicatedStorage")["_CS.Events"]
                        rs.LockPrinter:FireServer(v)
                        rs.UsePrinter:FireServer(v)
                        rs.LockPrinter:FireServer(v)
                    end
                end
            end)
        end
    end)

    local visualsTab = win:Tab("Visuals", "http://www.roblox.com/asset/?id=6022668888")
    visualsTab:Button("Toggle ESP", "Shows player health + distance", function()
        enableESP()
    end)

    -- Minimize & Close Tab
    local miscTab = win:Tab("Utility", "http://www.roblox.com/asset/?id=6031260788")
    miscTab:Button("Minimize", "Hide UI temporarily", function()
        for _, obj in pairs(game:GetService("CoreGui"):GetDescendants()) do
            if obj:IsA("ScreenGui") and obj.Name:find("Flux") then
                obj.Enabled = not obj.Enabled
            end
        end
    end)

    miscTab:Button("Unload Script", "Stop all features", function()
        local confirm = Flux:Notification("Are you sure?", "Unloading will stop all features!", "Yes")
        if confirm then
            disableESP()
            for _, obj in pairs(game:GetService("CoreGui"):GetChildren()) do
                if obj.Name:find("Flux") then
                    obj:Destroy()
                end
            end
            loaded = false
        end
    end)

    loaded = true
end

--// Custom Key GUI
local function createKeyGUI()
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    gui.Name = "KeyInputGUI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 400, 0, 220)
    frame.Position = UDim2.new(0.5, -200, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Active = true
    frame.Draggable = true

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "Penguin Hub Key System"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.9, 0, 0, 35)
    box.Position = UDim2.new(0.05, 0, 0.3, 0)
    box.PlaceholderText = "Enter your key..."
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    box.BorderSizePixel = 0
    box.Font = Enum.Font.SourceSans
    box.TextSize = 18

    local msg = Instance.new("TextLabel", frame)
    msg.Size = UDim2.new(0.9, 0, 0, 30)
    msg.Position = UDim2.new(0.05, 0, 0.65, 0)
    msg.Text = ""
    msg.TextColor3 = Color3.fromRGB(255, 0, 0)
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.SourceSans
    msg.TextSize = 18

    local check = Instance.new("TextButton", frame)
    check.Size = UDim2.new(0.4, 0, 0, 35)
    check.Position = UDim2.new(0.05, 0, 0.5, 0)
    check.Text = "Check Key"
    check.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    check.TextColor3 = Color3.new(1, 1, 1)

    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0.4, 0, 0, 35)
    close.Position = UDim2.new(0.55, 0, 0.5, 0)
    close.Text = "Close"
    close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    close.TextColor3 = Color3.new(1, 1, 1)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    check.MouseButton1Click:Connect(function()
        local key = box.Text
        if validateKey(key) then
            writefile(savedKeyPath, key)
            gui:Destroy()
            createMainGUI()
        else
            msg.Text = "Invalid key."
        end
    end)
end

--// Boot
if isfile(savedKeyPath) then
    local saved = readfile(savedKeyPath)
    if validateKey(saved) then
        createMainGUI()
    else
        delfile(savedKeyPath)
        createKeyGUI()
    end
else
    createKeyGUI()
end

--// Start
createCustomKeyGUI()
