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

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)


-- -- Workspaces 1-5 always on the first monitor detected
-- for i = 1, 5 do
-- 	hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-2" })
-- end
-- --
-- -- -- Workspaces 6-10 always on the second monitor IF it exists
-- -- -- If index:1 doesn't exist, Hyprland will default these to index:0
-- for i = 6, 10 do
-- 	hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
-- end
-- hl.workspace_rule({ workspace = "1", monitor = "eDP-2" })
-- hl.workspace_rule({ workspace = "2", monitor = "eDP-2" })
-- hl.workspace_rule({ workspace = "3", monitor = "eDP-2" })
-- hl.workspace_rule({ workspace = "4", monitor = "eDP-2" })
-- hl.workspace_rule({ workspace = "5", monitor = "eDP-2" })
--
-- hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })


-- Hyprland-run windowrule
hl.window_rule({
	name  = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move  = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "volume-control",
	match = { class = "^(org.pulseaudio.pavucontrol)$" },

	float = true,
	pin = true,
	size = { 880, 600 },
	center = true,
})

hl.window_rule({
	name = "bluetooth-manager",
	match = { class = "^(blueman-manager)$" },

	float = true,
	pin = true,
	size = { 600, 400 },
	center = true,
})

hl.window_rule({
	name = "network-manager",
	match = { class = "^(org.nmrs.ui)$" },

	float = true,
	pin = true,
	size = { 600, 500 },
	center = true,
})

hl.window_rule({
	name = "calculator",

	match = { class = "^(org.kde.kcalc)$" },
	float = true,
	-- size = { 300, 400 },
})

hl.window_rule({
	name = "bitwarden",

	match = { class = "chrome-nngceckbapebfimnlniiiahkandclblb-Default" },
	float = true,
})
