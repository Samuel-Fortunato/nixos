{ pkgs, ... }: {
  home.packages = with pkgs; [
    thunar
    gh
    yazi
    btop
    google-chrome
    fzf
    tree
    lazygit
    nerd-fonts.jetbrains-mono
    noto-fonts
    spotify
    rclone
    tmux
    distrobox
    trash-cli
    loupe
    socat
    udiskie
    imagemagick
    gnome-calculator
  ];
}
