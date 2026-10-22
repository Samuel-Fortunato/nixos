{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      background_opacity = "0.85";

      cursor_trail = 3;
      cursor_trail_start_threshold = 0;
    };

    extraConfig = "globinclude themes/noctalia.conf";
  };
}
