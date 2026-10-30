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
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.samuel = {
                  imports = [
                    ./home
                    ./hosts/laptop/home.nix
                  ];
                };
                extraSpecialArgs = {
                  monitorName = "eDP-1";
                };
              };
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
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.samuel = {
                  imports = [
                    ./home
                    ./hosts/vm/home.nix
                  ];
                };
                extraSpecialArgs = {
                  monitorName = "Virtual-1";
                };
              };
            }
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
          ];

          extraSpecialArgs = {
            monitorName = "Virtual-1";
          };
        };
      };
    };
}
