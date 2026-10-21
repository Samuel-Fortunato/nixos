{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixos-laptop";

  # GPU acceleration
  hardware.graphics.enable = true;
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
  environment.systemPackages = [
    pkgs.swtpm
  ];
  users.users.samuel.extraGroups = [
    "libvirtd"
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
      timeout = 0;
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
}
