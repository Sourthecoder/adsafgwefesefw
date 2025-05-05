
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
    titleLabel.Text = "no script for u nigger boy"
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
