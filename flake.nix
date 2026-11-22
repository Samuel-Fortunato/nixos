{
  description = "Samuel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel.url = "github:noctalia-dev/umbriel/cachix";
  };

  outputs = { nixpkgs, home-manager, umbriel, ... }:
    let
      hosts = {
        nixos-laptop = {
          system = "x86_64-linux";
          directory = ./hosts/laptop;
          monitorName = "eDP-1";
          extraModules = [ umbriel.nixosModules.default ];
        };
        nixos-vm = {
          system = "x86_64-linux";
          directory = ./hosts/vm;
          monitorName = "Virtual-1";
          extraModules = [ ];
        };
      };

      mkNixosHost = host: nixpkgs.lib.nixosSystem {
        inherit (host) system;
        modules = [ host.directory ./configuration.nix ] ++ host.extraModules;
      };

      mkHomeHost = host: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit (host) system;
          config.allowUnfree = true;
        };
        modules = [
          ./modules/home
          (host.directory + "/home.nix")
          { programs.home-manager.enable = true; }
        ];
        extraSpecialArgs = { inherit (host) monitorName; };
      };
    in {
      nixosConfigurations = nixpkgs.lib.mapAttrs (_: mkNixosHost) hosts;
      homeConfigurations = nixpkgs.lib.mapAttrs' (name: host: {
        name = "samuel@${name}";
        value = mkHomeHost host;
      }) hosts;
    };
}
