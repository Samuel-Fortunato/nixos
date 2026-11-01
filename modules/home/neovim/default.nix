{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.my.modules.neovim.enable = lib.mkEnableOption "Neovim editor";

  config = lib.mkIf config.my.modules.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        # Language servers
        lua-language-server
        clang-tools
        basedpyright
        texlab

        # Formatters and linters
        ruff
        nixfmt
        astyle

        # Development and build tools
        gcc
        cargo
        rustc
        tree-sitter
        pkg-config

        # Utilities
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
