{ ... }:

{
  imports = [
      ./neovim
      ./hyprland
      ./yazi
      ./zsh.nix
      ./noctalia.nix
      ./packages.nix
      ./kitty.nix
		./xdg.nix
		./git.nix
  ];

  home.username = "samuel";
  home.homeDirectory = "/home/samuel";
  home.stateVersion = "26.05";
}
