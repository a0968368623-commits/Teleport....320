-- [[ 320 MASTER - PHANTOM RGB GHOST V6 ]]

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local PLS = game:GetService("Players")
local CG = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local Player = PLS.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = Workspace.CurrentCamera

local STATE = {
    Points = {},
    Visible = true,
    E_KeyEnabled = true,
    TargetPlayerName = "",
    GhostMode = false,
    GhostPart = nil,
    GhostLoop = nil
}

local function Teleport(cf)
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then 
        hrp.CFrame = cf + Vector3.new(0, 3, 0) 
    end
end

local function GetTargetPlayer(str)
    if str == "" then return nil end
    for _, p in pairs(PLS:GetPlayers()) do
        if p ~= Player and string.sub(string.lower(p.Name), 1, #str) == string.lower(str) then
            return p
        end
    end
    return nil
end

-- 隱身/幽靈觀戰核心邏輯 (H 鍵開關)
local function ToggleGhostMode()
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    STATE.GhostMode = not STATE.GhostMode

    if STATE.GhostMode then
        -- 啟動隱身：建立一個隱形方塊當作臨時靈魂核心
        local ghost = Instance.new("Part")
        ghost.Size = Vector3.new(1, 1, 1)
        ghost.Transparency = 1
        ghost.Anchored = true
        ghost.CanCollide = false
        ghost.CFrame = hrp.CFrame
        ghost.Parent = Workspace
        STATE.GhostPart = ghost
        
        Camera.CameraSubject = ghost

        -- 持續將肉體傳送到地底下，並把靈魂核心綁定在鍵盤控制上
        STATE.GhostLoop = RS.RenderStepped:Connect(function()
            if char and hrp and STATE.GhostPart then
                hrp.CFrame = CFrame.new(STATE.GhostPart.Position.X, -500, STATE.GhostPart.Position.Z)
                hrp.Velocity = Vector3.new(0,0,0)
                
                -- 讓玩家可以用 WASD 操控這個隱形核心移動
                local moveDir = hum.MoveDirection
                STATE.GhostPart.CFrame = STATE.GhostPart.CFrame + (moveDir * 1.5)
            end
        end)
    else
        -- 關閉隱身：肉體瞬間歸位到靈魂核心的位置
        if STATE.GhostLoop then STATE.GhostLoop:Disconnect(); STATE.GhostLoop = nil end
        if STATE.GhostPart then
            local finalCF = STATE.GhostPart.CFrame
            STATE.GhostPart:Destroy()
            STATE.GhostPart = nil
            
            Teleport(finalCF)
            Camera.CameraSubject = hum
        end
    end
end

local function EnableDrag(obj, parent)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local ID = "320_HUB_V6_RGB"
if CG:FindFirstChild(ID) then CG[ID]:Destroy() end
local Root = Instance.new("ScreenGui", CG); Root.Name = ID

local Main = Instance.new("Frame", Root)
Main.Size = UDim2.new(0, 360, 0, 560) -- 稍微加高 UI 容納新狀態
Main.Position = UDim2.new(0.5, -180, 0.5, -280)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.Visible = true
Instance.new("UICorner", Main)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local ToggleBtn = Instance.new("TextButton", Root)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
ToggleBtn.Text = "320"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn, {CornerRadius = UDim.new(1, 0)})
EnableDrag(ToggleBtn, ToggleBtn)

local BallStroke = Instance.new("UIStroke", ToggleBtn)
BallStroke.Thickness = 2

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", Header)
EnableDrag(Header, Main)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "320 PHANTOM GHOST"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -270)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = "Y"
Scroll.ScrollBarThickness = 3
local Layout = Instance.new("UIListLayout", Scroll); Layout.Padding = UDim.new(0, 5)

ToggleBtn.MouseButton1Click:Connect(function()
    STATE.Visible = not STATE.Visible
    Main.Visible = STATE.Visible
end)

local function TeleportToTarget()
    local tPlayer = GetTargetPlayer(STATE.TargetPlayerName)
    if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = tPlayer.Character.HumanoidRootPart
        local behindCF = targetHRP.CFrame * CFrame.new(0, 0, 3) 
        Teleport(behindCF)
    end
end

local ControlPanel = Instance.new("Frame", Main)
ControlPanel.Size = UDim2.new(1, -20, 0, 200)
ControlPanel.Position = UDim2.new(0, 10, 1, -210)
ControlPanel.BackgroundTransparency = 1

local E_Toggle = Instance.new("TextButton", ControlPanel)
E_Toggle.Size = UDim2.new(1, 0, 0, 40)
E_Toggle.Position = UDim2.new(0, 0, 0, 0)
E_Toggle.Text = "E Key Teleport: ON"
E_Toggle.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
E_Toggle.TextColor3 = Color3.new(1,1,1)
E_Toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", E_Toggle)

E_Toggle.MouseButton1Click:Connect(function()
    STATE.E_KeyEnabled = not STATE.E_KeyEnabled
    E_Toggle.Text = "E Key Teleport: " .. (STATE.E_KeyEnabled and "ON" or "OFF")
    E_Toggle.BackgroundColor3 = STATE.E_KeyEnabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 65)
end)

local PlayerInput = Instance.new("TextBox", ControlPanel)
PlayerInput.Size = UDim2.new(0.65, -5, 0, 40)
PlayerInput.Position = UDim2.new(0, 0, 0, 50)
PlayerInput.PlaceholderText = "Target Player Name..."
PlayerInput.Text = ""
PlayerInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
PlayerInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", PlayerInput)

PlayerInput:GetPropertyChangedSignal("Text"):Connect(function()
    STATE.TargetPlayerName = PlayerInput.Text
end)

local TrackBtn = Instance.new("TextButton", ControlPanel)
TrackBtn.Size = UDim2.new(0.35, 0, 0, 40)
TrackBtn.Position = UDim2.new(0.65, 0, 0, 50)
TrackBtn.Text = "TRACK"
TrackBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
TrackBtn.TextColor3 = Color3.new(1,1,1)
TrackBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TrackBtn)
TrackBtn.MouseButton1Click:Connect(TeleportToTarget)

local function RefreshList()
    for _, v in pairs(Scroll:GetChildren()) do 
        if v:IsA("Frame") then v:Destroy() end 
    end
    for i, p in pairs(STATE.Points) do
        local Item = Instance.new("Frame", Scroll)
        Item.Size = UDim2.new(1, -5, 0, 35)
        Item.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Instance.new("UICorner", Item)
        
        local Name = Instance.new("TextButton", Item)
        Name.Size = UDim2.new(0.75, 0, 1, 0)
        Name.Text = p.Name
        Name.TextColor3 = Color3.new(1,1,1)
        Name.BackgroundTransparency = 1
        Name.TextXAlignment = "Left"
        Name.Position = UDim2.new(0, 10, 0, 0)
        Name.MouseButton1Click:Connect(function() Teleport(p.CF) end)
        
        local Del = Instance.new("TextButton", Item)
        Del.Size = UDim2.new(0.2, 0, 1, 0)
        Del.Position = UDim2.new(0.8, 0, 0, 0)
        Del.Text = "[X]"
        Del.TextColor3 = Color3.fromRGB(255, 80, 80)
        Del.BackgroundTransparency = 1
        Del.MouseButton1Click:Connect(function() 
            table.remove(STATE.Points, i)
            RefreshList() 
        end)
    end
end

local SaveBox = Instance.new("TextBox", ControlPanel)
SaveBox.Size = UDim2.new(0.65, -5, 0, 40)
SaveBox.Position = UDim2.new(0, 0, 0, 100)
SaveBox.PlaceholderText = "Save Position Name..."
SaveBox.Text = ""
SaveBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SaveBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SaveBox)

local SaveBtn = Instance.new("TextButton", ControlPanel)
SaveBtn.Size = UDim2.new(0.35, 0, 0, 40)
SaveBtn.Position = UDim2.new(0.65, 0, 0, 100)
SaveBtn.Text = "SAVE"
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SaveBtn.TextColor3 = Color3.new(1,1,1)
SaveBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", SaveBtn)

SaveBtn.MouseButton1Click:Connect(function()
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and SaveBox.Text ~= "" then
        table.insert(STATE.Points, {Name = SaveBox.Text, CF = hrp.CFrame})
        SaveBox.Text = ""
        RefreshList()
    end
end)

-- 新增：UI 上的 Ghost 模式手動開關按框
local GhostToggleBtn = Instance.new("TextButton", ControlPanel)
GhostToggleBtn.Size = UDim2.new(1, 0, 0, 40)
GhostToggleBtn.Position = UDim2.new(0, 0, 0, 150)
GhostToggleBtn.Text = "Ghost Mode (H): OFF"
GhostToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
GhostToggleBtn.TextColor3 = Color3.new(1,1,1)
GhostToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GhostToggleBtn)

local function UpdateGhostUI()
    GhostToggleBtn.Text = "Ghost Mode (H): " .. (STATE.GhostMode and "ON" or "OFF")
    GhostToggleBtn.BackgroundColor3 = STATE.GhostMode and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 65)
end

GhostToggleBtn.MouseButton1Click:Connect(function()
    ToggleGhostMode()
    UpdateGhostUI()
end)

-- 鍵盤與滑鼠監聽
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.H then
        ToggleGhostMode()
        UpdateGhostUI()
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and STATE.E_KeyEnabled and input.KeyCode == Enum.KeyCode.E then
        TeleportToTarget()
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        Teleport(CFrame.new(Mouse.Hit.Position))
    end
end)

RS.RenderStepped:Connect(function()
    local hue = (tick() % 4) / 4
    local rgbColor = Color3.fromHSV(hue, 1, 1)
    MainStroke.Color = rgbColor
    BallStroke.Color = rgbColor
end)

print("320 PHANTOM GHOST V6 SUCCESS")
