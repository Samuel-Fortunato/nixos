{
  description = "Samuel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel.url = "github:noctalia-dev/umbriel/cachix";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    umbriel,
    nixos-wsl,
    ...
  }: {
    # NixOS system configurations
    nixosConfigurations = {
      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop
          ./configuration.nix
          umbriel.nixosModules.default
        ];
      };

      nixos-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vm
          ./configuration.nix
        ];
      };
      nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          nixos-wsl.nixosModules.default
          ./hosts/wsl
          ./configuration.nix
        ];
      };
    };

    # Standalone Home Manager configurations
    homeConfigurations = {
      "samuel@nixos-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };

        modules = [
          ./modules/home
          ./hosts/laptop/home.nix
          {programs.home-manager.enable = true;}
        ];

        extraSpecialArgs = {
          monitorName = "eDP-1";
        };
      };

      "samuel@nixos-vm" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };

        modules = [
          ./modules/home
          ./hosts/vm/home.nix
          {programs.home-manager.enable = true;}
        ];

        extraSpecialArgs = {
          monitorName = "Virtual-1";
        };
      };

      "samuel@nixos-wsl" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };

        modules = [
          ./modules/home
          ./hosts/wsl/home.nix
          {programs.home-manager.enable = true;}
        ];

        extraSpecialArgs = {
          monitorName = "WSL";
        };
      };
    };
  };
}
