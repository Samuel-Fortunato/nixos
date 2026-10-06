------------------:colorscheme pywal16
---
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
local monitorScaleFactor = 1.2
hl.monitor({
	output   = "",
	mode     = "highres",
	-- position = "auto",
	scale    = monitorScaleFactor,
	mirror = "HDMI-A-1"
	-- disabled = true,
})

hl.monitor({
	output   = "HDMI-A-1",
	mode     = "highres",
	-- position = "auto-center-up",
	scale    = 1,
})
