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
    ShowCoordinates = false
}

-- Variáveis para controle de recursos
local coordinatesGui = nil
local coordinatesConnection = nil

-- ============================================
-- CARREGAR UI FRAMEWORK
-- ============================================
local KaisenUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kmzinmod/Kaisen-UI/refs/heads/main/UI.luau"))({
    Title = "⚡ Kaisen Scripts",
    Subtitle = "v1.0",
    ToggleKey = Config.ToggleKey,
    MainColor = Color3.fromRGB(100, 180, 255),
    BackgroundColor = Color3.fromRGB(18, 18, 22),
    SidebarColor = Color3.fromRGB(22, 22, 27),
    ButtonColor = Color3.fromRGB(30, 30, 37),
    TextColor = Color3.fromRGB(200, 200, 210),
    Width = 550,
    Height = 400
})

-- Remove UI antiga se existir
if player.PlayerGui:FindFirstChild("KaisenScripts") then 
    player.PlayerGui:FindFirstChild("KaisenScripts"):Destroy()
end

-- Notificação
game.StarterGui:SetCore("SendNotification", {
    Title = "Kaisen Scripts",
    Text = "Pressione 'G' para abrir/fechar",
    Duration = 5
})

-- ============================================
-- FUNÇÕES DO SCRIPT ORIGINAL
-- ============================================

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
        frame.Draggable = true
        frame.Parent = coordinatesGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(100, 180, 255)
        stroke.Thickness = 1.5
        stroke.Parent = frame

        -- Barra de título
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 30)
        titleBar.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = frame

        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 10)
        titleCorner.Parent = titleBar

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

-- ============================================
-- CRIAR SEÇÕES DA UI
-- ============================================

-- Seção Principal (Main Features)
KaisenUI:AddSection("Main Features", "🏠", function(section)
    
    -- Toggle de Coordenadas
    KaisenUI:AddToggle("Coordenadas", section, function(enabled)
        Config.ShowCoordinates = enabled
        toggleCoordinates(enabled)
    end)
    
    -- Botão Dex Explorer
    KaisenUI:AddButton("🔍 Dex Explorer V4", section, function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Dex Explorer",
            Text = "Carregando Dex Explorer V4...",
            Duration = 3
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end)
    
    -- Botão Remote Spy
    KaisenUI:AddButton("📡 Remote Spy (Logs)", section, function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Remote Spy",
            Text = "Carregando Remote Spy...",
            Duration = 3
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
    end)
    
    -- Botão Infinite Yield
    KaisenUI:AddButton("🚀 Executar Infinite Yield", section, function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Infinite Yield",
            Text = "Carregando Infinite Yield...",
            Duration = 3
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    
    -- Área de Script Customizado
    local CustomFrame = Instance.new("Frame")
    CustomFrame.Size = UDim2.new(1, -10, 0, 120)
    CustomFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    CustomFrame.BorderSizePixel = 0
    CustomFrame.Parent = section
    
    Instance.new("UICorner", CustomFrame).CornerRadius = UDim.new(0, 8)
    
    local CustomTitle = Instance.new("TextLabel")
    CustomTitle.Size = UDim2.new(1, -20, 0, 25)
    CustomTitle.Position = UDim2.new(0, 10, 0, 8)
    CustomTitle.BackgroundTransparency = 1
    CustomTitle.Text = "📜 Script Customizado"
    CustomTitle.Font = Enum.Font.GothamBold
    CustomTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
    CustomTitle.TextSize = 13
    CustomTitle.TextXAlignment = Enum.TextXAlignment.Left
    CustomTitle.Parent = CustomFrame
    
    local UrlInputFrame = Instance.new("Frame")
    UrlInputFrame.Size = UDim2.new(1, -20, 0, 35)
    UrlInputFrame.Position = UDim2.new(0, 10, 0, 38)
    UrlInputFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    UrlInputFrame.BorderSizePixel = 0
    UrlInputFrame.Parent = CustomFrame
    
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
    
    local ExecuteBtn = Instance.new("TextButton")
    ExecuteBtn.Size = UDim2.new(0.48, -5, 0, 30)
    ExecuteBtn.Position = UDim2.new(0, 10, 1, -38)
    ExecuteBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    ExecuteBtn.BorderSizePixel = 0
    ExecuteBtn.Text = "▶️ Executar"
    ExecuteBtn.Font = Enum.Font.GothamBold
    ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecuteBtn.TextSize = 12
    ExecuteBtn.Parent = CustomFrame
    
    Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 6)
    
    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0.48, -5, 0, 30)
    CopyBtn.Position = UDim2.new(0.52, 5, 1, -38)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
    CopyBtn.BorderSizePixel = 0
    CopyBtn.Text = "📋 Copiar Código"
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.TextSize = 12
    CopyBtn.Parent = CustomFrame
    
    Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
    
    ExecuteBtn.MouseButton1Click:Connect(function()
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
    
    CopyBtn.MouseButton1Click:Connect(function()
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
                Text = "Código copiado para a área de transferência!",
                Duration = 3
            })
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "Código",
                Text = "setclipboard não disponível",
                Duration = 3
            })
            print("========== CÓDIGO GERADO ==========")
            print(code)
            print("===================================")
        end
    end)
end)

-- Seção Configurações
KaisenUI:AddSection("Config", "⚙️", function(section)
    
    -- Keybind para UI
    KaisenUI:AddKeybind("Toggle UI Key", Config.ToggleKey, section, function(newKey)
        Config.ToggleKey = newKey
        game.StarterGui:SetCore("SendNotification", {
            Title = "Keybind Atualizada",
            Text = "Nova tecla: " .. newKey.Name,
            Duration = 3
        })
    end)
    
    -- Botão Salvar
    KaisenUI:AddButton("💾 Salvar Configuração", section, function()
        writefile("KaisenScripts_Config.json", game:GetService("HttpService"):JSONEncode(Config))
        game.StarterGui:SetCore("SendNotification", {
            Title = "Configuração Salva",
            Text = "Suas configurações foram salvas!",
            Duration = 3
        })
    end)
    
    -- Botão Carregar
    KaisenUI:AddButton("📂 Carregar Configuração", section, function()
        if isfile("KaisenScripts_Config.json") then
            local loaded = game:GetService("HttpService"):JSONDecode(readfile("KaisenScripts_Config.json"))
            for k, v in pairs(loaded) do
                Config[k] = v
            end
            game.StarterGui:SetCore("SendNotification", {
                Title = "Configuração Carregada",
                Text = "Suas configurações foram carregadas!",
                Duration = 3
            })
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "Erro",
                Text = "Nenhuma configuração salva encontrada!",
                Duration = 3
            })
        end
    end)
end)

-- ============================================
-- MOSTRAR UI
-- ============================================
KaisenUI:Show()

print("╔═══════════════════════════════════╗")
print("║     KAISEN SCRIPTS CARREGADO      ║")
print("║   Pressione 'G' para abrir        ║")
print("╚═══════════════════════════════════╝")
