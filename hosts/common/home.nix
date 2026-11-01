{ ... }:
{
  my.modules = {
    # Terminal
    kitty.enable = true;
    starship.enable = true;
    fastfetch.enable = true;
    zsh.enable = true;

    # Development tools
    git.enable = true;
    neovim.enable = true;
    lazygit.enable = true;

    # Desktop environment
    hyprland.enable = true;
    noctalia = {
      enable = true;
      musicWallpaper.enable = true;
    };

    gtk.enable = true;
    cursor.enable = true;
    xdg.enable = true;

    # Applications
    yazi.enable = true;
    zathura.enable = true;

    thunar.enable = true;
    gh.enable = true;
    btop.enable = true;
    chrome.enable = true;
    spotify.enable = true;
    tmux.enable = true;
    trash.enable = true;
    loupe.enable = true;
    udiskie.enable = true;
    calculator.enable = true;
    showtime.enable = true;
    evtest.enable = true;
  };
}
