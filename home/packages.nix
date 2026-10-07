{ pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    yazi
    vim
    google-chrome
    fzf
    tree
    lazygit
    fastfetch
    nerd-fonts.jetbrains-mono
  ];
}
