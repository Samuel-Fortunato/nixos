{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixos-laptop";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
  };

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
