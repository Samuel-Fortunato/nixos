{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    networkmanager.enable = true;
    hostName = "nixos-vm";
  };
  programs.hyprland.enable = true;

  # Graphical environment
  services.displayManager.ly.enable = true;
  services.pipewire.enable = true;

  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    glib
  ];

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

  system.stateVersion = "26.05";
}
