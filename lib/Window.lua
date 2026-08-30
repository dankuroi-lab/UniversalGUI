-- ============================================
-- Window.lua - Sistema de janelas
-- Versão: 1.0.0
-- ============================================

local Window = {}
Window.__index = Window

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ============ CRIAR NOVA JANELA ============
function Window:new(options)
    local self = setmetatable({}, Window)
    
    self.Title = options.Title or "Window"
    self.Size = options.Size or UDim2.fromOffset(400, 500)
    self.Theme = options.Theme or "Dark"
    self.Draggable = options.Draggable ~= false
    self.Minimizable = options.Minimizable ~= false
    self.Closable = options.Closable ~= false
    self.Parent = options.Parent or player:WaitForChild("PlayerGui")
    self.IsOpen = true
    self.IsMinimized = false
    self.Elements = {}
    
    -- Obter tema
    local Theme = _G.UniversalGUI and _G.UniversalGUI.Theme or nil
    if Theme then
        self.Colors = Theme.Get(self.Theme)
    else
        self.Colors = {
            Background = Color3.fromRGB(25, 25, 35),
            TitleBar = Color3.fromRGB(35, 35, 50),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(150, 150, 170),
            Button = Color3.fromRGB(45, 45, 60),
            ButtonHover = Color3.fromRGB(65, 65, 80),
            Accent = Color3.fromRGB(100, 200, 255),
            Separator = Color3.fromRGB(60, 60, 80),
        }
    end
    
    -- Criar GUI
    self:CreateGUI()
    
    -- Configurar dragging
    if self.Draggable then
        self:SetupDragging()
    end
    
    -- Configurar controles
    self:SetupControls()
    
    return self
end

-- ============ CRIAR GUI DA JANELA ============
function Window:CreateGUI()
    -- ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "Window_" .. self.Title:gsub(" ", "_")
    self.Gui.Parent = self.Parent
    
    -- Frame principal
    self.Frame = Instance.new("Frame")
    self.Frame.Size = self.Size
    self.Frame.Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2)
    self.Frame.BackgroundColor3 = self.Colors.Background
    self.Frame.BackgroundTransparency = 0.1
    self.Frame.BorderSizePixel = 0
    self.Frame.ClipsDescendants = true
    self.Frame.Parent = self.Gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.Frame
    
    -- Barra de título
    self:CreateTitleBar()
    
    -- Container de conteúdo
    self.Container = Instance.new("Frame")
    self.Container.Size = UDim2.new(1, 0, 1, -45)
    self.Container.Position = UDim2.new(0, 0, 0, 45)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Frame
    
    -- ScrollView para elementos
    self.ScrollView = Instance.new("ScrollingFrame")
    self.ScrollView.Size = UDim2.new(1, -10, 1, -10)
    self.ScrollView.Position = UDim2.new(0, 5, 0, 5)
    self.ScrollView.BackgroundTransparency = 1
    self.ScrollView.BorderSizePixel = 0
    self.ScrollView.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ScrollView.ScrollBarThickness = 6
    self.ScrollView.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
    self.ScrollView.Parent = self.Container
    
    -- Layout para elementos
    self.Layout = Instance.new("UIListLayout")
    self.Layout.Padding = UDim.new(0, 5)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Parent = self.ScrollView
    
    -- Atualizar layout quando elementos mudarem
    self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ScrollView.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 10)
    end)
end

-- ============ CRIAR BARRA DE TÍTULO ============
function Window:CreateTitleBar()
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = self.Colors.TitleBar
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = self.Frame
    self.TitleBar = titleBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = titleBar
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = self.Colors.Text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    self.TitleLabel = title
    
    -- Botão minimizar
    if self.Minimizable then
        local minBtn = Instance.new("TextButton")
        minBtn.Size = UDim2.new(0, 30, 0, 30)
        minBtn.Position = UDim2.new(1, -70, 0, 7)
        minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        minBtn.Text = "−"
        minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        minBtn.TextSize = 20
        minBtn.Font = Enum.Font.GothamBold
        minBtn.BorderSizePixel = 0
        minBtn.Parent = titleBar
        self.MinimizeButton = minBtn
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = minBtn
    end
    
    -- Botão fechar
    if self.Closable then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 7)
        closeBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 16
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = titleBar
        self.CloseButton = closeBtn
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = closeBtn
    end
end

-- ============ CONFIGURAR DRAGGING ============
function Window:SetupDragging()
    local dragging = false
    local dragStartX, dragStartY, frameStartX, frameStartY
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mouse = player:GetMouse()
            dragStartX = mouse.X
            dragStartY = mouse.Y
            frameStartX = self.Frame.Position.X.Offset
            frameStartY = self.Frame.Position.Y.Offset
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
            self.Frame.Position = UDim2.new(
                0.5,
                frameStartX + (mouse.X - dragStartX),
                0.5,
                frameStartY + (mouse.Y - dragStartY)
            )
        end
    end)
end

-- ============ CONFIGURAR CONTROLES ============
function Window:SetupControls()
    -- Minimizar
    if self.MinimizeButton then
        self.MinimizeButton.MouseButton1Click:Connect(function()
            self:Minimize()
        end)
    end
    
    -- Fechar
    if self.CloseButton then
        self.CloseButton.MouseButton1Click:Connect(function()
            self:Close()
        end)
    end
end

-- ============ MÉTODOS DA JANELA ============
function Window:Minimize()
    self.IsMinimized = not self.IsMinimized
    self.Frame.Visible = not self.IsMinimized
    self.IsOpen = not self.IsMinimized
end

function Window:Close()
    self.IsOpen = false
    self.Frame.Visible = false
end

function Window:Open()
    self.IsOpen = true
    self.IsMinimized = false
    self.Frame.Visible = true
end

function Window:Toggle()
    if self.IsOpen then
        self:Close()
    else
        self:Open()
    end
end

function Window:SetTitle(title)
    self.Title = title
    if self.TitleLabel then
        self.TitleLabel.Text = title
    end
end

function Window:SetSize(size)
    self.Size = size
    self.Frame.Size = size
end

function Window:SetPosition(pos)
    self.Frame.Position = pos
end

-- ============ ADICIONAR ELEMENTOS ============
function Window:AddButton(options)
    local Elements = _G.UniversalGUI and _G.UniversalGUI.Elements or nil
    if Elements then
        return Elements:CreateButton(self.ScrollView, options)
    end
    return nil
end

function Window:AddSlider(options)
    local Elements = _G.UniversalGUI and _G.UniversalGUI.Elements or nil
    if Elements then
        return Elements:CreateSlider(self.ScrollView, options)
    end
    return nil
end

function Window:AddToggle(options)
    local Elements = _G.UniversalGUI and _G.UniversalGUI.Elements or nil
    if Elements then
        return Elements:CreateToggle(self.ScrollView, options)
    end
    return nil
end

function Window:AddLabel(options)
    local Elements = _G.UniversalGUI and _G.UniversalGUI.Elements or nil
    if Elements then
        return Elements:CreateLabel(self.ScrollView, options)
    end
    return nil
end

function Window:AddSeparator()
    local Elements = _G.UniversalGUI and _G.UniversalGUI.Elements or nil
    if Elements then
        return Elements:CreateSeparator(self.ScrollView)
    end
    return nil
end

return Window