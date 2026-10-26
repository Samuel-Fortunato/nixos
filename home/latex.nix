{ pkgs, ... }:

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
  home.packages = [
    tex
  ];
}
