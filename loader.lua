--[[ ==============================================
     H-ERMANOS STYLE  -  LOADER
     Ya apunta a tu repo nuevo. No toques nada.
     ============================================== ]]

local USUARIO = "recodeeemeee"
local REPO    = "hermanos-xeno"
local RAMA    = "main"
local ARCHIVO = "hermanos.lua"

local URLS = {
    "https://cdn.jsdelivr.net/gh/" .. USUARIO .. "/" .. REPO .. "@" .. RAMA .. "/" .. ARCHIVO,
    "https://raw.githubusercontent.com/" .. USUARIO .. "/" .. REPO .. "/" .. RAMA .. "/" .. ARCHIVO,
    "https://raw.githack.com/" .. USUARIO .. "/" .. REPO .. "/" .. RAMA .. "/" .. ARCHIVO,
}

--[[ ============================================== ]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "HermanosLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 400
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 330, 0, 140)
frame.Position = UDim2.new(0.5, -165, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local st = Instance.new("UIStroke", frame)
st.Color = Color3.fromRGB(0, 255, 200)
st.Thickness = 1.5

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 30)
titulo.Position = UDim2.new(0, 0, 0, 16)
titulo.BackgroundTransparency = 1
titulo.Text = "H-ERMANOS"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.TextSize = 22
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 44)
status.Position = UDim2.new(0, 10, 0, 48)
status.BackgroundTransparency = 1
status.Text = "iniciando..."
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextWrapped = true
status.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -40, 0, 26)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.BackgroundColor3 = Color3.fromRGB(0, 150, 125)
btn.Text = "REINTENTAR"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextSize = 12
btn.Font = Enum.Font.GothamBold
btn.Visible = false
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

local function carregar()
    btn.Visible = false
    local erros = {}

    for i, url in ipairs(URLS) do
        status.Text = "probando servidor " .. i .. "/" .. #URLS .. "..."
        status.TextColor3 = Color3.fromRGB(180, 180, 180)

        local ok, fonte = pcall(function()
            return game:HttpGet(url .. "?t=" .. os.time())
        end)

        if ok and type(fonte) == "string" and #fonte > 50
            and not fonte:find("404: Not Found") and not fonte:find("Page not found") then

            local fn, lerr = loadstring(fonte)
            if fn then
                status.Text = "ejecutando..."
                status.TextColor3 = Color3.fromRGB(0, 255, 140)
                task.wait(0.15)
                pcall(function() gui:Destroy() end)
                fn()
                return
            else
                table.insert(erros, "srv " .. i .. ": error de sintaxis")
            end
        else
            table.insert(erros, "srv " .. i .. ": no responde")
        end
    end

    status.Text = "ERROR - " .. table.concat(erros, "\n")
    status.TextColor3 = Color3.fromRGB(255, 110, 110)
    btn.Visible = true
end

btn.MouseButton1Click:Connect(function() task.spawn(carregar) end)
task.spawn(carregar)
