
--[[
    QUINOAUI VISUAL INSTALLER
    Compact Command Bar Edition
    By Quinoa Hosting / Ribco

    No plugins required.
    QuinoaUI v1.1.0 compatible.
]]

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local SOURCE_URL =
    "https://raw.githubusercontent.com/Ribco/quinoapackage/main/src/QuinoaUI.lua"

-- Remove previous installer
local old = CoreGui:FindFirstChild("QuinoaUI_CommandBarInstaller")
if old then
    old:Destroy()
end

-- Configuration
local config = {
    Title = "My Quinoa Dashboard",
    Theme = "Dark",
    TopbarPlus = false,
    Example = true,
}

-- Colors
local colors = {
    Background = Color3.fromRGB(18, 20, 27),
    Panel = Color3.fromRGB(27, 30, 40),
    Secondary = Color3.fromRGB(37, 41, 53),
    Accent = Color3.fromRGB(111, 91, 255),
    Text = Color3.fromRGB(242, 243, 250),
    Muted = Color3.fromRGB(157, 163, 180),
    Green = Color3.fromRGB(64, 190, 130),
    Red = Color3.fromRGB(220, 80, 90),
}

-- Helpers
local function create(class, properties, parent)
    local object = Instance.new(class)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function corner(parent, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, parent)
end

local function stroke(parent, color, transparency)
    create("UIStroke", {
        Color = color or Color3.fromRGB(65, 70, 90),
        Transparency = transparency or 0.5,
        Thickness = 1,
    }, parent)
end

local function label(parent, text, size, position, textSize, color)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        Size = size,
        Position = position,
        Font = Enum.Font.Gotham,
        TextSize = textSize or 14,
        TextColor3 = color or colors.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
end

-- Main GUI
local gui = create("ScreenGui", {
    Name = "QuinoaUI_CommandBarInstaller",
    DisplayOrder = 100000,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, CoreGui)

local window = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(460, 490),
    Position = UDim2.new(0.5, -230, 0.5, -245),
    BackgroundColor3 = colors.Background,
    BorderSizePixel = 0,
}, gui)

corner(window, 14)
stroke(window, colors.Accent, 0.25)

-- Dragging
local dragging = false
local dragStart
local startPosition

local topbar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 54),
    BackgroundColor3 = colors.Panel,
    BorderSizePixel = 0,
}, window)

corner(topbar, 14)

local dragArea = create("TextButton", {
    Size = UDim2.new(1, -55, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
}, topbar)

dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart

        window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

label(
    topbar,
    "QUINOAUI",
    UDim2.fromOffset(180, 23),
    UDim2.fromOffset(18, 5),
    16,
    colors.Text
).Font = Enum.Font.GothamBold

label(
    topbar,
    "VISUAL INSTALLER",
    UDim2.fromOffset(180, 17),
    UDim2.fromOffset(18, 29),
    9,
    colors.Muted
)

local close = create("TextButton", {
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 23,
    TextColor3 = colors.Muted,
    BackgroundTransparency = 1,
    Size = UDim2.fromOffset(38, 38),
    Position = UDim2.new(1, -43, 0, 8),
}, topbar)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- Content
local content = create("ScrollingFrame", {
    Size = UDim2.new(1, -24, 1, -70),
    Position = UDim2.fromOffset(12, 62),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = colors.Accent,
    CanvasSize = UDim2.fromOffset(0, 650),
}, window)

create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

local function section(text)
    local holder = create("Frame", {
        Size = UDim2.new(1, -6, 0, 23),
        BackgroundTransparency = 1,
    }, content)

    label(
        holder,
        text,
        UDim2.new(1, 0, 1, 0),
        UDim2.fromOffset(0, 0),
        11,
        colors.Muted
    ).Font = Enum.Font.GothamBold

    return holder
end

local function card(height)
    local frame = create("Frame", {
        Size = UDim2.new(1, -6, 0, height),
        BackgroundColor3 = colors.Panel,
        BorderSizePixel = 0,
    }, content)

    corner(frame, 10)
    return frame
end

-- Welcome
section("WELCOME")

local welcome = card(57)

label(
    welcome,
    "Let's set up your UI library.",
    UDim2.new(1, -24, 0, 22),
    UDim2.fromOffset(12, 6),
    14,
    colors.Text
).Font = Enum.Font.GothamBold

label(
    welcome,
    "Configure your options and preview your setup.",
    UDim2.new(1, -24, 0, 18),
    UDim2.fromOffset(12, 29),
    10,
    colors.Muted
)

-- Window configuration
section("WINDOW CONFIGURATION")

local titleCard = card(68)

label(
    titleCard,
    "Window title",
    UDim2.fromOffset(150, 18),
    UDim2.fromOffset(12, 5),
    11
)

local titleInput = create("TextBox", {
    Size = UDim2.new(1, -24, 0, 30),
    Position = UDim2.fromOffset(12, 29),
    BackgroundColor3 = colors.Secondary,
    TextColor3 = colors.Text,
    PlaceholderColor3 = colors.Muted,
    PlaceholderText = "Enter your window title",
    Text = config.Title,
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
}, titleCard)

corner(titleInput, 7)

-- Appearance
section("APPEARANCE")

local themeCard = card(62)

label(
    themeCard,
    "Choose a theme",
    UDim2.fromOffset(150, 17),
    UDim2.fromOffset(12, 3),
    11
)

local themeButton = create("TextButton", {
    Size = UDim2.new(1, -24, 0, 29),
    Position = UDim2.fromOffset(12, 27),
    BackgroundColor3 = colors.Secondary,
    TextColor3 = colors.Text,
    Text = "Theme: Dark  ▼",
    Font = Enum.Font.GothamMedium,
    TextSize = 11,
}, themeCard)

corner(themeButton, 7)

local themes = {"Dark", "Light"}
local themeIndex = 1

-- Integrations
section("INTEGRATIONS")

local optionsCard = card(91)

local function makeToggle(text, key, y)
    local button = create("TextButton", {
        Size = UDim2.new(1, -24, 0, 31),
        Position = UDim2.fromOffset(12, y),
        BackgroundColor3 = colors.Secondary,
        TextColor3 = colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, optionsCard)

    corner(button, 7)

    local function refresh()
        button.Text =
            (config[key] and "   ☑   " or "   □   ") .. text
    end

    refresh()

    button.Activated:Connect(function()
        config[key] = not config[key]
        refresh()
    end)

    return button
end

makeToggle("Enable TopbarPlus integration", "TopbarPlus", 7)
makeToggle("Create an example LocalScript", "Example", 49)

-- Preview
section("LIVE PREVIEW")

local preview = card(105)
preview.BackgroundColor3 = Color3.fromRGB(31, 35, 46)

local previewTitle = label(
    preview,
    config.Title,
    UDim2.new(1, -24, 0, 25),
    UDim2.fromOffset(12, 5),
    14
)

previewTitle.Font = Enum.Font.GothamBold

local previewTab = create("TextLabel", {
    Size = UDim2.fromOffset(75, 23),
    Position = UDim2.fromOffset(12, 36),
    BackgroundColor3 = colors.Accent,
    Text = "Home",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamMedium,
    TextSize = 10,
}, preview)

corner(previewTab, 6)

label(
    preview,
    "Welcome to your QuinoaUI dashboard!",
    UDim2.new(1, -24, 0, 22),
    UDim2.fromOffset(12, 66),
    10,
    colors.Text
)

titleInput:GetPropertyChangedSignal("Text"):Connect(function()
    config.Title = titleInput.Text
    previewTitle.Text = titleInput.Text
end)

local function updatePreviewTheme()
    if config.Theme == "Light" then
        preview.BackgroundColor3 = Color3.fromRGB(235, 238, 245)
        previewTitle.TextColor3 = Color3.fromRGB(30, 32, 40)
    else
        preview.BackgroundColor3 = Color3.fromRGB(31, 35, 46)
        previewTitle.TextColor3 = colors.Text
    end
end

themeButton.Activated:Connect(function()
    themeIndex = themeIndex % #themes + 1
    config.Theme = themes[themeIndex]
    themeButton.Text = "Theme: " .. config.Theme .. "  ▼"
    updatePreviewTheme()
end)

-- Status
local status = label(
    content,
    "Ready to install.",
    UDim2.new(1, -6, 0, 20),
    UDim2.new(),
    10,
    colors.Muted
)

-- Install button
local installButton = create("TextButton", {
    Size = UDim2.new(1, -6, 0, 40),
    BackgroundColor3 = colors.Accent,
    Text = "INSTALL QUINOAUI",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
}, content)

corner(installButton, 9)

local function setStatus(message, color)
    status.Text = message
    status.TextColor3 = color or colors.Muted
end

local installing = false

installButton.Activated:Connect(function()
    if installing then
        return
    end

    installing = true
    installButton.Text = "INSTALLING..."
    installButton.BackgroundColor3 = colors.Secondary

    local function fail(message)
        setStatus(message, colors.Red)
        installButton.Text = "TRY AGAIN"
        installButton.BackgroundColor3 = colors.Accent
        installing = false
    end

    if config.Title:gsub("%s+", "") == "" then
        fail("Please enter a window title.")
        return
    end

    setStatus("Downloading QuinoaUI from GitHub...")

    local success, source = pcall(function()
        return HttpService:GetAsync(SOURCE_URL)
    end)

    if not success or type(source) ~= "string" or #source == 0 then
        fail("Download failed. Check HTTP Requests and internet.")
        return
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterPlayer = game:GetService("StarterPlayer")
    local scripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

    -- Check existing folder
    local folder = ReplicatedStorage:FindFirstChild("QuinoaUI")

    if folder and (
        not folder:IsA("Folder")
        or not folder:GetAttribute("QuinoaUIManaged")
    ) then
        fail("Existing QuinoaUI folder isn't managed by this installer.")
        return
    end

    -- Check existing module
    local module = folder and folder:FindFirstChild("QuinoaUI")

    if module and (
        not module:IsA("ModuleScript")
        or not module:GetAttribute("QuinoaUIManaged")
    ) then
        fail("Existing QuinoaUI module isn't managed by this installer.")
        return
    end

    -- Check TopbarPlus
    if config.TopbarPlus then
        local package = ReplicatedStorage:FindFirstChild("TopbarPlus")
        local iconModule = package and package:FindFirstChild("Icon", true)

        if not iconModule or not iconModule:IsA("ModuleScript") then
            fail("TopbarPlus Icon module not found in ReplicatedStorage.TopbarPlus.")
            return
        end
    end

    -- Check bootstrap
    local bootstrap = scripts:FindFirstChild("QuinoaUIBootstrap")

    if bootstrap and (
        not bootstrap:IsA("LocalScript")
        or not bootstrap:GetAttribute("QuinoaUIManaged")
    ) then
        fail("Existing bootstrap isn't managed by this installer.")
        return
    end

    setStatus("Installing library...")

    local writeSuccess, writeError = pcall(function()
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "QuinoaUI"
            folder:SetAttribute("QuinoaUIManaged", true)
            folder.Parent = ReplicatedStorage
        end

        if not module then
            module = Instance.new("ModuleScript")
            module.Name = "QuinoaUI"
            module:SetAttribute("QuinoaUIManaged", true)
            module.Parent = folder
        end

        module.Source = source
        module:SetAttribute("Version", "1.1.0")

        if not bootstrap then
            bootstrap = Instance.new("LocalScript")
            bootstrap.Name = "QuinoaUIBootstrap"
            bootstrap:SetAttribute("QuinoaUIManaged", true)
            bootstrap.Parent = scripts
        end

        local title = string.format("%q", config.Title)
        local theme = string.format("%q", config.Theme)

        local bootstrapSource = [=[
--[[
    QuinoaUI Bootstrap
    Generated by QuinoaUI Command Bar Installer
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuinoaUI = require(
    ReplicatedStorage:WaitForChild("QuinoaUI"):WaitForChild("QuinoaUI")
)

local Window = QuinoaUI:CreateWindow({
    Title = ]=] .. title .. [=[,
    Theme = ]=] .. theme .. [=[
})
]=]

        -- Correct QuinoaUI v1.1.0 TopbarPlus API
        if config.TopbarPlus then
            bootstrapSource ..= [=[

Window:CreateTopbarToggle({
    Name = "QuinoaUI",
    Label = "Open QuinoaUI",
    Order = 1
})
]=]
        end

        -- Correct table-based QuinoaUI API
        if config.Example then
            bootstrapSource ..= [=[

local Home = Window:CreateTab({
    Name = "Home",
    Icon = "🏠"
})

local Section = Home:CreateSection({
    Name = "Welcome"
})

Section:CreateLabel({
    Name = "QuinoaUI is installed successfully!"
})

Section:CreateButton({
    Name = "Click me!",
    Callback = function()
        Window:Notify({
            Title = "QuinoaUI",
            Content = "Your UI is working!",
            Duration = 3
        })
    end
})
]=]
        end

        bootstrap.Source = bootstrapSource
    end)

    if not writeSuccess then
        fail("Installation error: " .. tostring(writeError))
        return
    end

    pcall(function()
        game:GetService("ChangeHistoryService"):SetWaypoint(
            "QuinoaUI Installation"
        )
    end)

    setStatus("QuinoaUI installed successfully!", colors.Green)
    installButton.Text = "INSTALLED ✓"
    installButton.BackgroundColor3 = colors.Green
    installing = false

    print("[QuinoaUI] Installation successful!")
    print("[QuinoaUI] Version: 1.1.0")
    print("[QuinoaUI] Module: ReplicatedStorage.QuinoaUI.QuinoaUI")
    print("[QuinoaUI] Bootstrap: StarterPlayerScripts.QuinoaUIBootstrap")
end)

print("[QuinoaUI] Compact Visual Installer opened.")
