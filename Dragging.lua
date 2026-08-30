-- ============================================
-- Dragging.lua - Sistema de arrasto universal
-- Versão: 1.0.0
-- ============================================

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Dragging = {}

-- ============ SISTEMA DE ARRASTO DE JANELA ============
function Dragging:EnableWindowDrag(frame, titleBar)
    local dragging = false
    local dragStartX = 0
    local dragStartY = 0
    local frameStartX = 0
    local frameStartY = 0
    
    -- Iniciar arrasto
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mouse = player:GetMouse()
            dragStartX = mouse.X
            dragStartY = mouse.Y
            frameStartX = frame.Position.X.Offset
            frameStartY = frame.Position.Y.Offset
        end
    end)
    
    -- Parar arrasto
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Mover janela
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local deltaX = mouse.X - dragStartX
            local deltaY = mouse.Y - dragStartY
            
            frame.Position = UDim2.new(
                0.5,
                frameStartX + deltaX,
                0.5,
                frameStartY + deltaY
            )
        end
    end)
    
    return {
        IsDragging = function()
            return dragging
        end
    }
end

-- ============ SISTEMA DE ARRASTO DE SLIDER ============
function Dragging:EnableSliderDrag(sliderBg, sliderFill, sliderButton, onChange, min, max)
    if not min then min = 0 end
    if not max then max = 100 end
    
    local dragging = false
    local currentValue = (min + max) / 2
    
    -- Atualizar visual do slider
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        
        local percent = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -10, 0, -7)
        
        if onChange then
            onChange(value)
        end
    end
    
    -- Iniciar arrasto
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    -- Parar arrasto
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Mover slider
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local framePos = sliderBg.AbsolutePosition.X
            local frameSize = sliderBg.AbsoluteSize.X
            
            if frameSize > 0 then
                local newPos = math.clamp((mouse.X - framePos) / frameSize, 0, 1)
                local value = math.floor(min + (newPos * (max - min)))
                updateSlider(value)
            end
        end
    end)
    
    -- Retornar métodos de controle
    return {
        SetValue = function(value)
            updateSlider(value)
        end,
        GetValue = function()
            return currentValue
        end,
        IsDragging = function()
            return dragging
        end
    }
end

-- ============ SISTEMA DE ARRASTO DE BOTÃO FLUTUANTE ============
function Dragging:EnableFloatingDrag(button)
    local dragging = false
    local dragStartX = 0
    local dragStartY = 0
    local buttonStartX = 0
    local buttonStartY = 0
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mouse = player:GetMouse()
            dragStartX = mouse.X
            dragStartY = mouse.Y
            buttonStartX = button.Position.X.Offset
            buttonStartY = button.Position.Y.Offset
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local deltaX = mouse.X - dragStartX
            local deltaY = mouse.Y - dragStartY
            
            button.Position = UDim2.new(
                0,
                math.clamp(buttonStartX + deltaX, 0, 500),
                0.5,
                math.clamp(buttonStartY + deltaY, -300, 300)
            )
        end
    end)
    
    return {
        IsDragging = function()
            return dragging
        end
    }
end

-- ============ FUNÇÃO DE UTILIDADE ============
function Dragging:IsMouseOver(guiObject)
    local mouse = player:GetMouse()
    local absPos = guiObject.AbsolutePosition
    local absSize = guiObject.AbsoluteSize
    
    return mouse.X >= absPos.X and 
           mouse.X <= absPos.X + absSize.X and
           mouse.Y >= absPos.Y and 
           mouse.Y <= absPos.Y + absSize.Y
end

-- ============ INICIALIZAR ============
function Dragging:Initialize()
    print("✓ Dragging system inicializado")
    return self
end

return Dragging
