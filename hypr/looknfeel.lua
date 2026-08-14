-- Change the default Omarchy look'n'feel.

hl.config({
	general = {
		gaps_in = 8,
		gaps_out = 16,
		border_size = 0,
	},

	decoration = {
		rounding = 36,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		blur = {
			size = 8,
		},

		-- Soft, wide, low-opacity drop shadow - macOS window elevation
		shadow = {
			enabled = true,
			range = 20,
			render_power = 3,
			color = "rgba(00000059)",
			offset = { 0, 6 },
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = false,
	},
})

hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slidefade" })

-- Uniform whole-window transparency. Window rules beat decoration:active_opacity,
-- and Omarchy pins several groups at near-opaque values in default/hypr/apps
-- (terminal 0.985/0.96, browsers 1.0/0.985), so each group needs its own override
-- or it stays opaque.
o.window({ tag = "default-opacity" }, { opacity = "0.88 0.82" })
o.window({ tag = "terminal" }, { opacity = "0.88 0.72" })
o.window({ tag = "firefox-based-browser" }, { opacity = "0.88 0.82" })
o.window({ tag = "chromium-based-browser" }, { opacity = "0.88 0.82" })

-- Omarchy pins steam and Unity at opacity 1 via class rules, so both need the
-- default-opacity tag dropped along with their own opacity.
o.window("steam.*", { tag = "-default-opacity", opacity = "0.72 0.62" })
o.window("^(Unity|unityhub)$", { tag = "-default-opacity", opacity = "0.88 0.82" })

-- Skipped when hyprpm hasn't loaded the plugin yet, so a plugin-less session
-- still gets a working config.
if hl.plugin.hyprglass then
	local hyprglass = hl.plugin.hyprglass

	-- No presets on purpose: every value here is the live one. Edit and save,
	-- Hyprland auto-reloads and the plugin repaints instantly.
	-- (A default_preset would silently override most of these.)
	hyprglass.config({
		enabled = true,
		default_theme = "dark",

		-- material
		glass_opacity = 1.2,
		blur_strength = 0.8,
		blur_iterations = 4,
		tint_color = 0xffffff00,

		-- edge curvature: band width is edge_thickness * shorter window side;
		-- refraction_strength * 50 = px of inward pull. Keep them in proportion.
		edge_thickness = 0.008,
		refraction_strength = 3.2,
		chromatic_aberration = 0.4,
		fresnel_strength = 1.0,
		lens_distortion = 4.0,

		-- tone
		brightness = 1.1,
		contrast = 1.33,
		saturation = 1.0,
		vibrancy = 0.0,
		vibrancy_darkness = 0.0,
		-- dims only bright backdrops - the text legibility knob
		adaptive_dim = 0.0,
		adaptive_boost = 0.0,

		layers = { enabled = 1 },
	})

	-- Quattro replaced waybar/walker with the Quickshell bar and menus.
	-- hyprglass.layer("omarchy-bar")
	-- hyprglass.layer("omarchy-menu")
end
