-- ============================================
-- Theme.lua - Temas e estilos
-- ============================================

local Theme = {}

-- ============ TEMAS DISPONÍVEIS ============
Theme.Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 35),
        BackgroundTransparency = 0.1,
        TitleBar = Color3.fromRGB(35, 35, 50),
        TitleBarTransparency = 0.3,
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 170),
        Button = Color3.fromRGB(45, 45, 60),
        ButtonHover = Color3.fromRGB(65, 65, 80),
        ButtonText = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(100, 200, 255),
        Success = Color3.fromRGB(60, 200, 100),
        Danger = Color3.fromRGB(200, 60, 60),
        SliderBg = Color3.fromRGB(45, 45, 60),
        Separator = Color3.fromRGB(60, 60, 80),
    },
    
    Light = {
        Background = Color3.fromRGB(240, 240, 250),
        BackgroundTransparency = 0.05,
        TitleBar = Color3.fromRGB(220, 220, 235),
        TitleBarTransparency = 0.3,
        Text = Color3.fromRGB(30, 30, 50),
        SubText = Color3.fromRGB(100, 100, 130),
        Button = Color3.fromRGB(220, 220, 235),
        ButtonHover = Color3.fromRGB(200, 200, 215),
        ButtonText = Color3.fromRGB(30, 30, 50),
        Accent = Color3.fromRGB(80, 180, 255),
        Success = Color3.fromRGB(60, 200, 100),
        Danger = Color3.fromRGB(200, 60, 60),
        SliderBg = Color3.fromRGB(200, 200, 215),
        Separator = Color3.fromRGB(200, 200, 210),
    },
    
    Neon = {
        Background = Color3.fromRGB(10, 10, 20),
        BackgroundTransparency = 0.1,
        TitleBar = Color3.fromRGB(20, 20, 40),
        TitleBarTransparency = 0.2,
        Text = Color3.fromRGB(0, 255, 255),
        SubText = Color3.fromRGB(150, 150, 200),
        Button = Color3.fromRGB(30, 30, 60),
        ButtonHover = Color3.fromRGB(50, 50, 80),
        ButtonText = Color3.fromRGB(0, 255, 255),
        Accent = Color3.fromRGB(255, 0, 255),
        Success = Color3.fromRGB(0, 255, 100),
        Danger = Color3.fromRGB(255, 0, 50),
        SliderBg = Color3.fromRGB(30, 30, 60),
        Separator = Color3.fromRGB(40, 40, 70),
    },
    
    Amethyst = {
        Background = Color3.fromRGB(20, 15, 30),
        BackgroundTransparency = 0.1,
        TitleBar = Color3.fromRGB(40, 30, 55),
        TitleBarTransparency = 0.3,
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 150, 200),
        Button = Color3.fromRGB(50, 40, 70),
        ButtonHover = Color3.fromRGB(70, 60, 90),
        ButtonText = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(180, 100, 255),
        Success = Color3.fromRGB(100, 200, 100),
        Danger = Color3.fromRGB(200, 60, 60),
        SliderBg = Color3.fromRGB(50, 40, 70),
        Separator = Color3.fromRGB(60, 50, 80),
    },
}

-- ============ OBTER TEMA ============
function Theme.Get(name)
    return Theme.Themes[name] or Theme.Themes.Dark
end

-- ============ CRIAR TEMA PERSONALIZADO ============
function Theme.Create(name, colors)
    Theme.Themes[name] = colors
    return colors
end

return Theme