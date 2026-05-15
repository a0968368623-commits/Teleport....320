--[[
    320 MASTER - STABLE PRIME
    -----------------------------------------------------------------------
    穩定性：★★★★★ | 資源佔用：低 | 兼容性：全環境 (PC/Mobile)
    核心功能：完美拖拽、安全傳送、座標管理
    -----------------------------------------------------------------------
]]

-- [ 1. 精簡核心服務 ]
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local PLS = game:GetService("Players")
local CG = game:GetService("CoreGui")

local Player = PLS.LocalPlayer
local Mouse = Player:GetMouse()

-- [ 2. 穩定版配置 ]
local CONFIG = {
    ID = "320_STABLE_V1",
    Theme = Color3.fromRGB(0, 255, 140),
    BG = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(30, 30, 30)
}

local DATABASE = { Points = {}, IsOpen = true }

-- [ 3. 核心：全兼容萬能拖拽引擎 ]
-- 解決你說 UI 不能移動的問題，這段代碼手寫了輸入監聽，絕對能動。
local function MakeDraggable(frame, parent)
    local dragging, dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ 4. 安全傳送邏輯 ]
local function Teleport(pos)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- [ 5. UI 構建：極簡穩定架構 ]
if CG:FindFirstChild(CONFIG.ID) then CG[CONFIG.ID]:Destroy() end
local Root = Instance.new("ScreenGui", CG); Root.Name = CONFIG.ID

local Main = Instance.new("Frame", Root)
Main.Size = UDim2.new(0, 400, 0, 500)
Main.Position = UDim2.new(0.5, -200, 0.5, -250)
Main.BackgroundColor3 = CONFIG.BG
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- 拖拽條 (標題列)
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundColor3 = CONFIG.Accent
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar)
MakeDraggable(TitleBar, Main) -- 啟動穩定拖拽

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -20, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "320 MASTER STABLE"; Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 24; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

-- RGB 邊框 (保持帥氣但穩定)
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 3
RS.RenderStepped:Connect(function() Stroke.Color = Color3.fromHSV((tick()*0.2)%1, 0.7, 1) end)

-- [ 6. 操作區 ]
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -40, 1, -80); Content.Position = UDim2.new(0, 20, 0, 70); Content.BackgroundTransparency = 1
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 10)

local Input = Instance.new("TextBox", Content)
Input.Size = UDim2.new(1, 0, 0, 50); Input.PlaceholderText = "座標名稱..."; Input.BackgroundColor3 = CONFIG.Accent
Input.TextColor3 = Color3.new(1,1,1); Input.Font = Enum.Font.Gotham; Input.TextSize = 18; Instance.new("UICorner", Input)

local AddBtn = Instance.new("TextButton", Content)
AddBtn.Size = UDim2.new(1, 0, 0, 50); AddBtn.Text = "保存當前座標"; AddBtn.BackgroundColor3 = CONFIG.Theme
AddBtn.Font = Enum.Font.GothamBold; AddBtn.TextSize = 20; Instance.new("UICorner", AddBtn)

-- 滾動列表
local Scroll = Instance.new("ScrollingFrame", Content)
Scroll.Size = UDim2.new(1, 0, 1, -120); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 5
Scroll.AutomaticCanvasSize = "Y"
local SLayout = Instance.new("UIListLayout", Scroll); SLayout.Padding = UDim.new(0, 8)

-- [ 7. 功能邏輯 ]
local function Refresh()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for i, data in ipairs(DATABASE.Points) do
        local Card = Instance.new("Frame", Scroll)
        Card.Size = UDim2.new(1, -10, 0, 60); Card.BackgroundColor3 = CONFIG.Accent; Instance.new("UICorner", Card)
        
        local TBtn = Instance.new("TextButton", Card)
        TBtn.Size = UDim2.new(1, -80, 1, 0); TBtn.Position = UDim2.new(0, 15, 0, 0); TBtn.BackgroundTransparency = 1
        TBtn.Text = data.Name; TBtn.TextColor3 = Color3.new(1,1,1); TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 18; TBtn.TextXAlignment = "Left"
        TBtn.MouseButton1Click:Connect(function() Teleport(data.Pos) end)
        
        local Del = Instance.new("TextButton", Card)
        Del.Size = UDim2.new(0, 60, 0, 40); Del.Position = UDim2.new(1, -70, 0.5, -20); Del.Text = "X"
        Del.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Del.Font = Enum.Font.GothamBold; Instance.new("UICorner", Del)
        Del.MouseButton1Click:Connect(function() table.remove(DATABASE.Points, i); Refresh() end)
    end
end

AddBtn.MouseButton1Click:Connect(function()
    if Input.Text ~= "" and Player.Character then
        table.insert(DATABASE.Points, {Name = Input.Text, Pos = Player.Character.HumanoidRootPart.Position})
        Input.Text = ""; Refresh()
    end
end)

-- [ 8. 迷你隱藏按鈕 (同樣具備穩定拖拽) ]
local Mini = Instance.new("TextButton", Root)
Mini.Size = UDim2.new(0, 70, 0, 70); Mini.Position = UDim2.new(0, 20, 0, 20); Mini.BackgroundColor3 = CONFIG.BG
Mini.Text = "320"; Mini.TextColor3 = Color3.new(1,1,1); Mini.Visible = false
Instance.new("UICorner", Mini).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", Mini).Color = CONFIG.Theme
MakeDraggable(Mini, Mini) -- 小按鈕也可以動

local function Toggle()
    DATABASE.IsOpen = not DATABASE.IsOpen
    Main.Visible = DATABASE.IsOpen
    Mini.Visible = not DATABASE.IsOpen
end

Mini.MouseButton1Click:Connect(Toggle)
local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.new(0, 40, 0, 40); Close.Position = UDim2.new(1, -50, 0, 10); Close.Text = "×"; Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.GothamBold; Close.TextSize = 30; Close.MouseButton1Click:Connect(Toggle)

-- [ 9. Ctrl 傳送快捷鍵 ]
UIS.InputBegan:Connect(function(i, gpe)
    if not gpe and i.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        Teleport(Mouse.Hit.Position)
    end
end)

warn("320 STABLE PRIME: READY.")
Refresh()
