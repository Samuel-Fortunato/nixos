{ config, lib, ... }: {
  options.my.modules.lazygit.enable = lib.mkEnableOption "Lazygit";

  config = lib.mkIf config.my.modules.lazygit.enable {
    programs.lazygit = {
      enable = true;

      enableZshIntegration = true;
      shellWrapperName = "lazygit";

      settings = {
        git.diffRenderers = [
          {
            command = ''
              delta --{{colorScheme}} --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"
            '';
          }
        ];
      };
    };
  };
}
