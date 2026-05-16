-- [[ 320 MASTER - TELEPORT HUB PHANTOM ]]
-- 功能：Ctrl+點擊傳送、座標存取、指定玩家背刺、按 F 閃現、UI與小球可移動

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local PLS = game:GetService("Players")
local CG = game:GetService("CoreGui")

local Player = PLS.LocalPlayer
local Mouse = Player:GetMouse()

local STATE = {
    Points = {},
    Visible = true,
    F_KeyEnabled = true,   -- F 鍵功能的開關狀態
    TargetPlayerName = ""   -- 鎖定的目標玩家名字
}

-- [ 1. 核心傳送函數 ]
local function Teleport(cf)
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then 
        hrp.CFrame = cf + Vector3.new(0, 3, 0) 
    end
end

-- 尋找目標玩家（支援部分名字輸入）
local function GetTargetPlayer(str)
    if str == "" then return nil end
    for _, p in pairs(PLS:GetPlayers()) do
        if p ~= Player and string.sub(string.lower(p.Name), 1, #str) == string.lower(str) then
            return p
        end
    end
    return nil
end

-- [ 2. 萬能拖拽函數 ]
local function EnableDrag(obj, parent)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = parent.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- [ 3. UI 構建 ]
local ID = "320_HUB_PHANTOM"
if CG:FindFirstChild(ID) then CG[ID]:Destroy() end
local Root = Instance.new("ScreenGui", CG); Root.Name = ID

-- 主介面
local Main = Instance.new("Frame", Root)
Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Main.Visible = true; Instance.new("UICorner", Main)

-- 收納小按鈕 (小浮球)
local ToggleBtn = Instance.new("TextButton", Root)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55); ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 100); ToggleBtn.Text = "320"; ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn, {CornerRadius = UDim.new(1, 0)})
EnableDrag(ToggleBtn, ToggleBtn) -- 小按鈕也可移動

-- 標題列
local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", Header); EnableDrag(Header, Main)

local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "320 PHANTOM TP"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold

-- 內容滾動區
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -230); Scroll.Position = UDim2.new(0, 10, 0, 60); Scroll.BackgroundTransparency = 1; Scroll.AutomaticCanvasSize = "Y"
Scroll.ScrollBarThickness = 3
local Layout = Instance.new("UIListLayout", Scroll); Layout.Padding = UDim.new(0, 5)

-- [ 收納切換 ]
ToggleBtn.MouseButton1Click:Connect(function()
    STATE.Visible = not STATE.Visible
    Main.Visible = STATE.Visible
end)

-- [ 4. 幽靈追蹤功能區 ]
local ControlPanel = Instance.new("Frame", Main)
ControlPanel.Size = UDim2.new(1, -20, 0, 150); ControlPanel.Position = UDim2.new(0, 10, 1, -160); ControlPanel.BackgroundTransparency = 1

-- F鍵開關按鈕
local F_Toggle = Instance.new("TextButton", ControlPanel)
F_Toggle.Size = UDim2.new(1, 0, 0, 40); F_Toggle.Position = UDim2.new(0, 0, 0, 0)
F_Toggle.Text = "F Key Teleport: ON"; F_Toggle.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
F_Toggle.TextColor3 = Color3.new(1,1,1); F_Toggle.Font = Enum.Font.GothamBold; Instance.new("UICorner", F_Toggle)

F_Toggle.MouseButton1Click:Connect(function()
    STATE.F_KeyEnabled = not STATE.F_KeyEnabled
    F_Toggle.Text = "F Key Teleport: " .. (STATE.F_KeyEnabled and "ON" or "OFF")
    F_Toggle.BackgroundColor3 = STATE.F_KeyEnabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 65)
end)

-- 玩家名字輸入框
local PlayerInput = Instance.new("TextBox", ControlPanel)
PlayerInput.Size = UDim2.new(0.65, -5, 0, 40); PlayerInput.Position = UDim2.new(0, 0, 0, 50)
PlayerInput.PlaceholderText = "Target Player Name..."; PlayerInput.Text = ""
PlayerInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40); PlayerInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", PlayerInput)

PlayerInput:GetPropertiesChangedSignal("Text"):Connect(function()
    STATE.TargetPlayerName = PlayerInput.Text
end)

-- 一鍵直接追蹤按鈕
local TrackBtn = Instance.new("TextButton", ControlPanel)
TrackBtn.Size = UDim2.new(0.35, 0, 0, 40); TrackBtn.Position = UDim2.new(0.65, 0, 0, 50)
TrackBtn.Text = "TRACK"; TrackBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
TrackBtn.TextColor3 = Color3.new(1,1,1); TrackBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", TrackBtn)

local function TeleportToTarget()
    local tPlayer = GetTargetPlayer(STATE.TargetPlayerName)
    if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- 傳送到目標背後（減去 LookVector 的 3 個單位距離）
        local targetHRP = tPlayer.Character.HumanoidRootPart
        local behindCF = targetHRP.CFrame * CFrame.new(0, 0, 3) 
        Teleport(behindCF)
        print("Blinked behind " .. tPlayer.Name)
    else
        -- 如果沒指定人或找不到，按 F 改為朝鼠標方向閃現
        Teleport(CFrame.new(Mouse.Hit.Position))
    end
end

TrackBtn.MouseButton1Click:Connect(TeleportToTarget)

-- [ 5. 座標儲存區 ]
local function RefreshList()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for i, p in pairs(STATE.Points) do
        local Item = Instance.new("Frame", Scroll)
        Item.Size = UDim2.new(1, -5, 0, 35); Item.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Instance.new("UICorner", Item)
        local Name = Instance.new("TextButton", Item)
        Name.Size = UDim2.new(0.75, 0, 1, 0); Name.Text = p.Name; Name.TextColor3 = Color3.new(1,1,1); Name.BackgroundTransparency = 1; Name.TextXAlignment = "Left"; Name.Position = UDim2.new(0,10,0,0)
        Name.MouseButton1Click:Connect(function() Teleport(p.CF) end)
        local Del = Instance.new("TextButton", Item)
        Del.Size = UDim2.new(0.2, 0, 1, 0); Del.Position = UDim2.new(0.8, 0, 0, 0); Del.Text = "[X]"; Del.TextColor3 = Color3.fromRGB(255, 80, 80); Del.BackgroundTransparency = 1
        Del.MouseButton1Click:Connect(function() table.remove(STATE.Points, i); RefreshList() end)
    end
end

local SaveBox = Instance.new("TextBox", ControlPanel)
SaveBox.Size = UDim2.new(0.65, -5, 0, 40); SaveBox.Position = UDim2.new(0, 0, 0, 100)
SaveBox.PlaceholderText = "Save Position Name..."; SaveBox.Text = ""
SaveBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40); SaveBox.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SaveBox)

local SaveBtn = Instance.new("TextButton", ControlPanel)
SaveBtn.Size = UDim2.new(0.35, 0, 0, 40); SaveBtn.Position = UDim2.new(0.65, 0, 0, 100)
SaveBtn.Text = "SAVE"; SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SaveBtn.TextColor3 = Color3.new(1,1,1); SaveBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", SaveBtn)

SaveBtn.MouseButton1Click:Connect(function()
    if Player.Character and SaveBox.Text ~= "" then
        table.insert(STATE.Points, {Name = SaveBox.Text, CF = Player.Character.HumanoidRootPart.CFrame})
        SaveBox.Text = ""; RefreshList()
    end
end)

-- [ 6. 鍵盤與滑鼠監聽系統 ]
-- F 鍵傳送
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and STATE.F_KeyEnabled and input.KeyCode == Enum.KeyCode.F then
        TeleportToTarget()
    end
end)

-- Ctrl + 點擊傳送
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        Teleport(CFrame.new(Mouse.Hit.Position))
    end
end)

warn("320 PHANTOM DEPLOYED - PRESS F TO BLINK")
