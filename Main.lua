-- ============================================
-- UniversalGUI - Script Principal
-- Versão: 1.0.0
-- ============================================

local GithubUser = "SEU-USUARIO"  -- SUBSTITUA PELO SEU USUÁRIO
local Repo = "UniversalGUI"
local Branch = "main"

-- ============ URLS DOS MÓDULOS ============
local function getUrl(path)
    return "https://raw.githubusercontent.com/" .. GithubUser .. "/" .. Repo .. "/" .. Branch .. "/" .. path
end

-- ============ FUNÇÃO PARA CARREGAR ============
local function loadModule(path)
    local url = getUrl(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success and result then
        return result
    else
        warn("❌ Erro ao carregar: " .. path)
        return nil
    end
end

-- ============ CARREGAR BIBLIOTECA ============
print("🔄 Carregando UniversalGUI...")

-- Carregar módulos
local Core = loadModule("lib/Core.lua")
if not Core then
    error("❌ Falha ao carregar Core.lua")
end

-- Carregar todos os módulos
Core.Window = loadModule("lib/Window.lua")
Core.Elements = loadModule("lib/Elements.lua")
Core.Dragging = loadModule("lib/Dragging.lua")
Core.Theme = loadModule("lib/Theme.lua")

-- Verificar se todos carregaram
if not Core.Window or not Core.Elements or not Core.Dragging or not Core.Theme then
    warn("⚠️ Alguns módulos não carregaram corretamente")
end

-- ============ EXPORTAR ============
_G.UniversalGUI = Core

print("✅ UniversalGUI v" .. (Core.Version or "1.0.0") .. " carregado com sucesso!")
print("📖 Usuário: " .. GithubUser)
print("💡 Use: local GUI = loadstring(game:HttpGet('" .. getUrl("Main.lua") .. "'))()")

return Core