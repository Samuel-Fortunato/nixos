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

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

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

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

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
        "libvirtd"
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
      neovim
      git
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

  services.displayManager.ly = {
    enable = true;
    settings = {
      bigclock = true;
    };
  };
  services.power-profiles-daemon.enable = true;
  services.accounts-daemon.enable = true;
  services.upower = {
    enable = true;
    allowRiskyCriticalPowerAction = true;
    criticalPowerAction = "Suspend";
  };
  services.logind = {
    powerKey = "suspend";
    lidSwitch = "ignore";
  };
  security.polkit.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
