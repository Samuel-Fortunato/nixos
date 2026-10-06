# Edit this configuration file to define what should be installed on your system. Help is available in the configuration.nix(5) man page, on https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";

  programs.hyprland.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.samuel = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # List packages installed in system profile. You can use https://search.nixos.org/ to find more packages (and options).
  environment = {
	  variables = {
		 SUDO_EDITOR = "nvim";
	    EDITOR = "nvim";
		 VISUAL = "nvim";
	  };
	  systemPackages = with pkgs; [
		 gh
		 yazi
		 gcc
		 tree-sitter
		 ripgrep
		 clang-tools
		 pyright
		 texlab
		 wl-clipboard
		 vim
		 kitty
		 stow
		 rofi
		 pywal16
		 python3
		 zoxide
		 google-chrome
		 awww
		 glib
		 fzf
		 noctalia
		 tree
		 lazygit
	  ];
  };

  programs.neovim = {
	 enable = true;
	 defaultEditor = true;
  };

  programs.git = {
	  enable = true;

	  config = {
		 user.name = "Samuel-Fortunato";
		 user.email = "samff2006@gmail.com";
	  };
	};

  services.displayManager.ly.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}

