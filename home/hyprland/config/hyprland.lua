require("config-sections.monitors")
require("config-sections.autostart")
require("config-sections.environment")
require("config-sections.permissions")
require("config-sections.look-and-feel")
require("config-sections.animations")
require("config-sections.misc")
require("config-sections.input")
require("config-sections.keybindings")
require("config-sections.windows-and-workspaces")


-- For Noctalia color templates
local ok, noctalia = pcall(require, "noctalia")
if ok then noctalia.apply_theme() end
