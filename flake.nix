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

            home-manager.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.samuel = import ./home;
            }
          ];
        };

        nixos-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
				./hosts/vm
            ./configuration.nix

            home-manager.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.samuel = import ./home;
            }
          ];
        };
      };
    };
}
