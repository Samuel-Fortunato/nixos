{
  description = "Dev shell for the Noctalia music wallpaper script";

  inputs.nixpkgs.url = "nixpkgs";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";  # change if needed
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python3.withPackages (p: [ p.pillow ]);
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ python pkgs.pyright pkgs.playerctl ];
      };
    };
}
