{ pkgs, ... }: {
  home.packages = with pkgs; [
    tree
    noto-fonts
    socat
    imagemagick
    jq
    libnotify
  ];
}
