{ pkgs, ... }: {
  home.packages = with pkgs; [
    tree
    noto-fonts
  ];
}
