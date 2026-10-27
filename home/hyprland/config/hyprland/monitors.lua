------------------
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

hl.monitor({
	output = "Virtual-1";
	mode = "1600x1200@60"
})
