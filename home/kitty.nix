{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      cursor_trail = 3;
		cursor_trail_start_threshold = 0;
      custom_shaders = "cursor-trail-motion-blur";
      # custom_shaders = "cursor-trail-blaze";
    };
    extraConfig = "globinclude themes/noctalia.conf";
  };
}
