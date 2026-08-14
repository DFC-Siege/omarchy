-- Extra autostart processes.

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

  -- Hyprland doesn't load hyprpm plugins on its own; this loads every enabled one.
  hl.exec_cmd("hyprpm reload")
end)
