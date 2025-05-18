-- Umbra UI - Maru Hub Style
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Umbra = {
    Themes = {
        Dark = {
            Background = Color3.fromRGB(20, 20, 25),
            Navbar = Color3.fromRGB(15, 15, 20),
            Primary = Color3.fromRGB(255, 50, 50),  -- Vermelho estilo Maru
            Secondary = Color3.fromRGB(30, 30, 35),
            Text = Color3.fromRGB(240, 240, 240),
            Border = Color3.fromRGB(255, 60, 60)
        }
    },
    _currentTheme = "Dark"
}

-- Função para criar efeito de hover
local function createHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Umbra.Themes.Dark.Primary
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Umbra.Themes.Dark.Navbar
        }):Play()
    end)
end

function Umbra.CreateWindow(config)
    config = config or {}
    
    -- Criação da janela principal
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Navbar = Instance.new("Frame")
    local Logo = Instance.new("ImageLabel")
    local NavbarList = Instance.new("ScrollingFrame")
    local ContentFrame = Instance.new("Frame")
    local UIStroke = Instance.new("UIStroke")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Name = "UmbraUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Frame principal
    MainFrame.Name = "MainFrame"
    MainFrame.Size = config.Size or UDim2.new(0, 600, 0, 400)
    MainFrame.Position = config.Position or UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Umbra.Themes.Dark.Background
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Borda e cantos arredondados
    UIStroke.Color = Umbra.Themes.Dark.Border
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = MainFrame

    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Barra de navegação (estilo Maru Hub)
    Navbar.Name = "Navbar"
    Navbar.Size = UDim2.new(1, 0, 0, 40)
    Navbar.Position = UDim2.new(0, 0, 0, 0)
    Navbar.BackgroundColor3 = Umbra.Themes.Dark.Navbar
    Navbar.Parent = MainFrame

    -- Logo na navbar
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 120, 0, 30)
    Logo.Position = UDim2.new(0, 10, 0.5, -15)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://"..tostring(config.LogoId or 71213772696056)
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.Parent = Navbar

    -- Lista de navegação horizontal
    NavbarList.Name = "NavbarList"
    NavbarList.Size = UDim2.new(1, -140, 1, 0)
    NavbarList.Position = UDim2.new(0, 140, 0, 0)
    NavbarList.BackgroundTransparency = 1
    NavbarList.ScrollBarThickness = 0
    NavbarList.ScrollingDirection = Enum.ScrollingDirection.X
    NavbarList.AutomaticCanvasSize = Enum.AutomaticSize.X
    NavbarList.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavbarList.Parent = Navbar

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = NavbarList

    -- Área de conteúdo
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Função para adicionar abas
    local tabs = {}
    function tabs:AddTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName.."Tab"
        TabButton.Size = UDim2.new(0, 80, 1, 0)
        TabButton.BackgroundColor3 = Umbra.Themes.Dark.Navbar
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = 13
        TabButton.TextColor3 = Umbra.Themes.Dark.Text
        TabButton.AutoButtonColor = false
        TabButton.Parent = NavbarList

        createHoverEffect(TabButton)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName.."Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Umbra.Themes.Dark.Primary
        TabContent.Parent = ContentFrame

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 5)
        UIListLayout.Parent = TabContent

        TabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(ContentFrame:GetChildren()) do
                if content:IsA("ScrollingFrame") then
                    content.Visible = false
                end
            end
            TabContent.Visible = true
        end)

        return TabContent
    end

    -- Torna a primeira aba visível por padrão
    spawn(function()
        wait()
        local firstTab = ContentFrame:FindFirstChildOfClass("ScrollingFrame")
        if firstTab then
            firstTab.Visible = true
        end
    end)

    -- Função para criar botões
    function tabs:CreateButton(parent, config)
        config = config or {}
        
        local Button = Instance.new("TextButton")
        Button.Name = config.Text or "Button"
        Button.Size = config.Size or UDim2.new(1, -20, 0, 35)
        Button.Position = config.Position or UDim2.new(0, 10, 0, 0)
        Button.BackgroundColor3 = Umbra.Themes.Dark.Secondary
        Button.Text = config.Text or "Button"
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 13
        Button.TextColor3 = Umbra.Themes.Dark.Text
        Button.AutoButtonColor = false
        Button.Parent = parent

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Button

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Umbra.Themes.Dark.Border
        UIStroke.Thickness = 1
        UIStroke.Parent = Button

        createHoverEffect(Button)

        Button.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback()
            end
        end)

        return Button
    end

    return tabs
end

return Umbra
