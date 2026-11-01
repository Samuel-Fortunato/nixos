{ config, lib, pkgs, ... }:
{
  options.my.modules.neovim.enable =
    lib.mkEnableOption "Neovim editor";

  config = lib.mkIf config.my.modules.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        lua-language-server
        gcc
        tree-sitter
        clang-tools
        basedpyright
        ruff
        texlab
        nixfmt
        astyle
        ripgrep
        ghostscript
      ];
    };

    xdg.configFile."nvim" = {
      source = ./config;
      recursive = true;
    };
  };
}
