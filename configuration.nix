{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.samuel = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };

  # List packages installed in system profile. You can use https://search.nixos.org/ to find more packages (and options).
  environment = {
    variables = {
      SUDO_EDITOR = "nvim";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      wl-clipboard
      glib
    ];
  };

  programs.git = {
    enable = true;

    config = {
      user.name = "Samuel-Fortunato";
      user.email = "samff2006@gmail.com";
    };
  };

  services.displayManager.ly.enable = true;
  services.power-profiles-daemon.enable = true;

  home-manager.users.samuel = {
    imports = [
      ./home
    ];

    home.username = "samuel";
    home.homeDirectory = "/home/samuel";

    home.stateVersion = "26.05";
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
