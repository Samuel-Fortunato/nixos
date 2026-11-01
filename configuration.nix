{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/nixos/hyprland.nix
    ./modules/nixos/fonts.nix
    ./modules/nixos/ly.nix
    ./modules/nixos/pipewire.nix
	 ./modules/nixos/grub.nix
	 ./modules/nixos/networkmanager.nix
  ];

  time.timeZone = "Europe/Lisbon";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8";
    };
  };


  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.samuel = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
    };
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
  };

  programs = {
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

}
