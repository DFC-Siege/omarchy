hl.monitor({ output = "desc:Dell Inc. DELL U3415W", mode = "3440x1440@59.97", position = "1728x560", scale = 1 })
hl.monitor({
	output = "desc:Dell Inc. DELL U2518D",
	mode = "2560x1440@59.95",
	position = "5168x0",
	scale = 1,
	transform = 3,
})

hl.config({
	render = {
		expand_undersized_textures = false,
	},

	layout = {
		single_window_aspect_ratio = { 16, 9 },
		single_window_aspect_ratio_tolerance = 0.1,
	},
})
