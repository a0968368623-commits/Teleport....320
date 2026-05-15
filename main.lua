-- [[ 320 MASTER - DIMENSION BREAKER ]]
-- VERSION: 3.0 (HYPER-TELEPORT FOCUS)

local Services = setmetatable({}, {__index = function(_, k) return game:GetService(k) end})
local UIS, RS, PLS, CG = Services.UserInputService, Services.RunService, Services.Players, Services.CoreGui
local Player = PLS.LocalPlayer
local Mouse = Player:GetMouse()

-- [[ 1. 次元傳送引擎 ]]
local TeleportEngine = {}

-- 核心傳送函數：具備防卡死與安全高度校正
function TeleportEngine:MoveTo(pos)
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- 預判安全高度，避免卡進地板
        local targetCF = CFrame.new(pos + Vector3.new(0, 5, 0)) 
        hrp.CFrame = targetCF
        print("Dimension Jump Success: ", pos)
    end
end

-- [[ 2. UI 界面 - 傳送控制中心 ]]
local UI_ID = "320_TELEPORT_MASTER"
if CG:FindFirstChild(UI_ID) then CG[UI_ID]:Destroy() end

local Root = Instance.new("ScreenGui", CG); Root.Name = UI_ID
local Main = Instance.new("Frame", Root)
Main.Size = UDim2.new(0, 380, 0, 520)
Main.Position = UDim2.new(0.5, -190, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", Main)

-- 霓虹流水邊框
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 3
RS.RenderStepped:Connect(function() Stroke.Color = Color3.fromHSV((tick()*0.3)%1, 0.8, 1) end)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60); Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "320 TELEPORT MASTER"; Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 20; Title.BackgroundTransparency = 1

-- 拖拽功能
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- [[ 3. 強大的傳送功能按鈕 ]]
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -80); Scroll.Position = UDim2.new(0, 10, 0, 75)
Scroll.BackgroundTransparency = 1; Scroll.AutomaticCanvasSize = "Y"
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

local function AddControl(text, color, func)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -10, 0, 50); btn.Text = text; btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 18
    Instance.new("UICorner", btn); btn.MouseButton1Click:Connect(func)
end

-- 功能 A: 鼠標懸浮傳送 (極速模式)
AddControl("⚡ Mouse Click TP (Ctrl+LClick)", Color3.fromRGB(255, 100, 0), function()
    print("Mode Active: Hold Ctrl and Click to blink.")
end)

-- 功能 B: 傳送到隨機玩家 (找人神器)
AddControl("👥 Teleport to Random Player", Color3.fromRGB(0, 150, 255), function()
    local players = PLS:GetPlayers()
    local randomPlayer = players[math.random(1, #players)]
    if randomPlayer and randomPlayer ~= Player and randomPlayer.Character then
        TeleportEngine:MoveTo(randomPlayer.Character.HumanoidRootPart.Position)
    end
end)

-- 功能 C: 輸入精確座標 (X, Y, Z)
local CoordInput = Instance.new("TextBox", Scroll)
CoordInput.Size = UDim2.new(1, -10, 0, 50); CoordInput.PlaceholderText = "Input: X, Y, Z"; CoordInput.Text = ""
CoordInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45); CoordInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CoordInput)

AddControl("🌀 Teleport to Coordinates", Color3.fromRGB(100, 0, 255), function()
    local coords = {}
    for word in string.gmatch(CoordInput.Text, '([^,]+)') do table.insert(coords, tonumber(word)) end
    if #coords >= 3 then
        TeleportEngine:MoveTo(Vector3.new(coords[1], coords[2], coords[3]))
    end
end)

-- [[ 4. 鼠標點擊監聽 ]]
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        TeleportEngine:MoveTo(Mouse.Hit.Position)
    end
end)

warn("320 DIMENSION BREAKER LOADED.")
