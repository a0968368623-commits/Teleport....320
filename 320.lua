-- [[ 320 MASTER - SMART LOADER ]]
-- 這段代碼放在執行器裡，GitHub 放你的功能代碼

local GITHUB_USER = "a0968368623-提交"
local REPO_NAME = "Teleport.....320"
local FILE_PATH = "main.lua"

-- 自動生成帶有「防緩存標籤」的網址，確保每次抓的都是最新的
local RawUrl = "https://raw.githubusercontent.com/"..GITHUB_USER.."/"..REPO_NAME.."/main/"..FILE_PATH.."?t="..tick()

print("🛰️ 正在從雲端抓取最強傳送腳本...")

local success, result = pcall(function()
    return game:HttpGet(RawUrl)
end)

if success and result then
    print("✅ 獲取成功！正在啟動次元突破版...")
    loadstring(result)()
else
    warn("❌ 獲取失敗，請檢查 GitHub 網址或檔案名稱是否正確")
end
