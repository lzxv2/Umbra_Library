--[[
    Umbra UI Library - Fluent Inspired
    Mantains the original dark aesthetic with Fluent UI improvements
    Features:
    - Preserves the original Umbra dark theme essence
    - Adds Fluent UI animations and interactions
    - Improved component structure
    - Better theming system
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Umbra = {
    Themes = {
        Original = {
            Background = Color3.fromRGB(11, 15, 15),
            Primary = Color3.fromRGB(255, 0, 0),  -- Mantém o vermelho característico
            Secondary = Color3.fromRGB(20, 25, 25),
            Text = Color3.fromRGB(240, 240, 240),
            Border = Color3.fromRGB(255, 0, 0),   -- Bordas vermelhas como no original
            Accent = Color3.fromRGB(255, 40, 40)  -- Vermelho mais claro para highlights
        },
        Dark = {
            Background = Color3.fromRGB(11, 15, 15),
            Primary = Color3.fromRGB(0, 120, 215),  -- Azul Fluent
            Secondary = Color3.fromRGB(20, 25, 25),
            Text = Color3.fromRGB(240, 240, 240),
            Border = Color3.fromRGB(50, 50, 50),
            Accent = Color3.fromRGB(0, 153, 255)
        },
        Custom = function(colors)
            return colors
        end
    },
    _currentTheme = "Original",  -- Tema original como padrão
    _components = {}
}

-- Utility functions with original Umbra feel
local function createUmbraRipple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "UmbraRipple"
    ripple.BackgroundColor3 = Umbra.Themes[Umbra._currentTheme].Primary
    ripple.BackgroundTransparency = 0.7
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = -1
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    return ripple
end

-- Main Window component (preserves original draggable behavior)
function Umbra.CreateWindow(options)
    options = options or {}
    local config = {
        Title = options.Title or "Umbra UI",
        Size = options.Size or UDim2.new(0, 600, 0, 400),
        Position = options.Position or UDim2.new(0.5, -300, 0.5, -200),
        Theme = options.Theme or "Original",
        Logo = options.Logo or nil,
        BorderColor = options.BorderColor or Umbra.Themes.Original.Border
    }

    Umbra._currentTheme = config.Theme
    local theme = Umbra.Themes[Umbra._currentTheme]

    -- Main container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UmbraUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = config.Size
    mainWindow.Position = config.Position
    mainWindow.BackgroundColor3 = theme.Background
    mainWindow.Active = true
    mainWindow.Selectable = true
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui

    -- Original Umbra border styling
    local border = Instance.new("UIStroke")
    border.Name = "UmbraBorder"
    border.Color = config.BorderColor
    border.Thickness = 2
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Parent = mainWindow

    local corner = Instance.new("UICorner")
    corner.Name = "WindowCorner"
    corner.CornerRadius = UDim.new(0, 12)  -- Mantém os cantos arredondados originais
    corner.Parent = mainWindow

    -- Title bar (original draggable behavior)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainWindow

    -- Logo (if provided)
    if config.Logo then
        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2.new(0, 60, 0, 60)
        logo.Position = UDim2.new(0, 10, 0, -10)
        logo.BackgroundTransparency = 1
        logo.Image = "rbxassetid://" .. tostring(config.Logo)
        logo.Parent = titleBar
    end

    -- Title text with Fluent-inspired typography
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Text = config.Title
    titleText.Font = Enum.Font.GothamSemibold  -- Fonte moderna como no Fluent
    titleText.TextSize = 18
    titleText.TextColor3 = theme.Text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 80, 0, 0)
    titleText.Parent = titleBar

    -- Original draggable behavior
    local dragging = false
    local dragInput, dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainWindow.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainWindow.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Content container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 1, -40)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.Parent = mainWindow

    -- Add Fluent-style close button (optional)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.TextColor3 = theme.Text
    closeButton.BackgroundTransparency = 1
    closeButton.Size = UDim2.new(0, 40, 1, 0)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.Parent = titleBar

    -- Hover effect for close button
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            TextColor3 = theme.Primary
        }):Play()
    end)

    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {
            TextColor3 = theme.Text
        }):Play()
    end)

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Return the window API
    local windowAPI = {
        ScreenGui = screenGui,
        MainWindow = mainWindow,
        Content = content
    }

    function windowAPI:SetTheme(themeName)
        Umbra._currentTheme = themeName or "Original"
        applyTheme(mainWindow, "Window")
        applyTheme(titleText, "Text")
        applyTheme(closeButton, "Text")
        border.Color = Umbra.Themes[Umbra._currentTheme].Border
    end

    return windowAPI
end

-- Fluent-style button with Umbra's original color scheme
function Umbra.CreateButton(parent, options)
    options = options or {}
    local config = {
        Text = options.Text or "Button",
        Size = options.Size or UDim2.new(0, 120, 0, 40),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        Callback = options.Callback or function() end
    }

    local theme = Umbra.Themes[Umbra._currentTheme]

    local button = Instance.new("TextButton")
    button.Name = "UmbraButton"
    button.Text = config.Text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextColor3 = theme.Text
    button.BackgroundColor3 = theme.Primary  -- Mantém o vermelho do original
    button.Size = config.Size
    button.Position = config.Position
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)  -- Cantos menos arredondados como no Fluent
    corner.Parent = button

    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = theme.Border
    buttonBorder.Thickness = 1
    buttonBorder.Parent = button

    -- Fluent-style hover animation
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.Accent,
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.Primary,
            TextColor3 = theme.Text
        }):Play()
    end)

    -- Ripple effect with original Umbra colors
    button.MouseButton1Down:Connect(function(x, y)
        local ripple = createUmbraRipple(button)
        ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
        
        TweenService:Create(ripple, TweenInfo.new(0.6), {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1
        }):Play()
        
        wait(0.6)
        ripple:Destroy()
    end)

    button.MouseButton1Click:Connect(function()
        config.Callback()
    end)

    return button
end

return Umbra
