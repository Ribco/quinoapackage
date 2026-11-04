--=======================================================
-- QUINOA UI | VERSION 1.1.0
--=======================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local QuinoaUI = {
    Version = "1.1.0",
    Windows = {},
}

local Themes = {
    Dark = {
        Background = Color3.fromRGB(19, 21, 29),
        Surface = Color3.fromRGB(27, 30, 40),
        Surface2 = Color3.fromRGB(36, 40, 52),
        Text = Color3.fromRGB(245, 246, 250),
        Muted = Color3.fromRGB(155, 162, 180),
        Accent = Color3.fromRGB(116, 98, 255),
        Border = Color3.fromRGB(48, 53, 68),
        Success = Color3.fromRGB(74, 190, 130),
        Danger = Color3.fromRGB(225, 85, 95),
    },

    Light = {
        Background = Color3.fromRGB(245, 246, 250),
        Surface = Color3.fromRGB(255, 255, 255),
        Surface2 = Color3.fromRGB(235, 237, 244),
        Text = Color3.fromRGB(35, 38, 48),
        Muted = Color3.fromRGB(110, 116, 132),
        Accent = Color3.fromRGB(100, 82, 235),
        Border = Color3.fromRGB(220, 223, 232),
        Success = Color3.fromRGB(45, 160, 105),
        Danger = Color3.fromRGB(210, 65, 75),
    },
}

local function create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function corner(parent, radius)
    return create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

local function stroke(parent, color, transparency)
    return create("UIStroke", {
        Color = color,
        Transparency = transparency or 0,
        Thickness = 1,
    }, parent)
end

local function padding(parent, amount)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, amount),
        PaddingBottom = UDim.new(0, amount),
        PaddingLeft = UDim.new(0, amount),
        PaddingRight = UDim.new(0, amount),
    }, parent)
end

local function label(parent, text, size, color, bold)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text or "",
        TextSize = size or 14,
        TextColor3 = color,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, 0, 0, 22),
    }, parent)
end

local function button(parent, text, theme, height)
    local object = create("TextButton", {
        AutoButtonColor = false,
        Text = text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextColor3 = theme.Text,
        BackgroundColor3 = theme.Surface2,
        Size = UDim2.new(1, 0, 0, height or 36),
    }, parent)

    corner(object, 7)

    object.MouseEnter:Connect(function()
        TweenService:Create(object, TweenInfo.new(0.15), {
            BackgroundColor3 = theme.Accent
        }):Play()
    end)

    object.MouseLeave:Connect(function()
        TweenService:Create(object, TweenInfo.new(0.15), {
            BackgroundColor3 = theme.Surface2
        }):Play()
    end)

    return object
end

local function animate(object, properties, duration)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local function applyTheme(window)
    local t = window.Theme

    window.Main.BackgroundColor3 = t.Background
    window.Header.BackgroundColor3 = t.Surface
    window.Sidebar.BackgroundColor3 = t.Surface
    window.Pages.BackgroundColor3 = t.Background

    window.Title.TextColor3 = t.Text

    for _, tab in pairs(window.Tabs) do
        tab.Button.TextColor3 = t.Text
        tab.Button.BackgroundColor3 =
            tab == window.ActiveTab and t.Accent or t.Surface2

        tab.Page.BackgroundColor3 = t.Background
    end
end

function QuinoaUI:CreateWindow(config)
    config = config or {}

    local player = Players.LocalPlayer
    assert(player, "QuinoaUI must be used from a LocalScript.")

    local playerGui = player:WaitForChild("PlayerGui")

    local themeName = config.Theme or "Dark"
    assert(Themes[themeName] or type(themeName) == "table",
        "Invalid QuinoaUI theme.")

    local theme = type(themeName) == "table" and themeName or Themes[themeName]

    local screen = create("ScreenGui", {
        Name = "QuinoaUI_" .. tostring(#self.Windows + 1),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = config.DisplayOrder or 10,
    }, playerGui)

    local main = create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = config.Size or UDim2.fromOffset(620, 410),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, screen)

    corner(main, 12)
    stroke(main, theme.Border)

    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
    }, main)

    local title = label(header, config.Title or "Quinoa UI", 15, theme.Text, true)
    title.Position = UDim2.fromOffset(17, 0)
    title.Size = UDim2.new(1, -110, 1, 0)

    local minimize = create("TextButton", {
        Text = "—",
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        TextColor3 = theme.Muted,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -78, 0, 0),
        Size = UDim2.fromOffset(38, 48),
    }, header)

    local close = create("TextButton", {
        Text = "×",
        TextSize = 22,
        Font = Enum.Font.Gotham,
        TextColor3 = theme.Muted,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.fromOffset(38, 48),
    }, header)

    local sidebar = create("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(0, 155, 1, -48),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
    }, main)

    local tabList = create("ScrollingFrame", {
        Name = "TabList",
        Position = UDim2.fromOffset(10, 12),
        Size = UDim2.new(1, -20, 1, -24),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
    }, sidebar)

    local tabLayout = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, tabList)

    local pages = create("Frame", {
        Name = "Pages",
        Position = UDim2.new(0, 155, 0, 48),
        Size = UDim2.new(1, -155, 1, -48),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, main)

    local window = setmetatable({
        Screen = screen,
        Main = main,
        Header = header,
        Sidebar = sidebar,
        TabList = tabList,
        Pages = pages,
        Title = title,
        Theme = theme,
        Tabs = {},
        ActiveTab = nil,
        Destroyed = false,
        Minimized = false,
        _connections = {},
    }, Window)

    table.insert(self.Windows, window)

    -- Dragging
    local dragging = false
    local dragStart
    local startPosition

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart

            main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    table.insert(window._connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    close.Activated:Connect(function()
        window:Close()
    end)

    minimize.Activated:Connect(function()
        window:Minimize()
    end)

    applyTheme(window)

    return window
end

function Window:_check()
    assert(not self.Destroyed, "[QuinoaUI] This window has been destroyed.")
end


function Window:Open()
    self:_check()

    if self.TopbarIcon and not self.TopbarIcon.isSelected then
        self.TopbarIcon:select()
    else
        self.Main.Visible = true
    end

    return self
end

function Window:Close()
    self:_check()

    if self.TopbarIcon and self.TopbarIcon.isSelected then
        self.TopbarIcon:deselect()
    else
        self.Main.Visible = false
    end

    return self
end

function Window:Toggle()
    self:_check()

    if self.Main.Visible then
        self:Close()
    else
        self:Open()
    end

    return self
end

function Window:TopbarToggle()
    return self:Toggle()
end

function Window:CreateTopbarToggle(config)
    self:_check()
    config = config or {}

    if self.TopbarIcon then
        self.TopbarIcon:destroy()
        self.TopbarIcon = nil
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local packageName = config.PackageName or "TopbarPlus"
    local package = ReplicatedStorage:FindFirstChild(packageName)

    assert(
        package,
        "[QuinoaUI] TopbarPlus was not found in ReplicatedStorage. Install TopbarPlus first."
    )

    local iconModule = package:FindFirstChild("Icon", true)

    assert(
        iconModule and iconModule:IsA("ModuleScript"),
        "[QuinoaUI] Could not find the TopbarPlus Icon ModuleScript."
    )

    local success, Icon = pcall(require, iconModule)

    assert(
        success and type(Icon) == "table" and type(Icon.new) == "function",
        "[QuinoaUI] Failed to load TopbarPlus: " .. tostring(Icon)
    )

    local icon = Icon.new()
    icon:setName(config.Name or "QuinoaUI")
    icon:setLabel(config.Label or "Quinoa UI")
    icon:setOrder(config.Order or 1)

    if config.Image then
        icon:setImage(config.Image)
    end

    if config.Caption then
        icon:setCaption(config.Caption)
    end

    table.insert(self._connections, icon.selected:Connect(function()
        if not self.Destroyed then
            self.Main.Visible = true
        end
    end))

    table.insert(self._connections, icon.deselected:Connect(function()
        if not self.Destroyed then
            self.Main.Visible = false
        end
    end))

    self.TopbarIcon = icon

    -- Keep the icon state synchronized with the window.
    if self.Main.Visible then
        icon:select()
    end

    return icon
end


function Window:SetTitle(text)
    self:_check()
    assert(type(text) == "string", "Title must be a string.")
    self.Title.Text = text
    return self
end

function Window:Minimize()
    self:_check()

    if self.Minimized then
        self.Main.Size = self._oldSize or UDim2.fromOffset(620, 410)
        self.Minimized = false
    else
        self._oldSize = self.Main.Size
        self.Main.Size = UDim2.new(
            self._oldSize.X.Scale,
            self._oldSize.X.Offset,
            0,
            48
        )
        self.Minimized = true
    end

    return self
end

function Window:SetTheme(themeName)
    self:_check()

    if type(themeName) == "string" then
        assert(Themes[themeName], "Unknown theme: " .. themeName)
        self.Theme = Themes[themeName]
    elseif type(themeName) == "table" then
        self.Theme = themeName
    else
        error("Theme must be a theme name or a Color3 table.")
    end

    applyTheme(self)
    return self
end

function Window:CreateTab(config)
    self:_check()

    assert(type(config) == "table", "Tab config must be a table.")
    assert(type(config.Name) == "string" and config.Name ~= "",
        "Tab requires a Name.")

    assert(not self.Tabs[config.Name],
        "A tab with this name already exists.")

    local t = self.Theme

    local tabButton = create("TextButton", {
        Name = config.Name .. "Tab",
        Text = (config.Icon and tostring(config.Icon) .. "  " or "")
            .. config.Name,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextColor3 = t.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = t.Surface2,
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, 35),
    }, self.TabList)

    padding(tabButton, 10)
    corner(tabButton, 7)

    local page = create("ScrollingFrame", {
        Name = config.Name .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = t.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, self.Pages)

    padding(page, 16)

    local layout = create("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)

    local tab = setmetatable({
        Name = config.Name,
        Window = self,
        Button = tabButton,
        Page = page,
        Sections = {},
        Destroyed = false,
    }, Tab)

    self.Tabs[config.Name] = tab

    tabButton.Activated:Connect(function()
        tab:Show()
    end)

    if not self.ActiveTab then
        tab:Show()
    end

    return tab
end

function Window:GetTab(name)
    return self.Tabs[name]
end

function Window:GetActiveTab()
    return self.ActiveTab
end

function Window:Notify(config)
    self:_check()

    config = config or {}
    local t = self.Theme

    local toast = create("Frame", {
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -18, 0, 18),
        Size = UDim2.fromOffset(260, 75),
        ZIndex = 20,
    }, self.Screen)

    corner(toast, 9)
    stroke(toast, t.Border)

    local heading = label(
        toast,
        config.Title or "Notification",
        13,
        t.Text,
        true
    )
    heading.Position = UDim2.fromOffset(12, 7)
    heading.Size = UDim2.new(1, -24, 0, 23)
    heading.ZIndex = 21

    local description = label(
        toast,
        config.Description or config.Content or "",
        11,
        t.Muted,
        false
    )
    description.Position = UDim2.fromOffset(12, 32)
    description.Size = UDim2.new(1, -24, 0, 30)
    description.TextWrapped = true
    description.ZIndex = 21

    toast.BackgroundTransparency = 1
    toast.Position = UDim2.new(1, 280, 0, 18)

    animate(toast, {
        BackgroundTransparency = 0,
        Position = UDim2.new(1, -18, 0, 18),
    })

    task.delay(config.Duration or 3, function()
        if toast.Parent then
            animate(toast, {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 280, 0, 18),
            }, 0.2)

            task.wait(0.25)

            if toast.Parent then
                toast:Destroy()
            end
        end
    end)

    return toast
end

function Window:Destroy()
    if self.Destroyed then
        return
    end

    self.Destroyed = true

    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end

    table.clear(self._connections)

    if self.TopbarIcon then
        self.TopbarIcon:destroy()
        self.TopbarIcon = nil
    end

    if self.Screen then
        self.Screen:Destroy()
    end

    table.clear(self.Tabs)

    for index, window in ipairs(QuinoaUI.Windows) do
        if window == self then
            table.remove(QuinoaUI.Windows, index)
            break
        end
    end
end

function Tab:_check()
    assert(not self.Destroyed, "[QuinoaUI] This tab has been destroyed.")
    self.Window:_check()
end

function Tab:Show()
    self:_check()

    for _, other in pairs(self.Window.Tabs) do
        other.Page.Visible = other == self
        other.Button.BackgroundColor3 =
            other == self and self.Window.Theme.Accent
            or self.Window.Theme.Surface2
    end

    self.Window.ActiveTab = self
    return self
end

function Tab:Hide()
    self:_check()
    self.Page.Visible = false
    self.Button.Visible = false

    if self.Window.ActiveTab == self then
        self.Window.ActiveTab = nil

        for _, other in pairs(self.Window.Tabs) do
            if other ~= self and other.Button.Visible then
                other:Show()
                break
            end
        end
    end

    return self
end

function Tab:CreateSection(config)
    self:_check()
    config = config or {}

    local t = self.Window.Theme

    local frame = create("Frame", {
        Name = (config.Name or "Section") .. "Section",
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 45),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, self.Page)

    corner(frame, 9)
    stroke(frame, t.Border)
    padding(frame, 12)

    local sectionLayout = create("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, frame)

    local heading = label(frame, config.Name or "Section", 13, t.Text, true)
    heading.LayoutOrder = 0

    local section = setmetatable({
        Name = config.Name or "Section",
        Frame = frame,
        Tab = self,
        Window = self.Window,
    }, Section)

    table.insert(self.Sections, section)
    return section
end

function Tab:Destroy()
    self:_check()

    local window = self.Window
    local wasActive = window.ActiveTab == self

    self.Destroyed = true
    window.Tabs[self.Name] = nil

    self.Button:Destroy()
    self.Page:Destroy()

    if wasActive then
        window.ActiveTab = nil

        for _, other in pairs(window.Tabs) do
            if other.Button.Visible then
                other:Show()
                break
            end
        end
    end
end

local function addControl(section, height)
    local frame = create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, height),
    }, section.Frame)

    return frame
end

function Section:CreateLabel(config)
    config = type(config) == "string" and {Name = config} or config or {}

    local t = self.Window.Theme
    local object = label(
        self.Frame,
        config.Name or config.Text or "Label",
        config.TextSize or 12,
        config.Color or t.Muted,
        config.Bold or false
    )

    object.Size = UDim2.new(1, 0, 0, config.Height or 23)
    object.TextWrapped = true

    return object
end

function Section:CreateDivider()
    local t = self.Window.Theme

    return create("Frame", {
        BackgroundColor3 = t.Border,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
    }, self.Frame)
end

function Section:CreateButton(config)
    config = config or {}

    local t = self.Window.Theme
    local object = button(
        self.Frame,
        config.Name or "Button",
        t,
        config.Height or 36
    )

    object.Activated:Connect(function()
        if config.Callback then
            task.spawn(config.Callback)
        end
    end)

    return object
end

function Section:CreateToggle(config)
    config = config or {}

    local t = self.Window.Theme
    local state = config.Default == true

    local holder = addControl(self, 36)

    local name = label(holder, config.Name or "Toggle", 12, t.Text, false)
    name.Size = UDim2.new(1, -65, 1, 0)

    local toggle = create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = state and t.Accent or t.Surface2,
        Position = UDim2.new(1, -45, 0.5, -10),
        Size = UDim2.fromOffset(45, 20),
    }, holder)

    corner(toggle, 20)

    local knob = create("Frame", {
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = state and UDim2.new(1, -18, 0, 2)
            or UDim2.fromOffset(2, 2),
        Size = UDim2.fromOffset(16, 16),
    }, toggle)

    corner(knob, 20)

    local function set(value)
        state = value == true

        animate(toggle, {
            BackgroundColor3 = state and t.Accent or t.Surface2,
        })

        animate(knob, {
            Position = state and UDim2.new(1, -18, 0, 2)
                or UDim2.fromOffset(2, 2),
        })

        if config.Callback then
            task.spawn(config.Callback, state)
        end
    end

    toggle.Activated:Connect(function()
        set(not state)
    end)

    return {
        Set = set,
        Get = function()
            return state
        end,
    }
end

function Section:CreateSlider(config)
    config = config or {}

    local t = self.Window.Theme
    local min = config.Min or 0
    local max = config.Max or 100
    assert(max > min, "Slider Max must be greater than Min.")

    local value = math.clamp(config.Default or min, min, max)
    local holder = addControl(self, 55)

    local title = label(holder, config.Name or "Slider", 12, t.Text)
    title.Size = UDim2.new(0.75, 0, 0, 22)

    local valueLabel = label(holder, tostring(value), 12, t.Muted)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Position = UDim2.new(0.75, 0, 0, 0)
    valueLabel.Size = UDim2.new(0.25, 0, 0, 22)

    local track = create("Frame", {
        BackgroundColor3 = t.Surface2,
        Position = UDim2.fromOffset(0, 32),
        Size = UDim2.new(1, 0, 0, 7),
    }, holder)

    corner(track, 8)

    local fill = create("Frame", {
        BackgroundColor3 = t.Accent,
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
    }, track)

    corner(fill, 8)

    local knob = create("Frame", {
        BackgroundColor3 = Color3.new(1, 1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0),
        Size = UDim2.fromOffset(15, 15),
    }, track)

    corner(knob, 20)

    local dragging = false

    local function set(newValue)
        value = math.clamp(newValue, min, max)

        local alpha = (value - min) / (max - min)

        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLabel.Text = tostring(math.floor(value * 100 + 0.5) / 100)

        if config.Callback then
            task.spawn(config.Callback, value)
        end
    end

    local function update(input)
        local alpha = math.clamp(
            (input.Position.X - track.AbsolutePosition.X)
                / track.AbsoluteSize.X,
            0,
            1
        )

        set(min + (max - min) * alpha)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {
        Set = set,
        Get = function()
            return value
        end,
    }
end

function Section:CreateDropdown(config)
    config = config or {}

    local t = self.Window.Theme
    local options = config.Options or {}
    local selected = config.Default

    local holder = addControl(self, 65)

    label(holder, config.Name or "Dropdown", 12, t.Text)

    local dropdownButton = button(
        holder,
        tostring(selected or "Select an option"),
        t,
        34
    )

    dropdownButton.Position = UDim2.fromOffset(0, 27)

    local open = false
    local optionFrame

    local function closeOptions()
        open = false

        if optionFrame then
            optionFrame:Destroy()
            optionFrame = nil
        end
    end

    dropdownButton.Activated:Connect(function()
        if open then
            closeOptions()
            return
        end

        open = true

        optionFrame = create("Frame", {
            BackgroundColor3 = t.Surface,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, 5),
            Size = UDim2.new(1, 0, 0, math.min(#options * 30, 150)),
            ZIndex = 5,
        }, dropdownButton)

        corner(optionFrame, 7)
        stroke(optionFrame, t.Border)

        local scroll = create("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ScrollBarThickness = 3,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            ZIndex = 6,
        }, optionFrame)

        local layout = create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, scroll)

        for _, option in ipairs(options) do
            local optionButton = create("TextButton", {
                Text = tostring(option),
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextColor3 = t.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                ZIndex = 7,
            }, scroll)

            optionButton.Activated:Connect(function()
                selected = option
                dropdownButton.Text = tostring(option)
                closeOptions()

                if config.Callback then
                    task.spawn(config.Callback, option)
                end
            end)
        end
    end)

    return {
        Set = function(value)
            selected = value
            dropdownButton.Text = tostring(value)
        end,

        Get = function()
            return selected
        end,

        Refresh = function(newOptions)
            options = newOptions
            closeOptions()
        end,
    }
end

function Section:CreateInput(config)
    config = config or {}

    local t = self.Window.Theme
    local holder = addControl(self, 62)

    label(holder, config.Name or "Text Input", 12, t.Text)

    local input = create("TextBox", {
        Text = config.Default or "",
        PlaceholderText = config.Placeholder or "Enter text...",
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextColor3 = t.Text,
        PlaceholderColor3 = t.Muted,
        BackgroundColor3 = t.Surface2,
        ClearTextOnFocus = false,
        Position = UDim2.fromOffset(0, 26),
        Size = UDim2.new(1, 0, 0, 34),
    }, holder)

    padding(input, 9)
    corner(input, 7)

    input.FocusLost:Connect(function(enterPressed)
        if config.Callback then
            task.spawn(config.Callback, input.Text, enterPressed)
        end
    end)

    return input
end

function Section:CreateMultiDropdown(config)
    config = config or {}

    local selected = {}
    local dropdownConfig = table.clone(config)

    dropdownConfig.Callback = function(option)
        selected[option] = not selected[option]

        if config.Callback then
            local result = {}

            for value, enabled in pairs(selected) do
                if enabled then
                    table.insert(result, value)
                end
            end

            task.spawn(config.Callback, result)
        end
    end

    local control = self:CreateDropdown(dropdownConfig)

    return {
        Get = function()
            local result = {}

            for value, enabled in pairs(selected) do
                if enabled then
                    table.insert(result, value)
                end
            end

            return result
        end,

        Set = function(values)
            table.clear(selected)

            for _, value in ipairs(values) do
                selected[value] = true
            end
        end,

        Refresh = control.Refresh,
    }
end

function Section:Destroy()
    if self.Frame then
        self.Frame:Destroy()
    end
end

return QuinoaUI
