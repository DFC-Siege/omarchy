hl.config({
	general = {
		gaps_in = 8,
		gaps_out = 16,
		border_size = 2,
	},

	decoration = {
		rounding = 32,

		blur = {
			enabled = false,
			size = 8,
		},

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

hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 2.5, bezier = "easeOutQuint" })

o.window({ tag = "default-opacity" }, { opacity = "0.88 0.82" })
o.window({ tag = "terminal" }, { opacity = "0.88 0.72" })
o.window({ tag = "firefox-based-browser" }, { opacity = "0.88 0.82" })
o.window({ tag = "chromium-based-browser" }, { opacity = "0.88 0.82" })
o.window("steam.*", { tag = "-default-opacity", opacity = "0.88 0.82" })
o.window("^(Unity|unityhub)$", { tag = "-default-opacity", opacity = "0.88 0.82" })

if hl.plugin.hyprglass then
	local hyprglass = hl.plugin.hyprglass

	hyprglass.config({
		enabled = true,
		default_theme = "dark",

		glass_opacity = 1.2,
		blur_strength = 0.8,
		blur_iterations = 4,
		tint_color = 0xffffff00,

		edge_thickness = 0.008,
		refraction_strength = 3.2,
		chromatic_aberration = 0.4,
		fresnel_strength = 1.0,
		lens_distortion = 4.0,

		brightness = 1.1,
		contrast = 1.33,
		saturation = 1.0,
		vibrancy = 0.0,
		vibrancy_darkness = 0.0,
		adaptive_dim = 0.0,
		adaptive_boost = 0.0,

		layers = { enabled = 1 },
	})

	hyprglass.layer("omarchy-bar")
	hyprglass.layer("omarchy-menu")

	for _, namespace in ipairs({
		"omarchy-image-selector",
		"omarchy-emojis",
		"omarchy-clipboard",
		"omarchy-keyboard-panel",
		"omarchy-notifications",
		"omarchy-osd",
	}) do
		hyprglass.layer(namespace, { exclude = true })
	end
end
