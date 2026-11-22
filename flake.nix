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
  }: let
    hosts = {
      nixos-laptop = {
        system = "x86_64-linux";
        directory = ./hosts/laptop;
        monitorName = "eDP-1";
        extraModules = [umbriel.nixosModules.default];
      };
      nixos-vm = {
        system = "x86_64-linux";
        directory = ./hosts/vm;
        monitorName = "Virtual-1";
        extraModules = [];
      };
      nixos-wsl = {
        system = "x86_64-linux";
        directory = ./hosts/wsl;
        monitorName = "WSL";
        extraModules = [nixos-wsl.nixosModules.default];
      };
    };

    homePackages = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    mkNixosHost = host:
      nixpkgs.lib.nixosSystem {
        inherit (host) system;
        modules = [host.directory ./configuration.nix] ++ host.extraModules;
      };

    mkHomeHost = host:
      home-manager.lib.homeManagerConfiguration {
        pkgs = homePackages host.system;

        modules = [
          ./modules/home
          ./profiles/home
          (host.directory + "/home.nix")
          {programs.home-manager.enable = true;}
        ];

        extraSpecialArgs = {inherit (host) monitorName;};
      };
    homeHosts =
      nixpkgs.lib.mapAttrs' (name: host: {
        name = "samuel@${name}";
        value = mkHomeHost host;
      })
      hosts;
  in {
    checks.x86_64-linux.home-evaluations =
      builtins.deepSeq
      (nixpkgs.lib.mapAttrsToList (_: host: host.activationPackage.drvPath) homeHosts)
      ((homePackages "x86_64-linux").runCommand "home-evaluations" {} ''
        touch "$out"
      '');

    nixosConfigurations = nixpkgs.lib.mapAttrs (_: mkNixosHost) hosts;
    homeConfigurations = homeHosts;
  };
}
