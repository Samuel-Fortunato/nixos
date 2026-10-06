{ pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    yazi
    vim
    kitty
    google-chrome
    fzf
    tree
    lazygit
  ];
}
