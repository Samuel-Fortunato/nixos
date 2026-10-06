{ pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    yazi
    vim
    kitty
    stow
    zoxide
    google-chrome
    fzf
    tree
    lazygit
  ];
}
