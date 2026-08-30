-- ============================================
-- Elements.lua - Elementos da interface
-- Versão: 1.0.0
-- ============================================

local Elements = {}

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ============ CRIAR BOTÃO ============
function Elements:CreateButton(parent, options)
    options = options or {}
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = options.Color or Color3.fromRGB(45, 45, 60)
    btn.Text = options.Text or "Button"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = options.TextSize or 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    -- Hover effect
    local defaultColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = defaultColor + Color3.fromRGB(15, 15, 15)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = defaultColor
    end)
    
    -- Click callback
    if options.Callback then
        btn.MouseButton1Click:Connect(options.Callback)
    end
    
    return btn
end

-- ============ CRIAR SLIDER ============
function Elements:CreateSlider(parent, options)
    options = options or {}
    
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or 50
    local value = default
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Title or "Slider"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    -- Value display
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Size = UDim2.new(0.3, 0, 0, 20)
    valueDisplay.Position = UDim2.new(0.7, 0, 0, 0)
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Text = tostring(value)
    valueDisplay.TextColor3 = options.Color or Color3.fromRGB(100, 200, 255)
    valueDisplay.TextSize = 16
    valueDisplay.Font = Enum.Font.GothamBold
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    valueDisplay.Parent = frame
    
    -- Description
    if options.Description then
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, 0, 0, 15)
        desc.Position = UDim2.new(0, 0, 0, 18)
        desc.BackgroundTransparency = 1
        desc.Text = options.Description
        desc.TextColor3 = Color3.fromRGB(150, 150, 170)
        desc.TextSize = 11
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = frame
    end
    
    -- Slider background
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0.7, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 3)
    bgCorner.Parent = sliderBg
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = options.Color or Color3.fromRGB(100, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    -- Slider button
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 20, 0, 20)
    button.Position = UDim2.new(0.5, -10, 0, -7)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = ""
    button.BorderSizePixel = 0
    button.Parent = sliderBg
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = button
    
    -- Dragging
    local dragging = false
    
    button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local framePos = sliderBg.AbsolutePosition.X
            local frameSize = sliderBg.AbsoluteSize.X
            
            if frameSize > 0 then
                local newPos = math.clamp((mouse.X - framePos) / frameSize, 0, 1)
                value = math.floor(min + (newPos * (max - min)))
                
                fill.Size = UDim2.new(newPos, 0, 1, 0)
                button.Position = UDim2.new(newPos, -10, 0, -7)
                valueDisplay.Text = tostring(value)
                
                if options.Callback then
                    options.Callback(value)
                end
            end
        end
    end)
    
    -- Inicializar com valor padrão
    local initialPos = (default - min) / (max - min)
    fill.Size = UDim2.new(initialPos, 0, 1, 0)
    button.Position = UDim2.new(initialPos, -10, 0, -7)
    valueDisplay.Text = tostring(default)
    
    return {
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            local pos = (value - min) / (max - min)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            button.Position = UDim2.new(pos, -10, 0, -7)
            valueDisplay.Text = tostring(value)
        end,
        GetValue = function()
            return value
        end
    }
end

-- ============ CRIAR TOGGLE ============
function Elements:CreateToggle(parent, options)
    options = options or {}
    
    local state = options.Default or false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Title or "Toggle"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    -- Description
    if options.Description then
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(0.7, 0, 0, 15)
        desc.Position = UDim2.new(0, 0, 0, 15)
        desc.BackgroundTransparency = 1
        desc.Text = options.Description
        desc.TextColor3 = Color3.fromRGB(150, 150, 170)
        desc.TextSize = 11
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = frame
    end
    
    -- Toggle button
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -55, 0, 2)
    btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(60, 60, 80)
    btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(60, 60, 80)
        btn.Text = state and "ON" or "OFF"
        
        if options.Callback then
            options.Callback(state)
        end
    end)
    
    return {
        SetState = function(newState)
            state = newState
            btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(60, 60, 80)
            btn.Text = state and "ON" or "OFF"
        end,
        GetState = function()
            return state
        end
    }
end

-- ============ CRIAR LABEL ============
function Elements:CreateLabel(parent, options)
    options = options or {}
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, options.Height or 25)
    label.BackgroundTransparency = 1
    label.Text = options.Text or "Label"
    label.TextColor3 = options.Color or Color3.fromRGB(255, 255, 255)
    label.TextSize = options.Size or 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = options.Alignment or Enum.TextXAlignment.Left
    label.Parent = parent
    
    return label
end

-- ============ CRIAR SEPARADOR ============
function Elements:CreateSeparator(parent)
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -10, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sep.BorderSizePixel = 0
    sep.Parent = parent
    
    return sep
end

return Elements