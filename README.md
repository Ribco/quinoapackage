# 🌿 QuinoaUI

**A modern, customizable UI library for Roblox.**

QuinoaUI is a lightweight Luau UI library designed to help Roblox developers create beautiful and interactive interfaces with clean, simple code.

- 🎨 Customizable Dark and Light themes
- 🪟 Modern window interface
- 📑 Tabs and sections
- 🔘 Buttons, toggles, sliders, and dropdowns
- 🔔 Notification system
- 📱 Optional TopbarPlus integration
- ⚡ Easy installation through Roblox Studio Command Bar

---

## 📦 Installation

### Requirements

- Roblox Studio
- HTTP Requests enabled
- Internet connection

### Step 1 — Enable HTTP Requests

1. Open Roblox Studio.
2. Go to **File → Experience Settings**.
3. Open **Security**.
4. Enable **Allow HTTP Requests**.
5. Save your settings.

### Step 2 — Install QuinoaUI

Open the Roblox Studio Command Bar and paste:

```lua
loadstring(game:GetService("HttpService"):GetAsync(
    "https://raw.githubusercontent.com/Ribco/quinoapackage/main/commandbar.lua"
))()
```

The QuinoaUI visual installer will appear. Follow its instructions to configure and install the library.

---

## 🚀 Getting Started

After installation, create a LocalScript inside `StarterPlayerScripts`.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuinoaUI = require(
    ReplicatedStorage:WaitForChild("QuinoaUI"):WaitForChild("QuinoaUI")
)

local Window = QuinoaUI:CreateWindow({
    Title = "My QuinoaUI App",
    Theme = "Dark"
})

local Home = Window:CreateTab({
    Name = "Home",
    Icon = "🏠"
})

local Section = Home:CreateSection({
    Name = "Welcome"
})

Section:CreateLabel({
    Name = "Welcome to QuinoaUI!"
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
```

---

## 🎨 Themes

QuinoaUI currently supports two built-in themes:

| Theme | Description |
|---|---|
| `Dark` | A modern dark appearance |
| `Light` | A clean light appearance |

Set your preferred theme when creating a window:

```lua
local Window = QuinoaUI:CreateWindow({
    Title = "My Application",
    Theme = "Light"
})
```

---

## 🧩 API Reference

### CreateWindow

Creates a new QuinoaUI window.

```lua
local Window = QuinoaUI:CreateWindow({
    Title = "My Window",
    Theme = "Dark"
})
```

### Window Methods

| Method | Description |
|---|---|
| `Window:Open()` | Opens the window |
| `Window:Close()` | Closes the window |
| `Window:Toggle()` | Toggles visibility |
| `Window:Minimize()` | Minimizes the window |
| `Window:SetTitle(title)` | Changes the window title |
| `Window:SetTheme(theme)` | Changes the theme |
| `Window:Destroy()` | Removes the window |
| `Window:Notify(config)` | Displays a notification |
| `Window:CreateTab(config)` | Creates a tab |
| `Window:GetTab(name)` | Gets a tab |
| `Window:GetActiveTab()` | Gets the active tab |

### Tab Methods

| Method | Description |
|---|---|
| `Tab:Show()` | Shows the tab |
| `Tab:Hide()` | Hides the tab |
| `Tab:Destroy()` | Removes the tab |
| `Tab:CreateSection(config)` | Creates a section |

### Section Methods

| Method | Description |
|---|---|
| `Section:CreateLabel(config)` | Creates a label |
| `Section:CreateDivider()` | Creates a divider |
| `Section:CreateButton(config)` | Creates a button |
| `Section:CreateToggle(config)` | Creates a toggle |
| `Section:CreateSlider(config)` | Creates a slider |
| `Section:CreateDropdown(config)` | Creates a dropdown |
| `Section:CreateInput(config)` | Creates an input |
| `Section:CreateMultiDropdown(config)` | Creates a multi-selection dropdown |

---

## 🔔 Notifications

Display notifications from your window:

```lua
Window:Notify({
    Title = "Hello!",
    Content = "Welcome to QuinoaUI.",
    Duration = 3
})
```

---

## 📌 TopbarPlus Integration

QuinoaUI supports optional integration with the official [TopbarPlus](https://github.com/1ForeverHD/TopbarPlus) package.

Place the TopbarPlus package inside `ReplicatedStorage` under a folder named `TopbarPlus`.

Then use:

```lua
Window:CreateTopbarToggle({
    Name = "QuinoaUI",
    Label = "Open QuinoaUI",
    Order = 1
})
```

This creates a TopbarPlus icon that can toggle your QuinoaUI window.

TopbarPlus is optional.

---

## 📁 Installation Structure

After installation, QuinoaUI creates:

```text
ReplicatedStorage
└── QuinoaUI
    └── QuinoaUI (ModuleScript)

StarterPlayer
└── StarterPlayerScripts
    └── QuinoaUIBootstrap (LocalScript)
```

---

## 🛠️ Development

QuinoaUI is developed by **Ribco** under the Quinoa Hosting project.

- **Repository:** [Ribco/quinoapackage](https://github.com/Ribco/quinoapackage)
- **Source:** `src/QuinoaUI.lua`
- **Installer:** `commandbar.lua`
- **License:** MIT

---

## 📜 License

QuinoaUI is licensed under the MIT License.

You are free to use, modify, and distribute the library in accordance with the license terms.

---

<p align="center">
  **Made by SCRATCH. Open Source**
  <br>
  *QuinoaUI - Build better Roblox interfaces.*
</p>
