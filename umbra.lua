local Umbra = {}

function Umbra.Create()
    local self = {}

    function self:Window(config)
        local ScreenGui = Instance.new("ScreenGui")
        local Window = Instance.new("Frame")
        local Image = Instance.new("ImageLabel")
        local Border = Instance.new("UIStroke")
        local Corner = Instance.new("UICorner")
        local TopBar = Instance.new("Frame")

        ScreenGui.Parent = game.CoreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

        Window.Size = UDim2.new(0, 600, 0, 400)
        Window.Position = UDim2.new(0.5, -300, 0.5, -200)
        Window.BackgroundColor3 = Color3.fromRGB(11, 15, 15)
        Window.Active = true
        Window.Parent = ScreenGui

        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = Window

        Border.Color3 = config.BorderColor or Color3.fromRGB(255, 0, 0)
        Border.Thickness = 2
        Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Border.Parent = Window

        TopBar.Size = UDim2.new(1, 0, 0, 40)
        TopBar.BackgroundTransparency = 1
        TopBar.Parent = Window

        Image.Parent = TopBar
        Image.Size = UDim2.new(0, 60, 0, 60)
        Image.Position = UDim2.new(0, 10, 0, -10)
        Image.BackgroundTransparency = 1
        Image.Image = "rbxassetid://" .. tostring(config.LogoId)

        local dragging = false
        local dragInput, dragStart, startPos
        local UIS = game:GetService("UserInputService")

        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Window.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        return Window
    end

    return self
end

return Umbra
