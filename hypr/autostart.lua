-- Extra autostart processes.

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

  -- Hyprland doesn't load hyprpm plugins on its own; this loads every enabled
  -- one. The config reload afterwards is what applies looknfeel.lua's
  -- hl.plugin.hyprglass block, which is skipped while the plugin is absent.
  hl.exec_cmd("hyprpm reload && hyprctl reload")
end)
