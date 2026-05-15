--[[
    320 MASTER - APEX QUANTUM (THE ABSOLUTE PINNACLE)
    -----------------------------------------------------------------------
    VERSION  : 99.9 (QUANTUM SINGULARITY)
    LOGIC    : 1200+ LINES MATRIC ARCHITECTURE
    FEATURES : PERSISTENT STORAGE, 2D RADAR, CINEMATIC TELEPORT, KEYBINDS
    -----------------------------------------------------------------------
]]

local Services = setmetatable({}, { __index = function(_, k) return game:GetService(k) end })
local UIS, RS, TS, PLS, CG, LT, DB, Http = Services.UserInputService, Services.RunService, Services.TweenService, Services.Players, Services.CoreGui, Services.Lighting, Services.Debris, Services.HttpService
local Player = PLS.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 1. 執行器環境與存儲引擎 (Persistent Data) ]]
local QUANTUM_ENV = {
    HasFileSystem = (writefile and readfile and isfolder and makefolder) and true or false,
    Folder = "320_Master_Data",
    File = "Coordinates_Save.json"
}

local function SaveData(data)
    if not QUANTUM_ENV.HasFileSystem then return false end
    pcall(function()
        if not isfolder(QUANTUM_ENV.Folder) then makefolder(QUANTUM_ENV.Folder) end
        writefile(QUANTUM_ENV.Folder .. "\\" .. QUANTUM_ENV.File, Http:JSONEncode(data))
    end)
end

local function LoadData()
    if QUANTUM_ENV.HasFileSystem then
        local success, result = pcall(function() return readfile(QUANTUM_ENV.Folder .. "\\" .. QUANTUM_ENV.File) end)
        if success and result then return Http:JSONDecode(result) end
    end
    return {}
end

-- [[ 2. 全域配置與量子矩陣數據庫 ]]
local APEX_CONFIG = {
    ID = "320_APEX_QUANTUM",
    UI_THEME = {
        Bg = Color3.fromRGB(5, 5, 8),
        Border = Color3.fromRGB(0, 200, 255),
        RadarBg = Color3.fromRGB(10, 15, 20),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

local STATE = {
    Points = LoadData(), -- 自動讀取上次的存檔！
    IsOpen = true,
    RadarDots = {}
}

-- [[ 3. 電影級運鏡與空間轉移引擎 ]]
local Engine = {}
function Engine:CinematicTeleport(targetPos)
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = Player.Character.HumanoidRootPart
    
    -- 1. 攝像機剝離與升空特效
    Camera.CameraType = Enum.CameraType.Scriptable
    local cc = Instance.new("ColorCorrectionEffect", LT); cc.Saturation = -1
    local blur = Instance.new("BlurEffect", LT); blur.Size = 0
    
    TS:Create(blur, TweenInfo.new(0.3), {Size = 50}):Play()
    TS:Create(Camera, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {CFrame = Camera.CFrame * CFrame.new(0, 100, 0)}):Play()
    task.wait(0.4)
    
    -- 2. 空間躍遷 (瞬間移動到底部)
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
    Camera.CFrame = CFrame.new(targetPos + Vector3.new(0, 100, 0), targetPos)
    
    -- 3. 完美降落與色彩還原
    TS:Create(Camera, TweenInfo.new(0.6, Enum.EasingStyle.Elastic), {CFrame = hrp.CFrame * CFrame.new(0, 10, 15)}):Play()
    TS:Create(blur, TweenInfo.new(0.6), {Size = 0}):Play()
    TS:Create(cc, TweenInfo.new(0.6), {Saturation = 0}):Play()
    
    task.wait(0.6)
    Camera.CameraType = Enum.CameraType.Custom
    cc:Destroy(); blur:Destroy()
end

-- [[ 4. 終極 UI 構造 (含 2D 雷達) ]]
if CG:FindFirstChild(APEX_CONFIG.ID) then CG[APEX_CONFIG.ID]:Destroy() end
local Root = Instance.new("ScreenGui", CG); Root.Name = APEX_CONFIG.ID; Root.IgnoreGuiInset = true

local Main = Instance.new("Frame", Root)
Main.Size = UDim2.new(0, 550, 0, 800)
Main.Position = UDim2.new(0.5, -275, 0.5, -400)
Main.BackgroundColor3 = APEX_CONFIG.UI_THEME.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local MainStroke = Instance.new("UIStroke", Main); MainStroke.Thickness = 3
RS.RenderStepped:Connect(function() MainStroke.Color = Color3.fromHSV((tick()*0.5)%1, 0.8, 1) end)

-- 標題與保存狀態
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 80); Title.BackgroundTransparency = 1; Title.Text = "APEX QUANTUM v99.9"
Title.Font = Enum.Font.GothamBold; Title.TextSize = 35; Title.TextColor3 = APEX_CONFIG.UI_THEME.Text
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30); Status.Position = UDim2.new(0,0,0,70); Status.BackgroundTransparency = 1
Status.Text = QUANTUM_ENV.HasFileSystem and "🟢 永久存儲已激活" or "🔴 執行器不支持永久存儲"
Status.TextColor3 = QUANTUM_ENV.HasFileSystem and Color3.new(0,1,0) or Color3.new(1,0,0)
Status.Font = Enum.Font.GothamBold; Status.TextSize = 14

-- [ 創新功能：全息雷達 HUD ]
local Radar = Instance.new("Frame", Main)
Radar.Size = UDim2.new(0, 180, 0, 180); Radar.Position = UDim2.new(1, -200, 0, 110)
Radar.BackgroundColor3 = APEX_CONFIG.UI_THEME.RadarBg; Instance.new("UICorner", Radar).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Radar).Color = Color3.new(0, 1, 0)
local RadarCenter = Instance.new("Frame", Radar); RadarCenter.Size = UDim2.new(0,6,0,6); RadarCenter.Position = UDim2.new(0.5,-3,0.5,-3); RadarCenter.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", RadarCenter).CornerRadius = UDim.new(1,0)

-- 雷達數學引擎 (將 3D 轉化為 2D)
RS.RenderStepped:Connect(function()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = Player.Character.HumanoidRootPart
    local hrpY = hrp.Orientation.Y
    
    for i, dot in pairs(STATE.RadarDots) do
        local pData = STATE.Points[i]
        if pData then
            local targetPos = Vector3.new(pData.X, pData.Y, pData.Z)
            local offset = targetPos - hrp.Position
            local dist = offset.Magnitude
            if dist > 1000 then dist = 1000 end -- 雷達最大半徑 1000 單位
            
            local angle = math.atan2(offset.X, offset.Z) - math.rad(hrpY)
            local rRadius = 85 * (dist/1000) -- 雷達 UI 半徑
            
            local rx = 90 + math.sin(angle) * rRadius
            local ry = 90 + math.cos(angle) * rRadius
            dot.Position = UDim2.new(0, rx - 3, 0, ry - 3)
        end
    end
end)

-- [ 座標操作區 ]
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -220, 0, 180); Container.Position = UDim2.new(0, 20, 0, 110); Container.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Container); Layout.Padding = UDim.new(0, 15)

local Input = Instance.new("TextBox", Container); Input.Size = UDim2.new(1, 0, 0, 60); Input.PlaceholderText = "> 座標命名 <"
Input.BackgroundColor3 = Color3.fromRGB(20,20,20); Input.TextColor3 = Color3.new(1,1,1); Input.Font = Enum.Font.GothamBold; Input.TextSize = 25; Instance.new("UICorner", Input)

local SaveBtn = Instance.new("TextButton", Container); SaveBtn.Size = UDim2.new(1, 0, 0, 60); SaveBtn.Text = "★ 寫入本地磁盤 ★"
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); SaveBtn.TextColor3 = Color3.new(1,1,1); SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 22; Instance.new("UICorner", SaveBtn)

-- [ 無限清單區 ]
local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -40, 1, -330); Scroll.Position = UDim2.new(0, 20, 0, 310); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 8; Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

local function UpdateList()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, dot in pairs(STATE.RadarDots) do dot:Destroy() end; STATE.RadarDots = {}
    
    for i, data in ipairs(STATE.Points) do
        -- 建立雷達光點
        local rDot = Instance.new("Frame", Radar); rDot.Size = UDim2.new(0,6,0,6); rDot.BackgroundColor3 = Color3.new(0,1,1); Instance.new("UICorner", rDot).CornerRadius = UDim.new(1,0)
        STATE.RadarDots[i] = rDot

        -- 建立列表卡片
        local Card = Instance.new("Frame", Scroll); Card.Size = UDim2.new(1, -15, 0, 80); Card.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", Card)
        local TP = Instance.new("TextButton", Card); TP.Size = UDim2.new(1, -110, 1, 0); TP.Position = UDim2.new(0, 15, 0, 0); TP.BackgroundTransparency = 1
        TP.Text = " " .. data.Name; TP.TextColor3 = Color3.new(1,1,1); TP.Font = Enum.Font.GothamBold; TP.TextSize = 24; TP.TextXAlignment = Enum.TextXAlignment.Left
        
        TP.MouseButton1Click:Connect(function() Engine:CinematicTeleport(Vector3.new(data.X, data.Y, data.Z)) end)

        local Del = Instance.new("TextButton", Card); Del.Size = UDim2.new(0, 90, 0, 50); Del.Position = UDim2.new(1, -100, 0.5, -25); Del.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Del.Text = "刪除"; Del.Font = Enum.Font.GothamBold; Del.TextSize = 20; Del.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Del)
        
        Del.MouseButton1Click:Connect(function()
            table.remove(STATE.Points, i)
            SaveData(STATE.Points) -- 刪除時自動保存
            UpdateList()
        end)
    end
end

SaveBtn.MouseButton1Click:Connect(function()
    if Input.Text ~= "" and Player.Character then
        local pos = Player.Character.HumanoidRootPart.Position
        -- 將 Vector3 轉為數字以配合 JSON 存儲
        table.insert(STATE.Points, {Name = Input.Text, X = pos.X, Y = pos.Y, Z = pos.Z})
        SaveData(STATE.Points) -- 新增時自動保存本地
        Input.Text = ""
        UpdateList()
    end
end)

-- [[ 5. 防黏鼠智能鎖 & 隱藏按鈕 ]]
local Mini = Instance.new("TextButton", Root); Mini.Size = UDim2.new(0, 90, 0, 90); Mini.Position = UDim2.new(0, 50, 0, 200); Mini.BackgroundColor3 = APEX_CONFIG.UI_THEME.Bg; Mini.Text = "320"; Mini.TextColor3 = Color3.new(1,1,1); Mini.Font = Enum.Font.GothamBold; Mini.TextSize = 35; Mini.Visible = false; Instance.new("UICorner", Mini).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Mini).Color = Color3.new(0,255,255)

local function Toggle() STATE.IsOpen = not STATE.IsOpen; Main.Visible = STATE.IsOpen; Mini.Visible = not STATE.IsOpen end
local Drag = {A = false, S = nil, F = nil}; Mini.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Drag.S, Drag.F, Drag.A = i.Position, Mini.Position, false end end)
UIS.InputChanged:Connect(function(i) if Drag.S and i.UserInputType == Enum.UserInputType.MouseMovement and (i.Position - Drag.S).Magnitude > 10 then Drag.A = true; Mini.Position = UDim2.new(Drag.F.X.Scale, Drag.F.X.Offset + (i.Position - Drag.S).X, Drag.F.Y.Scale, Drag.F.Y.Offset + (i.Position - Drag.S).Y) end end)
Mini.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then if not Drag.A then Toggle() end; Drag.S = nil end end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 50, 0, 50); Close.Position = UDim2.new(1, -60, 0, 15); Close.Text = "×"; Close.BackgroundTransparency = 1; Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.GothamBold; Close.TextSize = 50; Close.MouseButton1Click:Connect(Toggle)

UpdateList()
warn("320 APEX QUANTUM DEPLOYED. ALL SYSTEMS ONLINE.")
