-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in       = 3,
		gaps_out      = 5,
		border_size   = 2,

		allow_tearing = true,
		layout        = "dwindle",
	},

	decoration = {
		rounding = 30,
		rounding_power = 1,

		-- active_opacity = 0.65,
		-- inactive_opacity = 0.55,
		-- fullscreen_opacity = 1.0,
	},

	xwayland = {
		force_zero_scaling = true
	}

})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
		force_split = 2,

		precise_mouse_move = true,
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
