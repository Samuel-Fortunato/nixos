{ pkgs, ... }: {
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

  home = {
    username = "samuel";
    homeDirectory = "/home/samuel";
    backupFileExtension = "bak";

    stateVersion = "26.05";
  };
}
