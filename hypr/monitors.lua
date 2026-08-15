-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

hl.env("GDK_SCALE", "1")

hl.monitor({
	output = "desc:Iiyama North America PL2463H",
	mode = "1920x1080@60",
	position = "-1080x-60",
	scale = 1,
	transform = 1,
})
hl.monitor({ output = "desc:ASUSTek COMPUTER INC VG27A", mode = "2560x1440@165", position = "0x0", scale = 1 })
hl.monitor({ output = "desc:BNQ BenQ GL2250H", mode = "1920x1080@60", position = "2560x360", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.25 })
