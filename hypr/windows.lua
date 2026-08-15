-- Personal window rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

o.window(".*", { idle_inhibit = "fullscreen" })

-- A user fastfetch config disables omarchy-launch-about's content fit, so size it here
o.window("org.omarchy.about", { size = { 780, 650 } })

o.window("^(steam)$", { tile = true })
o.window({ class = "^(steam)$", title = "^()$" }, { stay_focused = true, min_size = { 1, 1 } })

-- Unity Hub
o.window("^(unityhub)$", { float = true, center = true, size = { 1200, 800 } })

-- Unity Editor popups float
o.window({ class = "^(Unity)$", title = "^(Unity.*Hub)$" }, { float = true, center = true })
o.window({ class = "^(Unity)$", title = "^(Unity License.*)$" }, { float = true })
o.window({ class = "^(Unity)$", title = "^(Importing.*)$" }, { float = true })

-- Stop tooltip/dropdown focus steal
o.window({ class = "^(Unity)$", title = "^$" }, { no_focus = true })
o.window({ class = "^(Unity)$", title = "^(.*dropdown.*)$" }, { no_initial_focus = true })

-- Kill blur glitches, and fix the zero-size splash
-- (transparency for Unity lives in looknfeel.lua)
o.window("^(Unity)$", { no_blur = true, no_shadow = true, min_size = { 1, 1 } })
