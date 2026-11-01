{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  my.modules.fonts.enable = true;
  documentation.man.cache.enable = true;

  # Graphical environment
  services.displayManager.ly.enable = true;
  services.pipewire.enable = true;

  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.udisks2.enable = true;

  # Laptop-specific hardware and power management
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services = {
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      allowRiskyCriticalPowerAction = true;
      criticalPowerAction = "Suspend";
    };

    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "ignore";
    };
  };

  # Laptop-specific applications
  programs.steam.enable = true;
  programs.gpu-screen-recorder.enable = true;

  networking = {
    networkmanager.enable = true;
    hostName = "nixos-laptop";
  };
  programs.hyprland.enable = true;

  # GPU acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
  };

  # Virtualization (distrobox and qemu)
  virtualisation = {
    podman.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };
  };
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    swtpm
    wl-clipboard
    glib
  ];
  users.users.samuel.extraGroups = [
    "libvirtd"
    "dialout"
    "input"
  ];

  # Windows dual boot mounting
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-label/Windows-SSD";
    fsType = "ntfs3";

    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
      "nofail"
      "x-systemd.automount"
    ];
  };

  # GRUB bootloader
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        default = "0";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  system.stateVersion = "26.05";
}
