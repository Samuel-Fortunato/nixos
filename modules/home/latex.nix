{
  config,
  lib,
  pkgs,
  ...
}:
let
  tex = pkgs.texliveBasic.withPackages (
    ps: with ps; [
      latexmk
      latexindent
      xetex
      dvisvgm

      beamer
      beamertheme-metropolis
      standalone

      booktabs
      mdwtools
      fontspec
      multirow
      makecell
      ragged2e
      enumitem
      microtype

      pgf
      pgfopts
    ]
  );
in
{
  options.my.modules.latex.enable = lib.mkEnableOption "LaTeX environment";

  config = lib.mkIf config.my.modules.latex.enable {
    home.packages = [ tex ];
  };
}
