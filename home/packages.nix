{ pkgs, ... }: {
  home.packages = with pkgs; [
	 thunar
    gh
    yazi
    # vim
    google-chrome
    fzf
    tree
    lazygit
    fastfetch
    nerd-fonts.jetbrains-mono
    spotify
  ];
}
