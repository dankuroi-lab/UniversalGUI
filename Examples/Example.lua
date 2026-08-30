-- ============================================
-- Exemplo Básico de Uso da UniversalGUI
-- ============================================

local GithubUser = "SEU-USUARIO"  -- SUBSTITUA

-- Carregar biblioteca
local UniversalGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/" .. GithubUser .. "/UniversalGUI/main/Main.lua"))()

-- ============ CRIAR JANELA ============
local window = UniversalGUI:CreateWindow({
    Title = "🚀 Exemplo UniversalGUI",
    Size = UDim2.fromOffset(400, 400),
    Theme = "Amethyst",  -- Dark, Light, Neon, Amethyst
})

-- ============ ADICIONAR ELEMENTOS ============
window:AddLabel({
    Text = "🎯 Bem-vindo!",
    Size = 20,
    Height = 35,
})

window:AddLabel({
    Text = "Esta é uma GUI de exemplo usando UniversalGUI",
    Size = 13,
    Height = 25,
    Color = Color3.fromRGB(150, 150, 170),
})

window:AddSeparator()

window:AddLabel({
    Text = "📝 Elementos Disponíveis:",
    Size = 14,
    Height = 25,
})

-- Botão
window:AddButton({
    Text = "Clique em mim!",
    Color = Color3.fromRGB(60, 150, 200),
    Callback = function()
        print("✅ Botão clicado!")
    end,
})

-- Slider
local slider = window:AddSlider({
    Title = "Slider Exemplo",
    Description = "Arraste para ajustar",
    Min = 0,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(100, 200, 255),
    Callback = function(value)
        print("📊 Slider: " .. value)
    end,
})

-- Toggle
window:AddToggle({
    Title = "Toggle Exemplo",
    Description = "Liga/Desliga",
    Default = true,
    Callback = function(state)
        print("🔄 Toggle: " .. tostring(state))
    end,
})

window:AddSeparator()

-- Botão Reset
window:AddButton({
    Text = "🔄 Resetar Slider",
    Color = Color3.fromRGB(60, 60, 80),
    Callback = function()
        slider:SetValue(50)
    end,
})

print("✅ Exemplo carregado com sucesso!")
