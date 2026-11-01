{ pkgs, lib, ... }:
{
  imports = lib.filesystem.listFilesRecursive ./modules/nixos;

  # Nix configuration
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Localization
  time.timeZone = "Europe/Lisbon";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings.LC_TIME = "en_GB.UTF-8";
  };

  # Users
  users = {
    defaultUserShell = pkgs.zsh;

    users.samuel = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  # Console applications
  programs = {
    zsh.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];
}
