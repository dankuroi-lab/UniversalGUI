-- ============================================
-- Jump Controller usando UniversalGUI
-- Exemplo completo de uso
-- ============================================

-- Carregar biblioteca
local UniversalGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/[seu-user]/UniversalGUI/main/lib/Core.lua"))()

-- ============ CRIAR JANELA ============
local window = UniversalGUI:CreateWindow({
    Title = "🚀 Jump Controller",
    Size = UDim2.fromOffset(400, 480),
    Theme = "Amethyst",
})

-- ============ VARIÁVEIS ============
local player = game.Players.LocalPlayer
local jumpHeight = 50
local walkSpeed = 16
local autoApply = true

-- ============ FUNÇÕES ============
local function setJump(value)
    value = math.floor(value)
    jumpHeight = value
    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.JumpHeight = value
        end
    end
end

local function setSpeed(value)
    value = math.floor(value)
    walkSpeed = value
    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = value
        end
    end
end

-- ============ AUTO APPLY ============
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    wait(0.3)
    if autoApply then
        hum.JumpHeight = jumpHeight
        hum.WalkSpeed = walkSpeed
    end
end)

-- ============ CRIAR ELEMENTOS ============
-- Label de título
window:AddLabel({
    Text = "🎮 Controles do Jogador",
    Size = 18,
    Height = 30,
})

window:AddSeparator()

-- Slider de Pulo
local jumpSlider = window:AddSlider({
    Title = "Jump Height",
    Description = "Altura do pulo (10-300)",
    Min = 10,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(100, 200, 255),
    Callback = setJump,
})

-- Slider de Velocidade
local speedSlider = window:AddSlider({
    Title = "Walk Speed",
    Description = "Velocidade de movimento (10-100)",
    Min = 10,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 200, 100),
    Callback = setSpeed,
})

window:AddSeparator()

-- Label de presets
window:AddLabel({
    Text = "⚡ Presets",
    Size = 14,
    Height = 25,
})

-- Botões de presets
window:AddButton({
    Text = "Normal (50 / 16)",
    Color = Color3.fromRGB(60, 60, 80),
    Callback = function()
        setJump(50)
        setSpeed(16)
        jumpSlider:SetValue(50)
        speedSlider:SetValue(16)
    end,
})

window:AddButton({
    Text = "Fast (50 / 40)",
    Color = Color3.fromRGB(80, 60, 100),
    Callback = function()
        setJump(50)
        setSpeed(40)
        jumpSlider:SetValue(