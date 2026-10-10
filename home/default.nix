{ ... }: {
  imports = [
    ./neovim
    ./hyprland
    ./yazi
	 ./noctalia
	 ./proton-drive.nix
    ./zsh.nix
    ./packages.nix
    ./kitty.nix
    ./xdg.nix
    ./git.nix
	 ./zathura.nix
  ];
  home = {
    username = "samuel";
    homeDirectory = "/home/samuel";
    backupFileExtension = "bak";

    stateVersion = "26.05";
  };
}
