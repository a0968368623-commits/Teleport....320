-- [[ 320 MASTER - TELEPORT HUB PRO ]]
-- 功能：Ctrl+點擊傳送、座標存取、介面收納、雙重移動系統

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local PLS = game:GetService("Players")
local CG = game:GetService("CoreGui")

local Player = PLS.LocalPlayer
local Mouse = Player:GetMouse()

local STATE = {
    Points = {},
    Visible = true
}

-- [ 1. 核心傳送函數 ]
local function Teleport(cf)
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf + Vector3.new(0, 3, 0) end
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
local ID = "320_HUB"
if CG:FindFirstChild(ID) then CG[ID]:Destroy() end
local Root = Instance.new("ScreenGui", CG); Root.Name = ID

-- 主介面
local Main = Instance.new("Frame", Root)
Main.Size = UDim2.new(0, 350, 0, 450); Main.Position = UDim2.new(0.5, -175, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Main.Visible = true; Instance.new("UICorner", Main)

-- 收納小按鈕 (小浮球)
local ToggleBtn = Instance.new("TextButton", Root)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); ToggleBtn.Text = "320"; ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", ToggleBtn, {CornerRadius = UDim.new(1, 0)})
EnableDrag(ToggleBtn, ToggleBtn) -- 小按鈕也可移動

-- 標題列 (主介面拖拽)
local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Instance.new("UICorner", Header); EnableDrag(Header, Main)

local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "320 TELEPORT HUB"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1

-- 列表容器
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -110); Scroll.Position = UDim2.new(0, 10, 0, 60); Scroll.BackgroundTransparency = 1; Scroll.AutomaticCanvasSize = "Y"
local Layout = Instance.new("UIListLayout", Scroll); Layout.Padding = UDim.new(0, 5)

-- [ 4. 功能邏輯 ]
-- 收納切換
ToggleBtn.MouseButton1Click:Connect(function()
    STATE.Visible = not STATE.Visible
    Main.Visible = STATE.Visible
end)

-- 儲存當前位置
local function RefreshList()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for i, p in pairs(STATE.Points) do
        local Item = Instance.new("Frame", Scroll)
        Item.Size = UDim2.new(1, -5, 0, 40); Item.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Instance.new("UICorner", Item)
        
        local Name = Instance.new("TextButton", Item)
        Name.Size = UDim2.new(0.7, 0, 1, 0); Name.Text = p.Name; Name.TextColor3 = Color3.new(1,1,1); Name.BackgroundTransparency = 1
        Name.MouseButton1Click:Connect(function() Teleport(p.CF) end)
        
        local Del = Instance.new("TextButton", Item)
        Del.Size = UDim2.new(0.3, 0, 1, 0); Del.Position = UDim2.new(0.7, 0, 0, 0); Del.Text = "DEL"; Del.TextColor3 = Color3.new(1,0.3,0.3); Del.BackgroundTransparency = 1
        Del.MouseButton1Click:Connect(function() table.remove(STATE.Points, i); RefreshList() end)
    end
end

local SaveBox = Instance.new("TextBox", Main)
SaveBox.Size = UDim2.new(0.6, 0, 0, 40); SaveBox.Position = UDim2.new(0, 10, 1, -45); SaveBox.PlaceholderText = "Point Name..."; SaveBox.Text = ""
Instance.new("UICorner", SaveBox)

local SaveBtn = Instance.new("TextButton", Main)
SaveBtn.Size = UDim2.new(0.3, 0, 0, 40); SaveBtn.Position = UDim2.new(0.65, 0, 1, -45); SaveBtn.Text = "SAVE"; SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
Instance.new("UICorner", SaveBtn)

SaveBtn.MouseButton1Click:Connect(function()
    if Player.Character and SaveBox.Text ~= "" then
        table.insert(STATE.Points, {Name = SaveBox.Text, CF = Player.Character.HumanoidRootPart.CFrame})
        SaveBox.Text = ""; RefreshList()
    end
end)

-- [ 5. Ctrl + 點擊傳送 ]
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        Teleport(Mouse.Hit)
    end
end)

warn("320 HUB PRO LOADED - CTRL+CLICK TO TP")
