{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixos-vm";

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.graphics.enable = true;
  services.qemuGuest.enable = true;
}
