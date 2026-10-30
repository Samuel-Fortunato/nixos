{
  description = "Samuel's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    {
      nixosConfigurations = {
        nixos-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/laptop
            ./configuration.nix
          ];
        };

        nixos-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/vm
            ./configuration.nix
          ];
        };
      };
      homeConfigurations = {
        "samuel@nixos-laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };

          modules = [
            ./home
            ./hosts/laptop/home.nix
            { programs.home-manager.enable = true; }
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
            ./home
            ./hosts/vm/home.nix
            { programs.home-manager.enable = true; }
          ];

          extraSpecialArgs = {
            monitorName = "Virtual-1";
          };
        };
      };
    };
}
