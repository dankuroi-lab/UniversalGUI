-- ============================================
-- UniversalGUI Core
-- Biblioteca GUI modular e universal
-- Versão: 1.0.0
-- ============================================

local UniversalGUI = {
    Version = "1.0.0",
    Elements = {},
    Windows = {},
    ActiveWindow = nil,
}

-- ============ CONFIGURAÇÕES GLOBAIS ============
UniversalGUI.Config = {
    DefaultTheme = "Dark",
    DefaultSize = UDim2.fromOffset(400, 500),
    Draggable = true,
    Minimizable = true,
    Closable = true,
}

-- ============ CARREGAR MÓDULOS ============
local function loadModule(name)
    local url = "https://raw.githubusercontent.com/[seu-user]/UniversalGUI/main/lib/" .. name .. ".lua"
    local success, module = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success and module then
        return module
    else
        warn("Erro ao carregar módulo: " .. name)
        return nil
    end
end

-- Carregar módulos internos
UniversalGUI.Theme = loadModule("Theme")
UniversalGUI.Window = loadModule("Window")
UniversalGUI.Elements = loadModule("Elements")
UniversalGUI.Dragging = loadModule("Dragging")

-- ============ FUNÇÃO PRINCIPAL ============
function UniversalGUI:CreateWindow(options)
    options = options or {}
    
    local window = self.Window:new({
        Title = options.Title or "Window",
        Size = options.Size or self.Config.DefaultSize,
        Theme = options.Theme or self.Config.DefaultTheme,
        Draggable = options.Draggable ~= false,
        Minimizable = options.Minimizable ~= false,
        Closable = options.Closable ~= false,
        Parent = options.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
    })
    
    table.insert(self.Windows, window)
    self.ActiveWindow = window
    
    return window
end

-- ============ CRIAR BOTÃO FLUTUANTE ============
function UniversalGUI:CreateFloatingButton(options)
    options = options or {}
    
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "FloatingButton"
    gui.Parent = player:WaitForChild("PlayerGui")
    
    local btn = Instance.new("TextButton")
    btn.Size = options.Size or UDim2.new(0, 55, 0, 55)
    btn.Position = options.Position or UDim2.new(0, 20, 0.5, -27)
    btn.BackgroundColor3 = options.Color or Color3.fromRGB(100, 200, 255)
    btn.Text = options.Icon or "🚀"
    btn.TextSize = options.TextSize or 28
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 27)
    corner.Parent = btn
    
    -- Sombra
    if options.Shadow ~= false then
        local shadow = Instance.new("Frame")
        shadow.Size = btn.Size + UDim2.new(0, 5, 0, 5)
        shadow.Position = btn.Position - UDim2.new(0, 2, 0, 2)
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0.3
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 9
        shadow.Parent = gui
        
        local shadowCorner = Instance.new("UICorner")
        shadowCorner.CornerRadius = UDim.new(0, 30)
        shadowCorner.Parent = shadow
    end
    
    -- Click handler
    if options.OnClick then
        btn.MouseButton1Click:Connect(options.OnClick)
    end
    
    return btn
end

-- ============ MÉTODOS DE UTILIDADE ============
function UniversalGUI:GetScreenSize()
    return game:GetService("GuiService").ScreenSize
end

function UniversalGUI:CenterPosition(size)
    local screenSize = self:GetScreenSize()
    return UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
end

-- ============ INICIALIZAR ============
print("🔄 UniversalGUI v" .. self.Version .. " carregado!")
print("📖 Documentação: https://github.com/[seu-user]/UniversalGUI")

return UniversalGUI