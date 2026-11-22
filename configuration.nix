{
  pkgs,
  lib,
  ...
}: {
  imports =
    builtins.filter (path: lib.hasSuffix ".nix" (toString path))
    (
      lib.filesystem.listFilesRecursive ./modules/nixos
      ++ lib.filesystem.listFilesRecursive ./profiles/nixos
    );

  # Nix configuration
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Localization
  time.timeZone = "Europe/Lisbon";

  # keyboard layout
  services.xserver.xkb.layout = "pt";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings.LC_TIME = "en_GB.UTF-8";
  };

  # Users
  users = {
    defaultUserShell = pkgs.zsh;

    users.samuel = {
      isNormalUser = true;
      extraGroups = ["wheel"];
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

  environment.pathsToLink = ["/share/zsh"];
}
