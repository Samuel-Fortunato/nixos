local colors = require("hyprland.colors")
-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in              = 3,
		gaps_out             = 5,

		border_size          = 4,

		col                  = {
			active_border   = { colors = { "#fafc21", "#fa3d7b" }, angle = 45 },
			inactive_border = "#ddd",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border     = false,
		hover_icon_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing        = false,

		layout               = "dwindle",
	},

	decoration = {
		rounding           = 10,
		rounding_power     = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity     = 0.95,
		inactive_opacity   = 0.85,
		fullscreen_opacity = 1.0,

		shadow             = {
			enabled      = false,
			range        = 20,
			render_power = 3,
			color        = 0xee1a1a1a,
		},

		blur               = {
			enabled           = true,
			size              = 6,
			passes            = 3,
			new_optimizations = true,
			xray              = false,
			noise             = 0.012,
			contrast          = 0.9,
			brightness        = 0.85,
			vibrancy          = 0.2,
			vibrancy_darkness = 0.0,
		},
	},

	animations = {
		enabled = true,
	},

	-- xwayland {
	-- 	force_zero_scaling = true
	-- }

})


-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
	name        = "no-gaps-wtv1",
	match       = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding    = 0,
})
hl.window_rule({
	name        = "no-gaps-f1",
	match       = { float = false, workspace = "f[1]" },
	border_size = 0,
	rounding    = 0,
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
		force_split = 2
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})
