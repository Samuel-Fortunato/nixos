{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  my.profiles.graphical.enable = true;

  # Host identity and networking
  networking = {
    hostName = "nixos-vm";
  };

  # Bootloader
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };

    efi.canTouchEfiVariables = true;
  };

  # System services
  services.qemuGuest.enable = true;

  # System compatibility
  system.stateVersion = "26.05";
}
