local prog = require("hyprland.programs")
---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local ipc = "noctalia msg "

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
local shutdownHyprlandBind = hl.bind(mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
shutdownHyprlandBind:set_enabled(false)

hl.bind(mainMod .. " + D", hl.dsp.window.float())
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.pin())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
-- focus next window
-- hl.bind("SUPER + Tab", function()
-- 	hl.dispatch(hl.dsp.window.cycle_next())
-- 	hl.dispatch(hl.dsp.window.bring_to_top())
-- end)


-- Move windows arround
local function move_window(direction, dx, dy)
	return function()
		local win = hl.get_active_window()
		if win == nil then return end

		if win.floating then
			hl.dispatch(hl.dsp.window.move({
				x = dx,
				y = dy,
				relative = true
			}))
		else
			hl.dispatch(hl.dsp.window.move({
				direction = direction
			}))
		end
	end
end

hl.bind(mainMod .. " + SHIFT + h", move_window("left", -30, 0), { repeating = true })
hl.bind(mainMod .. " + SHIFT + l", move_window("right", 30, 0), { repeating = true })
hl.bind(mainMod .. " + SHIFT + k", move_window("up", 0, -30), { repeating = true })
hl.bind(mainMod .. " + SHIFT + j", move_window("down", 0, 30), { repeating = true })



-- Resize windows
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
for _, letter in ipairs({ "W", "S", "A" }) do
	hl.bind(mainMod .. " + " .. letter, hl.dsp.workspace.toggle_special(letter))
	hl.bind(mainMod .. " + SHIFT + " .. letter, hl.dsp.window.move({ workspace = "special:" .. letter }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up 2"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down 2"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "media next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "media toggle"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(ipc .. "media next-player"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "media previous"), { locked = true })

-- Rotate monitor
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.exec_cmd(
	"hyprctl eval 'hl.monitor({ output = \"\", transform=0 })'"
))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.exec_cmd(
	"hyprctl eval 'hl.monitor({ output = \"\", transform=1 })'"
))
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.exec_cmd(
	"hyprctl eval 'hl.monitor({ output = \"\", transform=2 })'"
))
hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.exec_cmd(
	"hyprctl eval 'hl.monitor({ output = \"\", transform=3 })'"
))

-- apps
hl.bind(mainMod .. " + ccedilla", hl.dsp.exec_cmd(prog.browser))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(prog.terminal))
hl.bind("XF86Calculator", hl.dsp.exec_cmd(prog.calculator))
hl.bind("PRINT", hl.dsp.exec_cmd(ipc .. "screenshot-region"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen pick"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd(ipc .. "screenshot-annotate"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(prog.fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(prog.guiFileManager))

hl.bind(mainMod .. "+P", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
hl.bind(mainMod .. "+V", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
hl.bind(mainMod .. "+T", hl.dsp.exec_cmd(ipc .. "panel-toggle ashur-d/wallpaper-widget:hub"))

hl.bind(mainMod .. "+SUPER_l", hl.dsp.submap("double-click"))
hl.bind(mainMod .. "+SUPER_l", hl.dsp.exec_cmd("sleep 0.4 && hyprctl dispatch 'hl.dsp.submap(\"reset\")'"))
hl.define_submap("double-click", function()
	hl.bind(mainMod .. "+SUPER_l", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
end)

hl.bind(mainMod .. "+PERIOD", hl.dsp.exec_cmd(ipc .. "notification-clear-active"))
hl.bind(mainMod .. "+SHIFT+PERIOD", hl.dsp.exec_cmd(ipc .. "notification-invoke-latest"))
hl.bind(mainMod .. "+CTRL+PERIOD", hl.dsp.exec_cmd(ipc .. "notification-dnd-toggle"))
hl.bind(mainMod .. "+N", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center notifications"))

hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))

hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher hold"))
hl.bind("CTRL + ESCAPE", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center system"))
hl.bind(mainMod .. " + BACKSLASH", hl.dsp.exec_cmd(ipc .. "bar-toggle"))
