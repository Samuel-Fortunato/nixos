{ pkgs, ... }:

let
  tex = pkgs.texliveBasic.withPackages (
    ps: with ps; [
      latexmk
      latexindent
      beamer
      beamertheme-metropolis

      pgf
      pgfopts
    ]
  );
in
{
  home.packages = [
    tex
  ];
}
