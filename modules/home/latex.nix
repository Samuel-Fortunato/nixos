{
  config,
  lib,
  pkgs,
  ...
}: let
  tex = pkgs.texliveBasic.withPackages (
    ps:
      with ps; [
        latexmk
        latexindent
        xetex
        dvisvgm

        beamer
        beamertheme-metropolis
        standalone

        pgf
        pgfopts

        booktabs
        mdwtools
        fontspec
        multirow
        makecell
        ragged2e
        enumitem
        microtype
        lipsum
        cleveref
        circuitikz
		  enumitem
		  txfonts
		  newtx
		  titlesec

		  babel-portuges
		  hyphen-portuguese
      ]
  );
in {
  options.my.modules.latex.enable = lib.mkEnableOption "LaTeX environment";

  config = lib.mkIf config.my.modules.latex.enable {
    home.packages = [tex];
  };
}
