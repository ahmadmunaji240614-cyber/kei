-- ESP Antena + Nama + Teleport GUI
-- Buat dipakai dengan loadstring setelah diupload ke GitHub

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- === Fungsi bikin ESP (Antena + Nama) ===
local function createESP(character, player)
    local head = character:WaitForChild("Head")

    -- Antena
    if not head:FindFirstChild("Antenna") then
        local attachment = Instance.new("Attachment", head)
        attachment.Name = "Antenna"

        local antenna = Instance.new("Beam")
        antenna.Name = "Antenna"
        antenna.Parent = head
        antenna.FaceCamera = true
        antenna.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
        antenna.Width0 = 0.1
        antenna.Width1 = 0.1

        local top = Instance.new("Part")
        top.Size = Vector3.new(0.1,0.1,0.1)
        top.Anchored = true
        top.CanCollide = false
        top.Transparency = 1
        top.Position = head.Position + Vector3.new(0,15,0)
        top.Parent = workspace

        local topAttachment = Instance.new("Attachment", top)
        antenna.Attachment0 = attachment
        antenna.Attachment1 = topAttachment

        RunService.RenderStepped:Connect(function()
            if head and top then
                top.Position = head.Position + Vector3.new(0,15,0)
            end
        end)
    end

    -- Nama di atas kepala
    if not head:FindFirstChild("NameTag") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Parent = head
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboard
        textLabel.Size = UDim2.new(1,0,1,0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.fromRGB(255,255,255)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
    end
end

-- === Teleport GUI ===
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "TeleportGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,200,0,300)
frame.Position = UDim2.new(0,20,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BackgroundTransparency = 0.2

local uiList = Instance.new("UIListLayout", frame)
uiList.Padding = UDim.new(0,5)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Teleport Menu"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- Fungsi bikin tombol teleport
local function createButton(player)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1,0,0,30)
    button.Text = player.Name
    button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    button.TextColor3 = Color3.new(1,1,1)
    button.TextScaled = true

    button.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
        end
    end)
end

-- Pasang ESP + tombol teleport ke semua player
local function onCharacterAdded(character, player)
    createESP(character, player)
end

local function onPlayerAdded(player)
    if player ~= LocalPlayer then
        if player.Character then
            onCharacterAdded(player.Character, player)
        end
        player.CharacterAdded:Connect(function(char)
            onCharacterAdded(char, player)
        end)

        -- Tambahin tombol teleport
        createButton(player)
    end
end

for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
