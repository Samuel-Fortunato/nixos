{
  config,
  lib,
  ...
}: {
  options.my.modules.yazi.enable = lib.mkEnableOption "Yazi file manager";

  config = lib.mkIf config.my.modules.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = config.my.modules.zsh.enable;

      settings = {
        open.prepend_rules = [
          {
            url = "*/";
            use = [
              "open"
              "reveal"
              "edit"
            ];
          }
        ];

        opener.edit = [
          {
            run = "nvim %s";
            block = true;
            desc = "Neovim";
            for = "unix";
          }
          {
            run = "kitty --directory \"$PWD\" nvim %s";
            orphan = true;
            desc = "Neovim (New Window)";
            for = "unix";
          }
        ];
      };

      plugins.folder-rules = {
        package = ./config/plugins/folder-rules.yazi;
        setup = true;
      };
    };
  };
}
