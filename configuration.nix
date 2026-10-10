{
  config,
  lib,
  pkgs,
  ...
}:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

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

  virtualisation.libvirtd.enable = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";

  programs = {
    virt-manager.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    zsh.enable = true;
	 steam.enable = true;
  };

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
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      wl-clipboard
      glib
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
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
  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandleLidSwitch = "ignore";
  };
  security.polkit.enable = true;

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

  system.stateVersion = "26.05"; # Did you read the comment?
}
