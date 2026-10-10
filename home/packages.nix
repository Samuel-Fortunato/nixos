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
    fastfetch
    nerd-fonts.jetbrains-mono
    spotify
	 rclone
  ];
}
