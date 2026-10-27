--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name           = "suppress-maximize-events",
	match          = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name     = "fix-xwayland-drags",
	match    = {
		class      = "^$",
		title      = "^$",
		xwayland   = true,
		float      = true,
		fullscreen = false,
		pin        = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "calculator",

	match = { class = "^(org.gnome.Calculator)$" },
	float = true,
	-- size = { 300, 400 },
})

hl.window_rule({
	match = { class = "MATLAB.*", title = "Figures" },
	float = true,
	center = true,
	size = { 1000, 800 },
})

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

-- WhatsApp (Chrome window)
hl.window_rule({
    name = "whatsapp-workspace",
    match = {
        class = "^chrome-hnpfjngllnobngcgfapefoaidbinmjnm-Default$",
    },
    workspace = "special:W",
})

-- Spotify
hl.window_rule({
    name = "spotify-workspace",
    match = { class = "^Spotify$" },
    workspace = "special:S",
})
