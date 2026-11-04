
--[[
    QuinoaUI Installer
    Repository: Ribco/quinoapackage
    Run this script in Roblox Studio's Command Bar.
]]

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local REPO = "Ribco/quinoapackage"
local API_URL = "https://api.github.com/repos/" .. REPO .. "/releases/latest"
local RAW_BASE = "https://raw.githubusercontent.com/" .. REPO .. "/"

local function Fetch(url)
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if not success then
        error("Download failed: " .. tostring(result))
    end

    return result
end

print("[QuinoaUI] Checking for the latest version...")

local version = "main"
local sourceURL

-- Try the latest published GitHub release first.
local releaseSuccess, releaseData = pcall(function()
    return HttpService:JSONDecode(Fetch(API_URL))
end)

if releaseSuccess and releaseData.tag_name then
    version = releaseData.tag_name
    print("[QuinoaUI] Latest release found: " .. version)
else
    print("[QuinoaUI] No published release found. Using main branch.")
end

sourceURL = RAW_BASE .. version .. "/src/QuinoaUI.lua"

-- Download the library before changing anything in the game.
local sourceSuccess, source = pcall(function()
    return Fetch(sourceURL)
end)

-- If the release source is unavailable, try main.
if not sourceSuccess and version ~= "main" then
    warn("[QuinoaUI] Release download failed. Trying main branch...")
    version = "main"
    sourceURL = RAW_BASE .. "main/src/QuinoaUI.lua"

    sourceSuccess, source = pcall(function()
        return Fetch(sourceURL)
    end)
end

if not sourceSuccess then
    error("[QuinoaUI] Could not download the library. Check your internet connection and GitHub files.")
end

if not source or #source < 100 then
    error("[QuinoaUI] Downloaded source appears invalid. Nothing was changed.")
end

-- Create or update only the QuinoaUI package.
local folder = ReplicatedStorage:FindFirstChild("QuinoaUI")

if folder and not folder:IsA("Folder") then
    error("[QuinoaUI] ReplicatedStorage.QuinoaUI exists but is not a Folder.")
end

if not folder then
    folder = Instance.new("Folder")
    folder.Name = "QuinoaUI"
    folder.Parent = ReplicatedStorage
end

local module = folder:FindFirstChild("QuinoaUI")

if module and not module:IsA("ModuleScript") then
    error("[QuinoaUI] QuinoaUI exists but is not a ModuleScript.")
end

if not module then
    module = Instance.new("ModuleScript")
    module.Name = "QuinoaUI"
    module.Parent = folder
end

-- Update the module only after a successful download.
local previousSource = module.Source

local updateSuccess, updateError = pcall(function()
    module.Source = source
    module:SetAttribute("Version", version)
end)

if not updateSuccess then
    pcall(function()
        module.Source = previousSource
    end)

    error("[QuinoaUI] Installation failed: " .. tostring(updateError))
end

print("================================")
print("[QuinoaUI] Installation successful!")
print("[QuinoaUI] Version: " .. version)
print("[QuinoaUI] Location: ReplicatedStorage.QuinoaUI.QuinoaUI")
print("================================")
