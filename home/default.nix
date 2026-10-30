{ config, pkgs, ... }: {
  imports = [
    ./neovim
    ./hyprland
    ./yazi
    ./noctalia
    ./music-wallpaper
    ./fastfetch
    ./proton-drive.nix
    ./zsh.nix
    ./packages.nix
    ./kitty.nix
    ./xdg.nix
    ./git.nix
    ./zathura.nix
    ./gtk.nix
    ./matlab.nix
    ./onlyoffice.nix
    ./latex.nix
    ./starship.nix
    ./apps.nix
    ./cursor.nix
  ];

  xdg.configFile."home-manager".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos";

  home = {
    username = "samuel";
    homeDirectory = "/home/samuel";
    backupFileExtension = "bak";

    stateVersion = "26.05";
  };
}
