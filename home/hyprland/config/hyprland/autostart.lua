local prog = require("hyprland.programs")
-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	-- hl.exec_cmd(prog.waybar)
	-- hl.exec_cmd(prog.stayFree)
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("powernotd")
	-- hl.exec_cmd("awww-daemon")
	-- hl.exec_cmd("dunst")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
	-- hl.exec_cmd("udiskie --tray")
end)
