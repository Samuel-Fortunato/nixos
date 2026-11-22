{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./graphics.nix
    ./virtualization.nix
    ./power.nix
  ];

  # Host identity and networking
  networking.hostName = "nixos-laptop";

  # System features
  my = {
    profiles.graphical.enable = true;
    modules.razer.enable = true;
  };

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
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  # Hardware
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # System services
  services = {
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0cd5", ATTR{idProduct}=="0001", \
        MODE="0660", GROUP="labjack"
    '';

    # Graphical environment
    displayManager.noctalia-greeter.enable = true;
    # displayManager.ly.enable = true;

    # keyring
    gnome.gnome-keyring.enable = true;
  };

  # Programs
  programs = {
    umbriel.enable = true;
    steam.enable = true;
    gpu-screen-recorder.enable = true;
  };

  users = {
    groups.labjack = {};
    users.samuel.extraGroups = [
      "dialout"
      "input" # Noctalia Bongo Cat
      "labjack"
    ];
  };

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
