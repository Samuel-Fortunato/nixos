{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/nixos/hyprland.nix
  ];

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8";
    };
  };

  security.polkit.enable = true;
  documentation.man.cache.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader = {
    timeout = 0;
    grub = {
      configurationLimit = 5;
      timeoutStyle = "hidden";
      theme = null;
      splashImage = null;
      backgroundColor = "#000000";
    };
  };

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
        "networkmanager"
        "dialout"
        "input"
      ];
    };
  };

  services = {
    displayManager.ly = {
      enable = true;
      settings = {
        bigclock = true;
        session_log = null;
      };
    };
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    udisks2.enable = true;
    upower = {
      enable = true;
      allowRiskyCriticalPowerAction = true;
      criticalPowerAction = "Suspend";
    };
    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "ignore";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      wl-clipboard
      glib
    ];
  };

  programs = {
    zsh.enable = true;
    steam.enable = true;
    gpu-screen-recorder.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  system.stateVersion = "26.05";
}
