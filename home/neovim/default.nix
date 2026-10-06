{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    gcc
    tree-sitter
    clang-tools
    pyright
    texlab
    nixfmt
	 ripgrep
  ];
}
