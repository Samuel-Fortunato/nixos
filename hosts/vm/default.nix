{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Host identity and networking
  networking = {
    hostName = "nixos-vm";
    networkmanager.enable = true;
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

  # Hardware
  hardware.graphics.enable = true;

  # System services
  services = {
    # Virtual machine integration
    qemuGuest.enable = true;

    # Graphical environment
    displayManager.ly.enable = true;

    # Audio and desktop integration
    pipewire.enable = true;
    accounts-daemon.enable = true;
    udisks2.enable = true;
  };

  # Programs
  programs.hyprland.enable = true;

  # Security
  security.polkit.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    wl-clipboard
    glib
  ];

  # System compatibility
  system.stateVersion = "26.05";
}
