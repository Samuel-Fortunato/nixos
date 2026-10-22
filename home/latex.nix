{ pkgs, ... }:

let
  tex = pkgs.texliveBasic.withPackages (
    ps: with ps; [
      latexmk
      latexindent
		xetex

      beamer
      beamertheme-metropolis
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
