-- ============================================
-- Jump Controller - Exemplo Completo
-- Usando a biblioteca UniversalGUI
-- Versão: 1.0.0
-- ============================================

local GithubUser = "SEU-USUARIO"  -- SUBSTITUA PELO SEU USUÁRIO

-- Carregar biblioteca
local UniversalGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/" .. GithubUser .. "/UniversalGUI/main/Main.lua"))()

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

-- ============ CRIAR JANELA ============
local window = UniversalGUI:CreateWindow({
    Title = "🚀 Jump Controller",
    Size = UDim2.fromOffset(400, 520),
    Theme = "Amethyst",
})

-- ============ ELEMENTOS ============
window:AddLabel({
    Text = "🎮 Controles do Jogador",
    Size = 18,
    Height = 30,
})

window:AddSeparator()

-- Slider de Pulo
local jumpSlider = window:AddSlider({
    Title = "⬆ Jump Height",
    Description = "Altura do pulo (10-300)",
    Min = 10,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(100, 200, 255),
    Callback = setJump,
})

-- Slider de Velocidade
local speedSlider = window:AddSlider({
    Title = "🏃 Walk Speed",
    Description = "Velocidade de movimento (10-100)",
    Min = 10,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 200, 100),
    Callback = setSpeed,
})

window:AddSeparator()

-- Presets
window:AddLabel({
    Text = "⚡ Presets Rápidos",
    Size = 14,
    Height = 25,
})

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
        jumpSlider:SetValue(50)
        speedSlider:SetValue(40)
    end,
})

window:AddButton({
    Text = "Super (150 / 60)",
    Color = Color3.fromRGB(100, 60, 80),
    Callback = function()
        setJump(150)
        setSpeed(60)
        jumpSlider:SetValue(150)
        speedSlider:SetValue(60)
    end,
})

window:AddSeparator()

-- Configurações
window:AddLabel({
    Text = "🛠️ Configurações",
    Size = 14,
    Height = 25,
})

-- Auto-Apply Toggle
window:AddToggle({
    Title = "Auto-Apply",
    Description = "Aplicar automaticamente ao respawn",
    Default = true,
    Callback = function(state)
        autoApply = state
    end,
})

-- Botão Reset
window:AddButton({
    Text = "🔄 Resetar Tudo",
    Color = Color3.fromRGB(200, 60, 60),
    Callback = function()
        setJump(50)
        setSpeed(16)
        jumpSlider:SetValue(50)
        speedSlider:SetValue(16)
    end,
})

-- ============ KEYBOARD SHORTCUTS ============
UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Up and input.KeyCode == Enum.KeyCode.LeftShift then
        setJump(math.min(jumpHeight + 10, 300))
        jumpSlider:SetValue(jumpHeight)
    elseif input.KeyCode == Enum.KeyCode.Down and input.KeyCode == Enum.KeyCode.LeftShift then
        setJump(math.max(jumpHeight - 10, 10))
        jumpSlider:SetValue(jumpHeight)
    elseif input.KeyCode == Enum.KeyCode.Right and input.KeyCode == Enum.KeyCode.LeftShift then
        setSpeed(math.min(walkSpeed + 5, 100))
        speedSlider:SetValue(walkSpeed)
    elseif input.KeyCode == Enum.KeyCode.Left and input.KeyCode == Enum.KeyCode.LeftShift then
        setSpeed(math.max(walkSpeed - 5, 10))
        speedSlider:SetValue(walkSpeed)
    elseif input.KeyCode == Enum.KeyCode.R then
        setJump(50)
        setSpeed(16)
        jumpSlider:SetValue(50)
        speedSlider:SetValue(16)
    elseif input.KeyCode == Enum.KeyCode.P then
        window:Toggle()
    end
end)

print("✅ Jump Controller carregado!")
print("📖 Atalhos:")
print("  Shift+↑ = +Pulo (10)")
print("  Shift+↓ = -Pulo (10)")
print("  Shift+→ = +Velocidade (5)")
print("  Shift+← = -Velocidade (5)")
print("  R = Resetar tudo")
print("  P = Abrir/Fechar GUI")
