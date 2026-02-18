--[[
    ╔═══════════════════════════════════╗
    ║     KAISEN SCRIPTS - V6.1         ║
    ║   Don't Get Crushed By 67         ║
    ║         By: KAISEN                ║
    ╚═══════════════════════════════════╝
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Configurações
local Config = {
    ToggleKey = Enum.KeyCode.G,
    AutoWin = false,
    AutoRebirth = false,
    FarmSpeed = false,
    FarmMoney = false,
    FarmHealth = false,
    GodMode = false,
    Invisible = false,
    WalkSpeed = 16,
    ShowCoordinates = false
}

-- Variáveis para controle de recursos
local coordinatesGui = nil
local coordinatesConnection = nil

-- Remove UI antiga
if player.PlayerGui:FindFirstChild("KaisenScripts") then 
    player.PlayerGui:FindFirstChild("KaisenScripts"):Destroy()
end

-- Notificacao
game.StarterGui:SetCore("SendNotification", {
    Title = "Kaisen Scripts",
    Text = "Pressione '" .. Config.ToggleKey.Name .. "' para abrir/fechar",
    Duration = 5
})

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaisenScripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Barra de Título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleBarBottom = Instance.new("Frame")
TitleBarBottom.Size = UDim2.new(1, 0, 0, 12)
TitleBarBottom.Position = UDim2.new(0, 0, 1, -12)
TitleBarBottom.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
TitleBarBottom.BorderSizePixel = 0
TitleBarBottom.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Kaisen Scripts"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(100, 180, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -100, 0, 15)
Subtitle.Position = UDim2.new(0, 15, 1, -18)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = ""
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextColor3 = Color3.fromRGB(120, 120, 130)
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleBar

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Sidebar (Menu Lateral)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -185, 1, -55)
ContentArea.Position = UDim2.new(0, 175, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Função para criar botões do menu lateral
local currentSection = nil
local function createMenuButton(name, icon, position)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Btn"
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Text = ""
    Button.Parent = Sidebar
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 25, 0, 25)
    Icon.Position = UDim2.new(0, 10, 0.5, -12.5)
    Icon.BackgroundTransparency = 1
    Icon.Text = icon
    Icon.Font = Enum.Font.GothamBold
    Icon.TextColor3 = Color3.fromRGB(150, 150, 160)
    Icon.TextSize = 16
    Icon.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 40, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamBold
    Label.TextColor3 = Color3.fromRGB(150, 150, 160)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    return Button, Icon, Label
end

-- Função para criar seções
local function createSection(name)
    local Section = Instance.new("ScrollingFrame")
    Section.Name = name .. "Section"
    Section.Size = UDim2.new(1, 0, 1, 0)
    Section.BackgroundTransparency = 1
    Section.BorderSizePixel = 0
    Section.ScrollBarThickness = 4
    Section.ScrollBarImageColor3 = Color3.fromRGB(100, 180, 255)
    Section.Visible = false
    Section.CanvasSize = UDim2.new(0, 0, 0, 0)
    Section.Parent = ContentArea
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Section
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    
    return Section
end

-- Função para criar toggles
local function createToggle(name, section, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = name
    Toggle.Size = UDim2.new(1, -10, 0, 45)
    Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = section
    
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamBold
    Label.TextColor3 = Color3.fromRGB(200, 200, 210)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 25)
    ToggleBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Toggle
    
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 19, 0, 19)
    Circle.Position = UDim2.new(0, 3, 0.5, -9.5)
    Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleBtn
    
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    local isEnabled = false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        
        if isEnabled then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
            Circle:TweenPosition(UDim2.new(1, -22, 0.5, -9.5), "Out", "Quad", 0.2, true)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            Circle:TweenPosition(UDim2.new(0, 3, 0.5, -9.5), "Out", "Quad", 0.2, true)
            Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
        end
        
        if callback then
            callback(isEnabled)
        end
    end)
    
    return Toggle, ToggleBtn
end

-- Função para criar slider
local function createSlider(name, min, max, default, section, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = name
    Slider.Size = UDim2.new(1, -10, 0, 60)
    Slider.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Slider.BorderSizePixel = 0
    Slider.Parent = section
    
    Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamBold
    Label.TextColor3 = Color3.fromRGB(200, 200, 210)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -60, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Slider
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 1, -18)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Slider
    
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar
    
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    
    local Dragger = Instance.new("Frame")
    Dragger.Size = UDim2.new(0, 16, 0, 16)
    Dragger.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    Dragger.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dragger.BorderSizePixel = 0
    Dragger.Parent = SliderBar
    
    Instance.new("UICorner", Dragger).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local currentValue = default
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * pos)
        
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Dragger.Position = UDim2.new(pos, -8, 0.5, -8)
        ValueLabel.Text = tostring(currentValue)
        
        if callback then
            callback(currentValue)
        end
    end
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return Slider
end

-- Função para criar input de tecla
local function createKeybind(name, currentKey, section, callback)
    local Keybind = Instance.new("Frame")
    Keybind.Name = name
    Keybind.Size = UDim2.new(1, -10, 0, 45)
    Keybind.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Keybind.BorderSizePixel = 0
    Keybind.Parent = section
    
    Instance.new("UICorner", Keybind).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -120, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamBold
    Label.TextColor3 = Color3.fromRGB(200, 200, 210)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Keybind
    
    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Size = UDim2.new(0, 100, 0, 30)
    KeyBtn.Position = UDim2.new(1, -110, 0.5, -15)
    KeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    KeyBtn.BorderSizePixel = 0
    KeyBtn.Text = currentKey.Name
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.TextColor3 = Color3.fromRGB(100, 180, 255)
    KeyBtn.TextSize = 12
    KeyBtn.Parent = Keybind
    
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 6)
    
    local listening = false
    
    KeyBtn.MouseButton1Click:Connect(function()
        listening = true
        KeyBtn.Text = "..."
        KeyBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            local newKey = input.KeyCode
            KeyBtn.Text = newKey.Name
            KeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            
            if callback then
                callback(newKey)
            end
        end
    end)
    
    return Keybind
end

-- Criar Seções
local MainSection = createSection("Main")
local ConfigSection = createSection("Config")

-- Criar Botões do Menu
local MainBtn, MainIcon, MainLabel = createMenuButton("Main Features", "🏠", UDim2.new(0, 5, 0, 5))
local ConfigBtn, ConfigIcon, ConfigLabel = createMenuButton("Config", "⚙️", UDim2.new(0, 5, 0, 50))

-- Função para trocar seções
local function switchSection(section, button, icon, label)
    MainSection.Visible = false
    ConfigSection.Visible = false
    
    MainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
    ConfigBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
    
    MainIcon.TextColor3 = Color3.fromRGB(150, 150, 160)
    ConfigIcon.TextColor3 = Color3.fromRGB(150, 150, 160)
    
    MainLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    ConfigLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    
    section.Visible = true
    button.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
end

MainBtn.MouseButton1Click:Connect(function()
    switchSection(MainSection, MainBtn, MainIcon, MainLabel)
end)

ConfigBtn.MouseButton1Click:Connect(function()
    switchSection(ConfigSection, ConfigBtn, ConfigIcon, ConfigLabel)
end)

-- ==================== MAIN FEATURES ====================

-- Função para criar/destruir GUI de coordenadas (DRAGGABLE)
local function toggleCoordinates(enabled)
    if enabled then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        coordinatesGui = Instance.new("ScreenGui")
        coordinatesGui.Name = "PositionDisplay"
        coordinatesGui.ResetOnSpawn = false
        coordinatesGui.Parent = player.PlayerGui

        -- Frame principal draggable
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 200, 0, 130)
        frame.Position = UDim2.new(1, -210, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.Draggable = true  -- Permite arrastar o painel
        frame.Parent = coordinatesGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(100, 180, 255)
        stroke.Thickness = 1.5
        stroke.Parent = frame

        -- Barra de título (drag handle visual)
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 30)
        titleBar.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = frame

        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 10)
        titleCorner.Parent = titleBar

        -- Cobre o canto inferior arredondado da titleBar
        local titleBarFix = Instance.new("Frame")
        titleBarFix.Size = UDim2.new(1, 0, 0, 10)
        titleBarFix.Position = UDim2.new(0, 0, 1, -10)
        titleBarFix.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        titleBarFix.BorderSizePixel = 0
        titleBarFix.Parent = titleBar

        local titleIcon = Instance.new("TextLabel")
        titleIcon.Size = UDim2.new(0, 20, 1, 0)
        titleIcon.Position = UDim2.new(0, 8, 0, 0)
        titleIcon.BackgroundTransparency = 1
        titleIcon.Text = "⠿"
        titleIcon.Font = Enum.Font.GothamBold
        titleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleIcon.TextSize = 18
        titleIcon.Parent = titleBar

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -30, 1, 0)
        titleLabel.Position = UDim2.new(0, 28, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "📍 Localização"
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar

        -- Função auxiliar para criar label de coordenada
        local function makeCoordLabel(labelText, color, yPos)
            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1, -16, 0, 24)
            bg.Position = UDim2.new(0, 8, 0, yPos)
            bg.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            bg.BorderSizePixel = 0
            bg.Parent = frame
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 1, 0)
            lbl.Position = UDim2.new(0, 8, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = color
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = bg
            return lbl
        end

        local xLabel = makeCoordLabel("X: 0", Color3.fromRGB(255, 100, 100), 38)
        local yLabel = makeCoordLabel("Y: 0", Color3.fromRGB(100, 220, 100), 68)
        local zLabel = makeCoordLabel("Z: 0", Color3.fromRGB(100, 140, 255), 98)

        -- Atualiza posição a cada frame
        local function updatePosition()
            if character and humanoidRootPart then
                local pos = humanoidRootPart.Position
                xLabel.Text = "X: " .. math.floor(pos.X * 10) / 10
                yLabel.Text = "Y: " .. math.floor(pos.Y * 10) / 10
                zLabel.Text = "Z: " .. math.floor(pos.Z * 10) / 10
            end
        end

        coordinatesConnection = RunService.RenderStepped:Connect(updatePosition)

        player.CharacterAdded:Connect(function(newCharacter)
            character = newCharacter
            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        end)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Coordenadas",
            Text = "Arraste o painel para mover!",
            Duration = 3
        })
    else
        if coordinatesGui then
            coordinatesGui:Destroy()
            coordinatesGui = nil
        end
        if coordinatesConnection then
            coordinatesConnection:Disconnect()
            coordinatesConnection = nil
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "Coordenadas",
            Text = "Sistema de coordenadas desativado!",
            Duration = 3
        })
    end
end

-- Toggle de Coordenadas
createToggle("Coordenadas", MainSection, function(enabled)
    Config.ShowCoordinates = enabled
    toggleCoordinates(enabled)
end)

-- Botão Dex Explorer
local DexBtn = Instance.new("TextButton")
DexBtn.Size = UDim2.new(1, -10, 0, 45)
DexBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 50)
DexBtn.BorderSizePixel = 0
DexBtn.Text = "🔍 Dex Explorer V4"
DexBtn.Font = Enum.Font.GothamBold
DexBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DexBtn.TextSize = 14
DexBtn.Parent = MainSection

Instance.new("UICorner", DexBtn).CornerRadius = UDim.new(0, 8)

DexBtn.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Dex Explorer",
        Text = "Carregando Dex Explorer V4...",
        Duration = 3
    })
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)

-- Botão Remote Spy
local RemoteSpyBtn = Instance.new("TextButton")
RemoteSpyBtn.Size = UDim2.new(1, -10, 0, 45)
RemoteSpyBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
RemoteSpyBtn.BorderSizePixel = 0
RemoteSpyBtn.Text = "📡 Remote Spy (Logs)"
RemoteSpyBtn.Font = Enum.Font.GothamBold
RemoteSpyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RemoteSpyBtn.TextSize = 14
RemoteSpyBtn.Parent = MainSection

Instance.new("UICorner", RemoteSpyBtn).CornerRadius = UDim.new(0, 8)

RemoteSpyBtn.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Remote Spy",
        Text = "Carregando Remote Spy...",
        Duration = 3
    })
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
end)

-- Botão Infinite Yield
local InfiniteYieldBtn = Instance.new("TextButton")
InfiniteYieldBtn.Size = UDim2.new(1, -10, 0, 45)
InfiniteYieldBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
InfiniteYieldBtn.BorderSizePixel = 0
InfiniteYieldBtn.Text = "🚀 Executar Infinite Yield"
InfiniteYieldBtn.Font = Enum.Font.GothamBold
InfiniteYieldBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteYieldBtn.TextSize = 14
InfiniteYieldBtn.Parent = MainSection

Instance.new("UICorner", InfiniteYieldBtn).CornerRadius = UDim.new(0, 8)

InfiniteYieldBtn.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Infinite Yield",
        Text = "Carregando Infinite Yield...",
        Duration = 3
    })
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- Frame para Script Customizado
local CustomScriptFrame = Instance.new("Frame")
CustomScriptFrame.Size = UDim2.new(1, -10, 0, 120)
CustomScriptFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
CustomScriptFrame.BorderSizePixel = 0
CustomScriptFrame.Parent = MainSection

Instance.new("UICorner", CustomScriptFrame).CornerRadius = UDim.new(0, 8)

local CustomScriptTitle = Instance.new("TextLabel")
CustomScriptTitle.Size = UDim2.new(1, -20, 0, 25)
CustomScriptTitle.Position = UDim2.new(0, 10, 0, 8)
CustomScriptTitle.BackgroundTransparency = 1
CustomScriptTitle.Text = "📜 Script Customizado"
CustomScriptTitle.Font = Enum.Font.GothamBold
CustomScriptTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
CustomScriptTitle.TextSize = 13
CustomScriptTitle.TextXAlignment = Enum.TextXAlignment.Left
CustomScriptTitle.Parent = CustomScriptFrame

local UrlInputFrame = Instance.new("Frame")
UrlInputFrame.Size = UDim2.new(1, -20, 0, 35)
UrlInputFrame.Position = UDim2.new(0, 10, 0, 38)
UrlInputFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
UrlInputFrame.BorderSizePixel = 0
UrlInputFrame.Parent = CustomScriptFrame

Instance.new("UICorner", UrlInputFrame).CornerRadius = UDim.new(0, 6)

local UrlInput = Instance.new("TextBox")
UrlInput.Size = UDim2.new(1, -15, 1, 0)
UrlInput.Position = UDim2.new(0, 8, 0, 0)
UrlInput.BackgroundTransparency = 1
UrlInput.Text = ""
UrlInput.PlaceholderText = "Cole a URL do script aqui..."
UrlInput.Font = Enum.Font.Gotham
UrlInput.TextColor3 = Color3.fromRGB(200, 200, 210)
UrlInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
UrlInput.TextSize = 12
UrlInput.TextXAlignment = Enum.TextXAlignment.Left
UrlInput.ClearTextOnFocus = false
UrlInput.Parent = UrlInputFrame

local ExecuteCustomBtn = Instance.new("TextButton")
ExecuteCustomBtn.Size = UDim2.new(0.48, -5, 0, 30)
ExecuteCustomBtn.Position = UDim2.new(0, 10, 1, -38)
ExecuteCustomBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
ExecuteCustomBtn.BorderSizePixel = 0
ExecuteCustomBtn.Text = "▶️ Executar"
ExecuteCustomBtn.Font = Enum.Font.GothamBold
ExecuteCustomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteCustomBtn.TextSize = 12
ExecuteCustomBtn.Parent = CustomScriptFrame

Instance.new("UICorner", ExecuteCustomBtn).CornerRadius = UDim.new(0, 6)

local CopyCodeBtn = Instance.new("TextButton")
CopyCodeBtn.Size = UDim2.new(0.48, -5, 0, 30)
CopyCodeBtn.Position = UDim2.new(0.52, 5, 1, -38)
CopyCodeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
CopyCodeBtn.BorderSizePixel = 0
CopyCodeBtn.Text = "📋 Copiar Código"
CopyCodeBtn.Font = Enum.Font.GothamBold
CopyCodeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyCodeBtn.TextSize = 12
CopyCodeBtn.Parent = CustomScriptFrame

Instance.new("UICorner", CopyCodeBtn).CornerRadius = UDim.new(0, 6)

ExecuteCustomBtn.MouseButton1Click:Connect(function()
    local url = UrlInput.Text
    if url == "" then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Erro",
            Text = "Por favor, insira uma URL!",
            Duration = 3
        })
        return
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "Script Customizado",
        Text = "Executando script...",
        Duration = 3
    })
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Erro",
            Text = "Falha ao executar: " .. tostring(err),
            Duration = 5
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Sucesso",
            Text = "Script executado com sucesso!",
            Duration = 3
        })
    end
end)

CopyCodeBtn.MouseButton1Click:Connect(function()
    local url = UrlInput.Text
    if url == "" then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Erro",
            Text = "Por favor, insira uma URL!",
            Duration = 3
        })
        return
    end
    local code = "loadstring(game:HttpGet(\"" .. url .. "\"))()"
    local success = pcall(function()
        setclipboard(code)
    end)
    if success then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Copiado!",
            Text = "Codigo copiado para a area de transferencia!",
            Duration = 3
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Codigo",
            Text = "setclipboard nao disponivel",
            Duration = 3
        })
        print("========== CODIGO GERADO ==========")
        print(code)
        print("===================================")
    end
end)

-- ==================== CONFIG ====================

createKeybind("Toggle UI Key", Config.ToggleKey, ConfigSection, function(newKey)
    Config.ToggleKey = newKey
    game.StarterGui:SetCore("SendNotification", {
        Title = "Keybind Atualizada",
        Text = "Nova tecla: " .. newKey.Name,
        Duration = 3
    })
end)

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(1, -10, 0, 45)
SaveBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
SaveBtn.BorderSizePixel = 0
SaveBtn.Text = "💾 Salvar Configuracao"
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.TextSize = 14
SaveBtn.Parent = ConfigSection

Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 8)

SaveBtn.MouseButton1Click:Connect(function()
    writefile("KaisenScripts_Config.json", game:GetService("HttpService"):JSONEncode(Config))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Configuracao Salva",
        Text = "Suas configuracoes foram salvas!",
        Duration = 3
    })
end)

local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(1, -10, 0, 45)
LoadBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
LoadBtn.BorderSizePixel = 0
LoadBtn.Text = "📂 Carregar Configuracao"
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadBtn.TextSize = 14
LoadBtn.Parent = ConfigSection

Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0, 8)

LoadBtn.MouseButton1Click:Connect(function()
    if isfile("KaisenScripts_Config.json") then
        local loaded = game:GetService("HttpService"):JSONDecode(readfile("KaisenScripts_Config.json"))
        for k, v in pairs(loaded) do
            Config[k] = v
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "Configuracao Carregada",
            Text = "Suas configuracoes foram carregadas!",
            Duration = 3
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Erro",
            Text = "Nenhuma configuracao salva encontrada!",
            Duration = 3
        })
    end
end)

-- Toggle UI com tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Config.ToggleKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Inicia na seção Main
switchSection(MainSection, MainBtn, MainIcon, MainLabel)

print("╔═══════════════════════════════════╗")
print("║     KAISEN SCRIPTS CARREGADO      ║")
print("║   Pressione '" .. Config.ToggleKey.Name .. "' para abrir     ║")
print("╚═══════════════════════════════════╝")
