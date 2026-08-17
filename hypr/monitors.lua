-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

hl.env("GDK_SCALE", "1")

hl.monitor({ output = "desc:Samsung Display Corp. 0x414D", mode = "3456x2160@60", position = "0x740", scale = 2 })
hl.monitor({ output = "desc:Dell Inc. DELL U3415W", mode = "3440x1440@59.97", position = "1728x560", scale = 1 })
hl.monitor({
	output = "desc:Dell Inc. DELL U2518D",
	mode = "2560x1440@59.95",
	position = "5168x0",
	scale = 1,
	transform = 3,
})
