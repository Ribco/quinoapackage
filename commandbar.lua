
--[[
    QuinoaUI Command Bar Launcher
    Run inside Roblox Studio's Command Bar.
]]

local Selection = game:GetService("Selection")

local marker = Instance.new("Folder")
marker.Name = "__QuinoaUI_OpenInstaller"
marker:SetAttribute("QuinoaUICommand", "OPEN_INSTALLER")
marker.Parent = workspace

Selection:Set({marker})

print("[QuinoaUI] Opening the Studio Installer...")
