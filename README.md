# QuinoaUI

A modern and customizable UI library for Roblox.

![Version](https://img.shields.io/badge/version-1.1.0-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Language](https://img.shields.io/badge/language-Luau-blueviolet)
![Platform](https://img.shields.io/badge/platform-Roblox-red)
[![GitHub Stars](https://img.shields.io/github/stars/Ribco/quinoapackage?style=social)](https://github.com/Ribco/quinoapackage)

QuinoaUI provides Roblox developers with a simple way to create customizable interfaces using Luau.

## Features

- Dark and Light themes
- Customizable windows
- Tabs and sections
- Buttons and toggles
- Sliders and dropdowns
- Text inputs
- Multi-selection dropdowns
- Notification system
- Optional TopbarPlus integration
- Visual Studio installer

## Installation

### Requirements

- Roblox Studio
- HTTP Requests enabled
- Internet connection

### 1. Enable HTTP Requests

1. Open Roblox Studio.
2. Navigate to **File → Experience Settings**.
3. Open the **Security** tab.
4. Enable **Allow HTTP Requests**.
5. Save your settings.

### 2. Open the Command Bar

Open the Command Bar in Roblox Studio and execute:

```lua
loadstring(game:GetService("HttpService"):GetAsync(
    "https://raw.githubusercontent.com/Ribco/quinoapackage/main/commandbar.lua"
))()
```

The QuinoaUI installer will open. Follow the instructions to configure and install the library.

> Only execute the installer from the official QuinoaUI repository.

## Getting Started

After installation, create a LocalScript inside `StarterPlayerScripts`.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuinoaUI = require(
    ReplicatedStorage:WaitForChild("QuinoaUI"):WaitForChild("QuinoaUI")
)

local Window = QuinoaUI:CreateWindow({
    Title = "My Application",
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
            Content = "Your interface is working!",
            Duration = 3
        })
    end
})
```

## Themes

QuinoaUI currently supports:

| Theme | Description |
|---|---|
| `Dark` | Dark interface appearance |
| `Light` | Light interface appearance |

Example:

```lua
local Window = QuinoaUI:CreateWindow({
    Title = "My Application",
    Theme = "Light"
})
```

## TopbarPlus Integration

QuinoaUI supports optional integration with [TopbarPlus](https://github.com/1ForeverHD/TopbarPlus).

Place the TopbarPlus package inside `ReplicatedStorage` under a folder named `TopbarPlus`.

```lua
Window:CreateTopbarToggle({
    Name = "QuinoaUI",
    Label = "Open QuinoaUI",
    Order = 1
})
```

TopbarPlus is optional.

## Documentation

- [API Reference](API.md)
- [Contributing Guide](CONTRIBUTING.md)
- [Changelog](releases/CHANGELOG.md)

## Repository Structure

```text
quinoapackage/
├── .github/
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.yml
│       └── feature_request.yml
├── plugin/
│   └── QuinoaUIInstaller.lua
├── releases/
│   └── CHANGELOG.md
├── src/
│   └── QuinoaUI.lua
├── API.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── commandbar.lua
├── installer.lua
└── manifest.json
```

## License

QuinoaUI is distributed under the MIT License. See [LICENSE](LICENSE) for details.

## Support and Issues

To report a bug or request a feature, visit the [GitHub Issues](https://github.com/Ribco/quinoapackage/issues) page.
