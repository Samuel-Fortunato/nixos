{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
	 # sideloadInitLua = true;

    extraPackages = with pkgs; [
		lua-language-server
      gcc
      tree-sitter
      clang-tools

      basedpyright
		ruff

      texlab
      nixfmt
      ripgrep
		astyle
    ];
  };

  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
