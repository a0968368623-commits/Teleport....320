-- [[ 320 MASTER - DIMENSION BREAKER ]]
local Services = setmetatable({}, {__index = function(_, k) return game:GetService(k) end})
local UIS, RS, PLS, CG = Services.UserInputService, Services.RunService, Services.Players, Services.CoreGui
local Player = PLS.LocalPlayer
local Mouse = Player:GetMouse()

-- 1. 核心傳送引擎
local TeleportEngine = {}
function TeleportEngine:MoveTo(pos)
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0)) end
end

-- 2. UI 構建
local UI_ID = "320_FINAL"
if CG:FindFirstChild(UI_ID) then CG[UI_ID]:Destroy() end
local Root = Instance.new("ScreenGui", CG); Root.Name = UI_ID
local Main = Instance.new("Frame", Root); Main.Size = UDim2.new(0, 350, 0, 400); Main.Position = UDim2.new(0.5, -175, 0.5, -200); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main)

-- 3. 拖拽條 (Header)
local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Header)
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "320 MASTER TP"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1

-- 拖拽邏輯
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- 4. 傳送按鈕
local Btn = Instance.new("TextButton", Main); Btn.Size = UDim2.new(0, 200, 0, 50); Btn.Position = UDim2.new(0.5, -100, 0.5, -25); Btn.Text = "Ctrl + Click to TP"; Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); Btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Btn)

-- Ctrl + Click 監控
UIS.InputBegan:Connect(function(i, gpe)
    if not gpe and i.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        TeleportEngine:MoveTo(Mouse.Hit.Position)
    end
end)
warn("320 MASTER LOADED!")
