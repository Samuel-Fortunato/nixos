{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Host identity and networking
  networking = {
    hostName = "nixos-laptop";
    networkmanager.enable = true;
  };
  
  # Optional custom NixOS modules
  my.modules.razer.enable = true;

  # Bootloader and kernel
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

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
  };

  # Hardware
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = false;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # System services
  services = {
    # Graphical environment
    displayManager.ly.enable = true;
    xserver.videoDrivers = [ "nvidia" ];

    # Audio and desktop integration
    pipewire.enable = true;
    accounts-daemon.enable = true;
    udisks2.enable = true;

    # Power management
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

  # Programs
  programs = {
    hyprland.enable = true;
    steam.enable = true;
    gpu-screen-recorder.enable = true;
    virt-manager.enable = true;
  };

  # Security and permissions
  security.polkit.enable = true;

  users.users.samuel.extraGroups = [
    "libvirtd"
    "dialout"
    "input" # Noctalia Bongo Cat
  ];

  # Virtualization
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

  # System packages
  environment.systemPackages = with pkgs; [
    swtpm
    wl-clipboard
    glib
  ];

  # Windows dual-boot partition
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

  # Documentation
  documentation.man.cache.enable = true;

  # System compatibility
  system.stateVersion = "26.05";
}
