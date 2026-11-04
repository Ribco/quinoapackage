# QuinoaUI API Reference

This document describes the available QuinoaUI methods and basic usage.

## Loading QuinoaUI

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuinoaUI = require(
    ReplicatedStorage:WaitForChild("QuinoaUI"):WaitForChild("QuinoaUI")
)
```

## Creating a Window

```lua
local Window = QuinoaUI:CreateWindow({
    Title = "My Application",
    Theme = "Dark"
})
```

### Configuration

| Property | Type | Description |
|---|---|---|
| `Title` | string | Window title |
| `Theme` | string | `Dark` or `Light` |

## Window Methods

| Method | Description |
|---|---|
| `Window:Open()` | Opens the window |
| `Window:Close()` | Closes the window |
| `Window:Toggle()` | Toggles window visibility |
| `Window:Minimize()` | Minimizes the window |
| `Window:SetTitle(title)` | Changes the window title |
| `Window:SetTheme(theme)` | Changes the window theme |
| `Window:Destroy()` | Destroys the window |
| `Window:Notify(config)` | Displays a notification |
| `Window:CreateTab(config)` | Creates a tab |
| `Window:GetTab(name)` | Gets a tab by name |
| `Window:GetActiveTab()` | Gets the active tab |
| `Window:CreateTopbarToggle(config)` | Creates a TopbarPlus toggle |

## Creating Tabs

```lua
local Home = Window:CreateTab({
    Name = "Home",
    Icon = "🏠"
})
```

### Tab Methods

| Method | Description |
|---|---|
| `Tab:Show()` | Shows the tab |
| `Tab:Hide()` | Hides the tab |
| `Tab:Destroy()` | Destroys the tab |
| `Tab:CreateSection(config)` | Creates a section |

## Creating Sections

```lua
local Section = Home:CreateSection({
    Name = "Welcome"
})
```

## Section Components

### Label

```lua
Section:CreateLabel({
    Name = "Welcome to QuinoaUI!"
})
```

### Divider

```lua
Section:CreateDivider()
```

### Button

```lua
Section:CreateButton({
    Name = "Click me!",
    Callback = function()
        print("Button clicked!")
    end
})
```

### Toggle

```lua
Section:CreateToggle({
    Name = "Example Toggle",
    Callback = function(value)
        print("Toggle changed:", value)
    end
})
```

### Slider

```lua
Section:CreateSlider({
    Name = "Example Slider",
    Callback = function(value)
        print("Slider changed:", value)
    end
})
```

### Dropdown

```lua
Section:CreateDropdown({
    Name = "Example Dropdown",
    Callback = function(value)
        print("Selected:", value)
    end
})
```

### Input

```lua
Section:CreateInput({
    Name = "Example Input",
    Callback = function(value)
        print("Input:", value)
    end
})
```

### Multi Dropdown

```lua
Section:CreateMultiDropdown({
    Name = "Example Multi Dropdown",
    Callback = function(values)
        print("Selected values:", values)
    end
})
```

## Notifications

```lua
Window:Notify({
    Title = "QuinoaUI",
    Content = "Your interface is ready!",
    Duration = 3
})
```

## TopbarPlus Integration

QuinoaUI supports optional integration with the official TopbarPlus package.

Repository: https://github.com/1ForeverHD/TopbarPlus

Place the package inside `ReplicatedStorage` under a folder named `TopbarPlus`.

```lua
Window:CreateTopbarToggle({
    Name = "QuinoaUI",
    Label = "Open QuinoaUI",
    Order = 1
})
```

TopbarPlus is optional.

## Complete Example

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuinoaUI = require(
    ReplicatedStorage:WaitForChild("QuinoaUI"):WaitForChild("QuinoaUI")
)

local Window = QuinoaUI:CreateWindow({
    Title = "QuinoaUI Example",
    Theme = "Dark"
})

local Home = Window:CreateTab({
    Name = "Home",
    Icon = "🏠"
})

local Section = Home:CreateSection({
    Name = "Getting Started"
})

Section:CreateLabel({
    Name = "Welcome to QuinoaUI!"
})

Section:CreateButton({
    Name = "Test Notification",
    Callback = function()
        Window:Notify({
            Title = "QuinoaUI",
            Content = "Everything is working!",
            Duration = 3
        })
    end
})
```

## Notes

- QuinoaUI should be loaded from a LocalScript for client-side interface usage.
- TopbarPlus is optional.
- Configuration properties and component behavior may change between releases.
- Refer to the source code for the exact supported configuration options.

[Back to README](README.md)
