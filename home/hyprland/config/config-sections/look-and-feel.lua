-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in       = 3,
		gaps_out      = 5,


		allow_tearing = true,
		layout        = "dwindle",
	},

	decoration = {
		rounding           = 10,
		rounding_power     = 2,

		-- Change transparency of focused and unfocused windows
		-- active_opacity     = 0.95,
		-- inactive_opacity   = 0.85,
		-- fullscreen_opacity = 1.0,

		shadow             = {
			enabled      = true,
			range        = 4,
			render_power = 3,
			color        = 0xee1a1a1a,
		},

		blur               = {
			enabled           = true,
			size              = 3,
			passes            = 2,
			vibrancy          = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	xwayland = {
		force_zero_scaling = true
	}

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
