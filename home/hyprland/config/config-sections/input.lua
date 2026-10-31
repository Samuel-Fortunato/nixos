---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout          = "pt",
		kb_variant         = "",
		kb_model           = "",
		kb_options         = "",
		numlock_by_default = true,

		follow_mouse       = 1,
		sensitivity        = -0.4,
		accel_profile      = "flat",

		touchpad           = {
			natural_scroll = true,
			scroll_factor = 0.5,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name = "elan06fa:00-04f3:327e-touchpad",
	sensitivity = 0,
	accel_profile = "adaptive"
})
