{ pkgs, ... }: {
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
	 ./gtk.nix
	 ./matlab.nix
  ];
  home = {
    username = "samuel";
    homeDirectory = "/home/samuel";
    backupFileExtension = "bak";

    pointerCursor = {
		enable = true;

      name = "Bibata-Modern-Ice";
		package = pkgs.bibata-cursors;
		size = 20;

		gtk.enable = true;
		x11.enable = true;
		hyprcursor.enable = true;
	 };

    stateVersion = "26.05";
  };
}
