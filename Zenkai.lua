--[[
    NEXOS HUB - ZENKAI BLOX
    Plataforma: Roblox / Delta Executor Mobile (Android)
    Linguagem: LuaU
    Tema: Preto e Vermelho (Gamer Premium)
]]

-- Serviços essenciais do Roblox
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or CoreGui

-- Evitar duplicação da UI se o script for executado novamente
if PlayerGui:FindFirstChild("NexosHubZenkai") then
    PlayerGui.NexosHubZenkai:Destroy()
end

-- Variáveis de Estado e Configurações
local _G_Config = {
    AutoTrain = false,
    SelectedTrain = "Fisico", -- Exemplo de modalidade
    AutoPrestige = false,
    PrestigeThreshold = 1200,
    Notifications = true
}

-- Criação da ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexosHubZenkai"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Função Auxiliar para Notificações Estilizadas
local function notify(title, text)
    if not _G_Config.Notifications then return end
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 260, 0, 60)
    NotifFrame.Position = UDim2.new(1, -270, 0, 20)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotifFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(220, 20, 60)
    UIStroke.Thickness = 2
    UIStroke.Parent = NotifFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -16, 0, 22)
    TitleLabel.Position = UDim2.new(0, 8, 0, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -16, 0, 26)
    TextLabel.Position = UDim2.new(0, 8, 0, 26)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.Text = text
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel.TextSize = 12
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = NotifFrame

    -- Animação de entrada e saída
    NotifFrame.Position = UDim2.new(1, 10, 0, 20)
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 0, 20)}):Play()

    task.delay(3, function()
        if NotifFrame and NotifFrame.Parent then
            local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 0, 20)})
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end
    end)
end

-- Janela Principal (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Suporte nativo básico, complementado por toque fluido abaixo
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(220, 20, 60) -- Vermelho Gamer
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Barra Superior (Header)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = Elem or 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

-- Correção visual para os cantos inferiores da barra superior ficarem retos
local FixTopBar = Instance.new("Frame")
FixTopBar.Size = UDim2.new(1, 0, 0, 10)
FixTopBar.Position = UDim2.new(0, 0, 1, -10)
FixTopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FixTopBar.BorderSizePixel = 0
FixTopBar.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "NEXOS HUB <font color=\"#DC143C\">| Zenkai Blox</font>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Botão Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -74, 0, 4)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Botão Fechar / Sair
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -36, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 40)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Sistema de Movimentação Fluida por Toque (Mobile / Delta Optimizer)
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Botão Flutuante (Minimizado)
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Position = UDim2.new(0, 20, 0.5, -25)
FloatingButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.Text = "NEXOS"
FloatingButton.TextColor3 = Color3.fromRGB(220, 20, 60)
FloatingButton.TextSize = 11
FloatingButton.Visible = false
FloatingButton.Active = true
FloatingButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0) -- Redondo estilo bolinha
FloatCorner.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(220, 20, 60)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatingButton

-- Lógica de Minimizar / Restaurar
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingButton.Visible = true
    notify("NEXOS HUB", "Minimizado para a bolinha flutuante.")
end)

FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingButton.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container de Abas (Sidebar Esquerda)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundTransparency = 1
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 250)
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local UIListLayoutSidebar = Instance.new("UIListLayout")
UIListLayoutSidebar.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutSidebar.Padding = UDim.new(0, 6)
UIListLayoutSidebar.Parent = Sidebar

-- Container de Conteúdo das Abas (Direita)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -130, 1, -55)
ContentContainer.Position = UDim2.new(0, 125, 0, 48)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Tabela para gerenciar abas
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 350)
    TabContent.ScrollBarThickness = 3
    TabContent.Parent = ContentContainer

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = TabContent

    -- Botão na Sidebar
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Btn"
    TabButton.Size = UDim2.new(1, -10, 0, 38)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.TextSize = 12
    TabButton.Parent = Sidebar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabButton

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Content.Visible = false
            tab.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
        TabContent.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
        CurrentTab = name
    end)

    Tabs[name] = {Content = TabContent, Button = TabButton}
    return TabContent
end

-- Criando as Abas solicitadas
local TabInicio = CreateTab("INÍCIO")
local TabTreinamento = CreateTab("TREINAMENTO")
local TabPrestigio = CreateTab("PRESTÍGIO")
local TabMundos = CreateTab("MUNDOS")
local TabConfig = CreateTab("CONFIGURAÇÕES")

-- Ativar aba inicial por padrão
Tabs["INÍCIO"].Content.Visible = true
Tabs["INÍCIO"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs["INÍCIO"].Button.BackgroundColor3 = Color3.fromRGB(220, 20, 60)

-- Componentes UI Auxiliares para preencher as abas
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 24)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = ""
    toggleBtn.Parent = frame

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn

    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)

    return frame
end

-- ==========================================
-- CONTEÚDO DA ABA: INÍCIO
-- ==========================================
local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, -10, 0, 50)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Font = Enum.Font.GothamBold
WelcomeLabel.Text = "Bem-vindo ao NEXOS HUB!\nOtimizado para Zenkai Blox & Delta."
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.TextSize = 13
WelcomeLabel.TextWrapped = true
WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
WelcomeLabel.Parent = TabInicio

local StatusInfo = Instance.new("TextLabel")
StatusInfo.Size = UDim2.new(1, -10, 0, 60)
StatusInfo.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
StatusInfo.Font = Enum.Font.Gotham
StatusInfo.Text = " Status: Pronto\n Jogador: " .. LocalPlayer.Name
StatusInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusInfo.TextSize = 12
StatusInfo.TextXAlignment = Enum.TextXAlignment.Left
StatusInfo.Parent = TabInicio

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusInfo

-- ==========================================
-- CONTEÚDO DA ABA: TREINAMENTO
-- ==========================================
CreateToggle(TabTreinamento, "Ativar Treinamento Automático", false, function(state)
    _G_Config.AutoTrain = state
    if state then
        notify("Treinamento", "Treinamento automático iniciado.")
    else
        notify("Treinamento", "Treinamento automático pausado.")
    end
end)

-- Loop de Treinamento Automático (Simulação baseada nas mecânicas reais do Zenkai Blox)
task.spawn(function()
    while true do
        task.run(function()
            if _G_Config.AutoTrain then
                -- Lógica segura para interagir com o sistema de treino do jogo sem travar
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        -- Disparo de ferramentas ou eventos de treino do jogo (se encontrados no backpack/character)
                        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and (tool.Name:lower():find("train") or tool.Name:lower():find("peso") or tool.Name:lower():find("punch")) then
                                LocalPlayer.Character.Humanoid:EquipTool(tool)
                                tool:Activate()
                            end
                        end
                    end
                end)
            end
        end)
        task.wait(1)
    end
end)

-- ==========================================
-- CONTEÚDO DA ABA: PRESTÍGIO
-- ==========================================
local PrestigeStatus = Instance.new("TextLabel")
PrestigeStatus.Size = UDim2.new(1, -10, 0, 45)
PrestigeStatus.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
PrestigeStatus.Font = Enum.Font.GothamBold
PrestigeStatus.Text = " Requisito Mínimo: 1200 Zenkais"
PrestigeStatus.TextColor3 = Color3.fromRGB(255, 215, 0)
PrestigeStatus.TextSize = 12
PrestigeStatus.TextXAlignment = Enum.TextXAlignment.Left
PrestigeStatus.Parent = TabPrestigio

local PCorner = Instance.new("UICorner")
PCorner.CornerRadius = UDim.new(0, 8)
PCorner.Parent = PrestigeStatus

CreateToggle(TabPrestigio, "Auto Prestígio (>= 1200 Zenkais)", false, function(state)
    _G_Config.AutoPrestige = state
    if state then
        notify("Prestígio", "Auto Prestígio ativado com segurança.")
    else
        notify("Prestígio", "Auto Prestígio desativado.")
    end
end)

CreateButton(TabPrestigio, "Verificar Zenkais & Executar Agora", function()
    pcall(function()
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local zenkais = leaderstats:FindFirstChild("Zenkai") or leaderstats:FindFirstChild("Zenkais")
            if zenkais then
                local qtde = zenkais.Value
                if qtde >= 1200 then
                    notify("Prestígio", "Zenkais suficientes (" .. qtde .. "). Executando prestígio...")
                    -- Gatilho remoto real do jogo para prestígio (se disponível nos remotes)
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
                    if remotes and remotes:FindFirstChild("Prestige") then
                        remotes.Prestige:FireServer()
                    end
                else
                    notify("Aviso", "Zenkais insuficientes (" .. qtde .. "/1200 necessários).")
                end
            else
                notify("Erro", "Estatística de Zenkais não encontrada no leaderstats.")
            end
        end
    end)
end)

-- Loop de Auto Prestígio Seguro
task.spawn(function()
    while true do
        task.run(function()
            if _G_Config.AutoPrestige then
                pcall(function()
                    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                    if leaderstats then
                        local zenkais = leaderstats:FindFirstChild("Zenkai") or leaderstats:FindFirstChild("Zenkais")
                        if zenkais and zenkais.Value >= 1200 then
                            notify("Auto Prestígio", "Meta atingida! Executando...")
                            local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
                            if remotes and remotes:FindFirstChild("Prestige") then
                                remotes.Prestige:FireServer()
                            end
                            task.wait(5) -- Cooldown para evitar spam
                        end
                    end
                end)
            end
        end)
        task.wait(3)
    end
end)

-- ==========================================
-- CONTEÚDO DA ABA: MUNDOS
-- ==========================================
local function AddWorldTeleport(worldName, targetCFrame)
    CreateButton(TabMundos, "Ir para: " .. worldName, function()
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = targetCFrame
                notify("Teleporte", "Teleportado com sucesso para " .. worldName)
            end
        end)
    end)
end

-- Exemplos de Mundos baseados no mapa comum de Zenkai Blox (ajustáveis conforme coordenadas reais)
AddWorldTerra = AddWorldTeleport("Mundo 1 (Terra)", CFrame.new(0, 50, 0))
AddWorldNamek = AddWorldTeleport("Mundo 2 (Namek)", CFrame.new(1500, 50, 0))
AddWorldFuture = AddWorldTeleport("Mundo 3 (Futuro)", CFrame.new(3000, 50, 0))

-- ==========================================
-- CONTEÚDO DA ABA: CONFIGURAÇÕES
-- ==========================================
CreateToggle(TabConfig, "Notificações na Tela", true, function(state)
    _G_Config.Notifications = state
end)

CreateButton(TabConfig, "Restaurar Configurações Padrão", function()
    _G_Config.AutoTrain = false
    _G_Config.AutoPrestige = false
    _G_Config.Notifications = true
    notify("Configurações", "Configurações restauradas para o padrão.")
end)

CreateButton(TabConfig, "Fechar Interface Completamente", function()
    ScreenGui:Destroy()
end)

-- Mensagem final de sucesso ao carregar o script no Delta Executor
notify("NEXOS HUB", "Carregado com sucesso no Delta Mobile!")
