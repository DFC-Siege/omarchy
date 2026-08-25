-- Personal keybinding overrides.
-- See current bindings and descriptions: omarchy menu keybindings --print

local smart_move = require("hypr.smart_move")

-- Apps
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + B", "Browser", { launch = "zen-browser --new-window" })
o.bind("SUPER + D", "Docker", { tui = "lazydocker" })
o.bind("SUPER + A", "WhatsApp", { webapp = "https://web.whatsapp.com/" })

hl.unbind("SUPER + SHIFT + B") -- was: Browser
o.bind("SUPER + SHIFT + B", "Browser (private)", { launch = "zen-browser --private-window" })

hl.unbind("SUPER + T") -- was: Toggle window floating/tiling
o.bind("SUPER + T", "Activity", { tui = "btop" })

-- Menus
o.bind("SUPER + Super_L", "Apps menu", "omarchy-menu toggle apps")

hl.unbind("SUPER + ALT + K") -- was: Tmux keybindings
o.bind("SUPER + ALT + K", "Keybindings", "omarchy-menu-keybindings")

-- Window management
hl.unbind("SUPER + W") -- was: Close window
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

hl.unbind("SUPER + SHIFT + F") -- was: File manager
o.bind("SUPER + SHIFT + F", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

hl.unbind("SUPER + V") -- was: Universal paste
o.bind("SUPER + V", "Toggle window split", hl.dsp.layout("togglesplit"))

hl.unbind("SUPER + L") -- was: Toggle workspace layout
o.bind("SUPER + M", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Focus windows (hjkl vim-style)
hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")
hl.unbind("SUPER + J") -- was: Toggle window split
hl.unbind("SUPER + K") -- was: Keybindings

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Move windows (shift + hjkl)
hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")

o.bind("SUPER + SHIFT + H", "Move window left", function()
	smart_move.move("l")
end)
o.bind("SUPER + SHIFT + J", "Move window down", function()
	smart_move.move("d")
end)
o.bind("SUPER + SHIFT + K", "Move window up", function()
	smart_move.move("u")
end)
o.bind("SUPER + SHIFT + L", "Move window right", function()
	smart_move.move("r")
end)

-- Resize windows
o.bind("SUPER + semicolon", "Shrink window width", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + SHIFT + semicolon", "Grow window width", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + apostrophe", "Shrink window height", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + SHIFT + apostrophe", "Grow window height", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

-- Scratchpad (SUPER + S toggles it by default)
hl.unbind("SUPER + SHIFT + S") -- was: Google Maps
o.bind(
	"SUPER + SHIFT + S",
	"Move window to scratchpad",
	hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })
)

local function plain_scratchpad()
	hl.workspace_rule({
		workspace = "special:scratchpad",
		on_created_empty = "",
		gaps_in = 8,
		gaps_out = { top = 16, right = 16, bottom = 16, left = 16 },
	})
end

plain_scratchpad()
hl.on("monitor.layout_changed", plain_scratchpad)
hl.on("monitor.focused", plain_scratchpad)

-- Screenshots and screen recording (moved from PRINT to P combinations)
hl.unbind("PRINT")
hl.unbind("ALT + PRINT")
hl.unbind("SUPER + PRINT") -- was: Color picker

hl.unbind("SUPER + P") -- was: Pseudo window
o.bind("SUPER + P", "Screenshot area", "omarchy-capture-screenshot")

hl.unbind("SUPER + SHIFT + P") -- was: Google Photos
o.bind("SUPER + SHIFT + P", "Screenshot window", "omarchy-capture-screenshot windows")

hl.unbind("SUPER + CTRL + P") -- was: Power panel
o.bind("SUPER + CTRL + P", "Screenshot display", "omarchy-capture-screenshot fullscreen")

o.bind(
	"SUPER + ALT + P",
	"Screen record region",
	"omarchy-capture-screenrecording --stop-recording || omarchy-capture-screenrecording"
)
o.bind(
	"SUPER + CTRL + ALT + P",
	"Screen record display",
	"omarchy-capture-screenrecording --stop-recording || omarchy-capture-screenrecording --fullscreen"
)
o.bind("SUPER + SHIFT + CTRL + P", "Color picker", "pkill hyprpicker || hyprpicker -a")

-- Grouping (SUPER + G and SUPER + ALT + G keep their defaults)
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
hl.unbind("SUPER + ALT + UP")
hl.unbind("SUPER + ALT + DOWN")

o.bind("SUPER + SHIFT + ALT + H", "Move window into/out of group left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + SHIFT + ALT + J", "Move window into/out of group down", hl.dsp.window.move({ into_group = "d" }))
o.bind("SUPER + SHIFT + ALT + K", "Move window into/out of group up", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + SHIFT + ALT + L", "Move window into/out of group right", hl.dsp.window.move({ into_group = "r" }))

o.bind("SUPER + CTRL + ALT + H", "Move tab left in group", hl.dsp.group.move_window({ forward = false }))
o.bind("SUPER + CTRL + ALT + L", "Move tab right in group", hl.dsp.group.move_window({ forward = true }))

o.bind("SUPER + ALT + H", "Previous window in group", hl.dsp.group.prev())
o.bind("SUPER + ALT + L", "Next window in group", hl.dsp.group.next())

-- Move workspaces between monitors
hl.unbind("SUPER + SHIFT + ALT + LEFT")
hl.unbind("SUPER + SHIFT + ALT + RIGHT")
hl.unbind("SUPER + SHIFT + ALT + UP")
hl.unbind("SUPER + SHIFT + ALT + DOWN")

o.bind("SUPER + SHIFT + CTRL + LEFT", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + SHIFT + CTRL + RIGHT", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
o.bind("SUPER + SHIFT + CTRL + UP", "Move workspace to upper monitor", hl.dsp.workspace.move({ monitor = "u" }))
o.bind("SUPER + SHIFT + CTRL + DOWN", "Move workspace to bottom monitor", hl.dsp.workspace.move({ monitor = "d" }))
