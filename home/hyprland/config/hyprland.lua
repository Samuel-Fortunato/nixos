require("hyprland.monitors")
require("hyprland.autostart")
require("hyprland.environment")
require("hyprland.permissions")
require("hyprland.look-and-feel")
require("hyprland.animations")
require("hyprland.misc")
require("hyprland.input")
require("hyprland.keybindings")
require("hyprland.windows-and-workspaces")


-- For Noctalia color templates
local ok, noctalia = pcall(require, "noctalia")
if ok then noctalia.apply_theme() end
