--[[ ==========================================================
     H-ERMANOS - LOADER (corregido)
     repo: recodeeemeee/hermanos-h-xeno2   archivo: odd
     Si renombras el archivo, solo cambia ARCHIVO.
     ========================================================== ]]

local USUARIO = "recodeeemeee"
local REPO    = "hermanos-h-xeno2"
local RAMA    = "main"
local ARCHIVO = "odd"          -- <-- sin extension, asi se llama tu archivo

local URLS = {
    "https://raw.githubusercontent.com/"..USUARIO.."/"..REPO.."/"..RAMA.."/"..ARCHIVO,
    "https://cdn.jsdelivr.net/gh/"..USUARIO.."/"..REPO.."@"..RAMA.."/"..ARCHIVO,
    "https://raw.githack.com/"..USUARIO.."/"..REPO.."/"..RAMA.."/"..ARCHIVO,
}

-- ===== UI =====
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "HermanosLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 400
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 330, 0, 150)
frame.Position = UDim2.new(0.5, -165, 0.5, -75)
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
titulo.Position = UDim2.new(0, 0, 0, 14)
titulo.BackgroundTransparency = 1
titulo.Text = "H-ERMANOS"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.TextSize = 22
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 58)
status.Position = UDim2.new(0, 10, 0, 46)
status.BackgroundTransparency = 1
status.Text = "iniciando..."
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextWrapped = true
status.TextYAlignment = Enum.TextYAlignment.Top
status.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -40, 0, 26)
btn.Position = UDim2.new(0, 20, 0, 112)
btn.BackgroundColor3 = Color3.fromRGB(0, 150, 125)
btn.Text = "REINTENTAR"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextSize = 12
btn.Font = Enum.Font.GothamBold
btn.Visible = false
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

-- ===== carga =====
local function motivoNoLua(txt)
    if type(txt) ~= "string" then return "sin respuesta" end
    if #txt < 40 then return "respuesta vacia" end
    local h = txt:sub(1, 300)
    if txt:find("404: Not Found",1,true) or txt:find("Page not found",1,true)
       or txt:find("Couldn't find",1,true) then return "404, el archivo no existe" end
    if h:find("<!DOCTYPE") or h:find("<html") then return "devolvio HTML, no Lua" end
    if h:match("^%s*{") then return "devolvio JSON, no Lua" end
    if txt:find("jsDelivr",1,true) or txt:find("throw new Error",1,true) then return "error de jsDelivr" end
    return nil
end

local function carregar()
    btn.Visible = false
    local erros = {}

    for i, url in ipairs(URLS) do
        status.Text = "probando servidor "..i.."/"..#URLS.."..."
        status.TextColor3 = Color3.fromRGB(180, 180, 180)

        local ok, fonte = pcall(function() return game:HttpGet(url .. "?t=" .. os.time()) end)

        if not ok then
            table.insert(erros, i..": no responde")
        else
            local bad = motivoNoLua(fonte)
            if bad then
                table.insert(erros, i..": "..bad)
            else
                local fn, lerr = loadstring(fonte)
                if fn then
                    status.Text = "ejecutando (srv "..i..")..."
                    status.TextColor3 = Color3.fromRGB(0, 255, 140)
                    task.wait(0.15)

                    local ok2, rerr = pcall(fn)
                    if ok2 then gui:Destroy() return
                    else table.insert(erros, i..": error al ejecutar: "..tostring(rerr)) end
                else
                    table.insert(erros, i..": sintaxis: "..tostring(lerr))
                end
            end
        end
    end

    status.Text = "ERROR\n"..table.concat(erros, "\n")
    status.TextColor3 = Color3.fromRGB(255, 110, 110)
    btn.Visible = true
end

btn.MouseButton1Click:Connect(function() task.spawn(carregar) end)
task.spawn(carregar)
