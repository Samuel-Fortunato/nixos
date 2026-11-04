{...}: {
  my.modules = {
    # Shell and terminal
    zsh.enable = true;
    kitty.enable = true;
    starship.enable = true;
    fastfetch.enable = true;

    # Development tools
    git.enable = true;
    neovim.enable = true;
    lazygit.enable = true;
    gh.enable = true;

    # Desktop environment
    hyprland.enable = true;

    noctalia = {
      enable = true;
      musicWallpaper.enable = true;
    };

    # keyring
    seahorse.enable = true;

    # Appearance and desktop integration
    gtk.enable = true;
    cursor.enable = true;
    xdg.enable = true;

    # File management
    yazi.enable = true;
    thunar.enable = true;
    trash.enable = true;
    udiskie.enable = true;

    # Applications
    chrome.enable = true;
    spotify.enable = true;
    zathura.enable = true;
    loupe.enable = true;
    showtime.enable = true;
    calculator.enable = true;

    # Password manager
    proton-pass.enable = true;

    # Utilities
    btop.enable = true;
    tmux.enable = true;
    evtest.enable = true;
  };
}
