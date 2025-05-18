local Umbra = {}

function Umbra.Create()
    local self = {}

    function self:Window(config)
        local ScreenGui = Instance.new("ScreenGui")
        local Window = Instance.new("Frame")
        local Image = Instance.new("ImageLabel")
        local Border = Instance.new("UIStroke")
        local Corner = Instance.new("UICorner")

        Window.Size = UDim2.new(0, 600, 0, 400)
        Window.BackgroundColor3 = Color3.fromRGB(11, 15, 15)
        Window.Parent = game.CoreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        Window.Active = true
        Window.Draggable = true

        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = Window

        Border.Color3 = config.BorderColor or Color3.fromRGB(255, 0, 0)
        Border.Parent = Window

        local TopBar = Instance.new("Frame")
        TopBar.Parent = Window

        Image.Parent = TopBar
        Image.Position = UDim2.new(0, 20, 0.128, 0)
        Image.Image = "rbxassetid://" .. tostring(config.LogoId)

        return Window
    end

    return self
end

return Umbra
