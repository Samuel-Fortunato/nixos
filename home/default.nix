{ ... }: {
  imports = [
    ./neovim
    ./hyprland
    ./yazi
	 ./noctalia
    ./zsh.nix
    ./packages.nix
    ./kitty.nix
    ./xdg.nix
    ./git.nix
  ];
  home = {
    username = "samuel";
    homeDirectory = "/home/samuel";
    backupFileExtension = "bak";

    stateVersion = "26.05";
  };
}
