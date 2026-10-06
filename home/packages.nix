{ pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    yazi
    vim
    kitty
    stow
    google-chrome
    fzf
    tree
    lazygit
  ];
}
