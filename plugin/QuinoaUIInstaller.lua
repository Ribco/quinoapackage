
--[[
    QuinoaUI Studio Installer
    Quinoa Hosting / QuinoaUI
    Repository: Ribco/quinoapackage

    Install this script as a Roblox Studio plugin.
]]

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local REPO = "Ribco/quinoapackage"
local SOURCE_URL = "https://raw.githubusercontent.com/" .. REPO .. "/main/src/QuinoaUI.lua"

local COLORS = {
    Dark = {
        Background = Color3.fromRGB(19, 21, 29),
        Surface = Color3.fromRGB(27, 30, 40),
        Surface2 = Color3.fromRGB(36, 40, 52),
        Text = Color3.fromRGB(245, 246, 250),
        Muted = Color3.fromRGB(155, 162, 180),
        Accent = Color3.fromRGB(116, 98, 255),
        Border = Color3.fromRGB(48, 53, 68),
    },
    Light = {
        Background = Color3.fromRGB(245, 246, 250),
        Surface = Color3.fromRGB(255, 255, 255),
        Surface2 = Color3.fromRGB(235, 237, 244),
        Text = Color3.fromRGB(35, 38, 48),
        Muted = Color3.fromRGB(110, 116, 132),
        Accent = Color3.fromRGB(100, 82, 235),
        Border = Color3.fromRGB(220, 223, 232),
    },
}

local config = {
    Theme = "Dark",
    Title = "My Quinoa Dashboard",
    TopbarPlus = true,
    CreateExample = true,
}

local toolbar = plugin:CreateToolbar("QuinoaUI")
local toolbarButton = toolbar:CreateButton(
    "QuinoaUIInstaller",
    "Open the QuinoaUI installer",
    ""
)
toolbarButton.ClickableWhenViewportHidden = true

local widgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Right,
    false,
    false,
    420,
    650,
    340,
    420
)

local widget = plugin:CreateDockWidgetPluginGuiAsync(
    "QuinoaUIInstaller_v1",
    widgetInfo
)
widget.Title = "QuinoaUI Installer"

toolbarButton.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)

-- Command Bar bridge
-- Allows the Command Bar to request that this plugin opens its installer.

local Selection = game:GetService("Selection")

Selection.SelectionChanged:Connect(function()
    for _, instance in ipairs(Selection:Get()) do
        if instance:GetAttribute("QuinoaUICommand") == "OPEN_INSTALLER" then
            widget.Enabled = true

            -- Clear the temporary selection and marker.
            Selection:Set({})

            task.defer(function()
                if instance and instance.Parent then
                    instance:Destroy()
                end
            end)

            break
        end
    end
end)

-- UI helpers

local function create(class, props, parent)
    local object = Instance.new(class)

    for key, value in pairs(props or {}) do
        object[key] = value
    end

    object.Parent = parent
    return object
end

local function corner(parent, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

local function makeLabel(parent, text, size, color, bold)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextSize = size or 13,
        TextColor3 = color,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, 0, 0, 24),
    }, parent)
end

local function makeButton(parent, text, background, foreground)
    local button = create("TextButton", {
        AutoButtonColor = true,
        Text = text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextColor3 = foreground,
        BackgroundColor3 = background,
        Size = UDim2.new(1, 0, 0, 34),
        BorderSizePixel = 0,
    }, parent)

    corner(button, 7)
    return button
end

local root = create("Frame", {
    Name = "Root",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = COLORS.Dark.Background,
    BorderSizePixel = 0,
}, widget)

local rootPadding = create("UIPadding", {
    PaddingTop = UDim.new(0, 16),
    PaddingBottom = UDim.new(0, 16),
    PaddingLeft = UDim.new(0, 16),
    PaddingRight = UDim.new(0, 16),
}, root)

local scroll = create("ScrollingFrame", {
    Name = "Content",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, root)

local layout = create("UIListLayout", {
    Padding = UDim.new(0, 12),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, scroll)

-- Header

local heading = makeLabel(
    scroll,
    "QUINOA UI",
    22,
    COLORS.Dark.Text,
    true
)
heading.Size = UDim2.new(1, 0, 0, 30)

local subtitle = makeLabel(
    scroll,
    "Studio Installer  •  Configure your UI library",
    11,
    COLORS.Dark.Muted,
    false
)

-- Configuration card

local settingsCard = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Surface,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 260),
    AutomaticSize = Enum.AutomaticSize.Y,
}, scroll)
corner(settingsCard, 10)

local settingsPadding = create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12),
}, settingsCard)

local settingsLayout = create("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, settingsCard)

local settingsTitle = makeLabel(
    settingsCard,
    "INSTALLATION SETTINGS",
    11,
    COLORS.Dark.Muted,
    true
)

local titleLabel = makeLabel(
    settingsCard,
    "Window title",
    12,
    COLORS.Dark.Text,
    true
)

local titleInput = create("TextBox", {
    Text = config.Title,
    PlaceholderText = "Enter a window title",
    ClearTextOnFocus = false,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextColor3 = COLORS.Dark.Text,
    PlaceholderColor3 = COLORS.Dark.Muted,
    BackgroundColor3 = COLORS.Dark.Surface2,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 36),
}, settingsCard)
corner(titleInput, 7)

titleInput:GetPropertyChangedSignal("Text"):Connect(function()
    config.Title = titleInput.Text
end)

local themeLabel = makeLabel(
    settingsCard,
    "Default theme",
    12,
    COLORS.Dark.Text,
    true
)

local themeButtons = create("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 36),
}, settingsCard)

local themeLayout = create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, themeButtons)

local darkButton = makeButton(
    themeButtons,
    "Dark",
    COLORS.Dark.Accent,
    Color3.new(1, 1, 1)
)
darkButton.Size = UDim2.new(0.5, -4, 1, 0)

local lightButton = makeButton(
    themeButtons,
    "Light",
    COLORS.Dark.Surface2,
    COLORS.Dark.Text
)
lightButton.Size = UDim2.new(0.5, -4, 1, 0)

-- Live preview

local previewCard = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Surface,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 235),
}, scroll)
corner(previewCard, 10)

local previewPadding = create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12),
}, previewCard)

local previewLayout = create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, previewCard)

local previewHeading = makeLabel(
    previewCard,
    "LIVE PREVIEW",
    11,
    COLORS.Dark.Muted,
    true
)

local previewWindow = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Background,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 165),
    ClipsDescendants = true,
}, previewCard)
corner(previewWindow, 9)

local previewHeader = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Surface,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 35),
}, previewWindow)

local previewTitle = makeLabel(
    previewHeader,
    config.Title,
    12,
    COLORS.Dark.Text,
    true
)
previewTitle.Position = UDim2.fromOffset(10, 0)
previewTitle.Size = UDim2.new(1, -20, 1, 0)

local previewSidebar = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Surface,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(0, 35),
    Size = UDim2.new(0, 90, 1, -35),
}, previewWindow)

local previewTab = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Accent,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(7, 10),
    Size = UDim2.new(1, -14, 0, 25),
}, previewSidebar)
corner(previewTab, 5)

local previewContent = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Background,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(90, 35),
    Size = UDim2.new(1, -90, 1, -35),
}, previewWindow)

local previewSection = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Surface,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.new(1, -20, 0, 95),
}, previewContent)
corner(previewSection, 7)

local previewSectionTitle = makeLabel(
    previewSection,
    "Welcome",
    11,
    COLORS.Dark.Text,
    true
)
previewSectionTitle.Position = UDim2.fromOffset(9, 5)

local previewDescription = makeLabel(
    previewSection,
    "Your QuinoaUI window is ready.",
    9,
    COLORS.Dark.Muted,
    false
)
previewDescription.Position = UDim2.fromOffset(9, 30)
previewDescription.Size = UDim2.new(1, -18, 0, 25)
previewDescription.TextWrapped = true

local previewAction = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Accent,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(9, 63),
    Size = UDim2.fromOffset(85, 22),
}, previewSection)
corner(previewAction, 5)

local function updatePreview()
    local theme = COLORS[config.Theme]

    root.BackgroundColor3 = theme.Background
    heading.TextColor3 = theme.Text
    subtitle.TextColor3 = theme.Muted

    settingsCard.BackgroundColor3 = theme.Surface
    settingsTitle.TextColor3 = theme.Muted
    titleLabel.TextColor3 = theme.Text
    titleInput.BackgroundColor3 = theme.Surface2
    titleInput.TextColor3 = theme.Text
    titleInput.PlaceholderColor3 = theme.Muted
    themeLabel.TextColor3 = theme.Text

    previewCard.BackgroundColor3 = theme.Surface
    previewHeading.TextColor3 = theme.Muted
    previewWindow.BackgroundColor3 = theme.Background
    previewHeader.BackgroundColor3 = theme.Surface
    previewSidebar.BackgroundColor3 = theme.Surface
    previewContent.BackgroundColor3 = theme.Background
    previewSection.BackgroundColor3 = theme.Surface

    previewTitle.TextColor3 = theme.Text
    previewTitle.Text = config.Title ~= "" and config.Title or "Quinoa UI"
    previewSectionTitle.TextColor3 = theme.Text
    previewDescription.TextColor3 = theme.Muted

    previewTab.BackgroundColor3 = theme.Accent
    previewAction.BackgroundColor3 = theme.Accent

    darkButton.BackgroundColor3 =
        config.Theme == "Dark" and theme.Accent or theme.Surface2

    lightButton.BackgroundColor3 =
        config.Theme == "Light" and theme.Accent or theme.Surface2

    darkButton.TextColor3 = theme.Text
    lightButton.TextColor3 = theme.Text
end

darkButton.Activated:Connect(function()
    config.Theme = "Dark"
    updatePreview()
end)

lightButton.Activated:Connect(function()
    config.Theme = "Light"
    updatePreview()
end)

titleInput:GetPropertyChangedSignal("Text"):Connect(updatePreview)

-- Options

local optionsCard = create("Frame", {
    BackgroundColor3 = COLORS.Dark.Surface,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 145),
}, scroll)
corner(optionsCard, 10)

local optionsPadding = create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12),
}, optionsCard)

local optionsLayout = create("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, optionsCard)

local optionsTitle = makeLabel(
    optionsCard,
    "OPTIONAL FEATURES",
    11,
    COLORS.Dark.Muted,
    true
)

local function makeOption(parent, text, defaultValue)
    local button = create("TextButton", {
        BackgroundColor3 = COLORS.Dark.Surface2,
        BorderSizePixel = 0,
        Text = "",
        Size = UDim2.new(1, 0, 0, 34),
    }, parent)
    corner(button, 7)

    local indicator = makeLabel(
        button,
        defaultValue and "✓" or " ",
        16,
        COLORS.Dark.Accent,
        true
    )
    indicator.Position = UDim2.fromOffset(9, 0)
    indicator.Size = UDim2.fromOffset(22, 34)

    local optionText = makeLabel(
        button,
        text,
        11,
        COLORS.Dark.Text,
        false
    )
    optionText.Position = UDim2.fromOffset(35, 0)
    optionText.Size = UDim2.new(1, -42, 1, 0)

    local enabled = defaultValue

    button.Activated:Connect(function()
        enabled = not enabled
        indicator.Text = enabled and "✓" or ""
    end)

    return function()
        return enabled
    end
end

local getTopbarPlus = makeOption(
    optionsCard,
    "Enable TopbarPlus integration",
    true
)

local getExample = makeOption(
    optionsCard,
    "Create example tab and section",
    true
)

local dependencyHint = makeLabel(
    optionsCard,
    "TopbarPlus must already be installed in ReplicatedStorage.",
    10,
    COLORS.Dark.Muted,
    false
)
dependencyHint.TextWrapped = true
dependencyHint.Size = UDim2.new(1, 0, 0, 28)

-- Install area

local installButton = makeButton(
    scroll,
    "INSTALL QUINOA UI",
    COLORS.Dark.Accent,
    Color3.new(1, 1, 1)
)
installButton.Size = UDim2.new(1, 0, 0, 42)
installButton.TextSize = 13

local status = makeLabel(
    scroll,
    "Ready to install.",
    11,
    COLORS.Dark.Muted,
    false
)
status.TextWrapped = true
status.Size = UDim2.new(1, 0, 0, 36)

local footer = makeLabel(
    scroll,
    "QuinoaUI • Built for Roblox developers",
    10,
    COLORS.Dark.Muted,
    false
)
footer.TextXAlignment = Enum.TextXAlignment.Center

local function setStatus(message, success)
    status.Text = message
    status.TextColor3 = success
        and Color3.fromRGB(74, 190, 130)
        or COLORS[config.Theme].Muted
end

-- Source generation

local function makeBootstrap()
    local lines = {
        "-- Generated by the QuinoaUI Studio Installer.",
        "-- You can edit this script after installation.",
        "",
        'local ReplicatedStorage = game:GetService("ReplicatedStorage")',
        'local package = ReplicatedStorage:WaitForChild("QuinoaUI")',
        'local QuinoaUI = require(package:WaitForChild("QuinoaUI"))',
        "",
        "local Window = QuinoaUI:CreateWindow({",
        '    Title = ' .. string.format("%q", config.Title ~= "" and config.Title or "Quinoa UI") .. ",",
        '    Theme = "' .. config.Theme .. '",',
        "})",
        "",
    }

    if getTopbarPlus() then
        table.insert(lines, 'Window:CreateTopbarToggle({')
        table.insert(lines, '    Name = "QuinoaUI",')
        table.insert(lines, '    Label = "Open QuinoaUI",')
        table.insert(lines, "    Order = 1,")
        table.insert(lines, "})")
        table.insert(lines, "")
    end

    if getExample() then
        table.insert(lines, 'local Home = Window:CreateTab({')
        table.insert(lines, '    Name = "Home",')
        table.insert(lines, '    Icon = "🏠",')
        table.insert(lines, "})")
        table.insert(lines, "")
        table.insert(lines, 'local Section = Home:CreateSection({')
        table.insert(lines, '    Name = "Welcome",')
        table.insert(lines, "})")
        table.insert(lines, "")
        table.insert(lines, 'Section:CreateLabel({')
        table.insert(lines, '    Text = "Your QuinoaUI installation is ready!",')
        table.insert(lines, "})")
    end

    return table.concat(lines, "\n")
end

local function findTopbarPlus()
    local package = ReplicatedStorage:FindFirstChild("TopbarPlus")

    if not package then
        return false
    end

    local icon = package:FindFirstChild("Icon", true)
    return icon ~= nil and icon:IsA("ModuleScript")
end

local function install()
    installButton.Active = false
    installButton.Text = "INSTALLING..."
    setStatus("Downloading QuinoaUI source...", false)

    local success, result = pcall(function()
        local source = HttpService:GetAsync(SOURCE_URL)

        assert(
            type(source) == "string" and #source > 100,
            "Downloaded source is empty or invalid."
        )

        assert(
            source:find("QuinoaUI", 1, true),
            "Downloaded file does not look like QuinoaUI."
        )

        local useTopbar = getTopbarPlus()

        if useTopbar and not findTopbarPlus() then
            error(
                "TopbarPlus is enabled, but its Icon ModuleScript was not found. Install TopbarPlus in ReplicatedStorage first, or disable the option."
            )
        end

        local playerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")

        assert(
            playerScripts,
            "StarterPlayerScripts could not be found."
        )

        local existingFolder = ReplicatedStorage:FindFirstChild("QuinoaUI")

        if existingFolder and not existingFolder:IsA("Folder") then
            error("ReplicatedStorage.QuinoaUI exists but is not a Folder.")
        end

        if existingFolder then
            local existingModule = existingFolder:FindFirstChild("QuinoaUI")

            if existingModule and not existingModule:IsA("ModuleScript") then
                error("ReplicatedStorage.QuinoaUI.QuinoaUI is not a ModuleScript.")
            end
        end

        local existingBootstrap = playerScripts:FindFirstChild("QuinoaUIBootstrap")

        if existingBootstrap then
            if not existingBootstrap:IsA("LocalScript")
                or existingBootstrap:GetAttribute("QuinoaUIManaged") ~= true then
                error(
                    "StarterPlayerScripts.QuinoaUIBootstrap already exists and is not managed by QuinoaUI. Rename it before installing."
                )
            end
        end

        setStatus("Preparing installation...", false)

        ChangeHistoryService:SetWaypoint("Before QuinoaUI Installation")

        local folder = existingFolder

        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "QuinoaUI"
            folder.Parent = ReplicatedStorage
        end

        local module = folder:FindFirstChild("QuinoaUI")

        if not module then
            module = Instance.new("ModuleScript")
            module.Name = "QuinoaUI"
            module.Parent = folder
        end

        module.Source = source
        module:SetAttribute("QuinoaUIManaged", true)
        module:SetAttribute("Version", "main")

        local bootstrap = existingBootstrap

        if not bootstrap then
            bootstrap = Instance.new("LocalScript")
            bootstrap.Name = "QuinoaUIBootstrap"
            bootstrap.Parent = playerScripts
        end

        bootstrap.Source = makeBootstrap()
        bootstrap:SetAttribute("QuinoaUIManaged", true)
        bootstrap:SetAttribute("Theme", config.Theme)
        bootstrap:SetAttribute("TopbarPlus", useTopbar)
        bootstrap:SetAttribute("ExampleEnabled", getExample())

        ChangeHistoryService:SetWaypoint("QuinoaUI Installation Complete")

        return "Installed successfully!"
    end)

    installButton.Active = true
    installButton.Text = "INSTALL QUINOA UI"

    if success then
        setStatus(
            "✓ " .. result ..
            "\nModule: ReplicatedStorage.QuinoaUI.QuinoaUI" ..
            "\nScript: StarterPlayerScripts.QuinoaUIBootstrap",
            true
        )
    else
        setStatus("Installation failed:\n" .. tostring(result), false)
        warn("[QuinoaUI Installer] " .. tostring(result))
    end
end

installButton.Activated:Connect(install)

updatePreview()
