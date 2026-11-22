----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper         = 0,
		disable_hyprland_logo           = true,
		disable_splash_rendering        = true,

		float_force_onscreen            = 1,
		initial_workspace_token_timeout = 3600,
	},
	xwayland = {
		force_zero_scaling = true
	},
})

-- Virtio-GPU compatibility workarounds
if os.getenv("HYPRLAND_VIRTIO_WORKAROUND") == "1" then
    hl.config({
        quirks = {
            skip_non_kms_dmabuf_formats = false,
        }
    })
end
