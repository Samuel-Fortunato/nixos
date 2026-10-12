{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";

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
    hyprland = {
      enable = true;
      withUWSM = true;
    };
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

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
    config = {
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      };
    };
  };

  system.stateVersion = "26.05";
}
