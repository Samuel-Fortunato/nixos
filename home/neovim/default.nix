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
      pyright
      texlab
      nixfmt
      ripgrep
    ];
  };

  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
