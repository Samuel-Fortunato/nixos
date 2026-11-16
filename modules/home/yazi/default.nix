{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.modules.yazi.enable = lib.mkEnableOption "Yazi file manager";

  config = lib.mkIf config.my.modules.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = config.my.modules.zsh.enable;

      settings = {
        open.prepend_rules = [
          # Folders
          {
            url = "*/";
            use = ["open" "reveal" "edit"];
          }

          # Website shortcuts
          {
            url = "*.desktop";
            use = ["desktop-link" "edit"];
          }
        ];

        opener = {
          edit = [
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

          desktop-link = [
            {
              run = ''
                url=$(sed -n 's/^URL=//p' %s1 | head -n 1 | tr -d '\r')
                case "$url" in
                  http://*|https://*) xdg-open "$url" ;;
                  *) echo "Invalid website shortcut" >&2; exit 1 ;;
                esac
              '';
              desc = "Open website";
              for = "unix";
            }
          ];
        };
      };

      plugins.folder-rules = {
        package = ./config/plugins/folder-rules.yazi;
        setup = true;
      };
    };

    home.packages = with pkgs; [
      exiftool
    ];
  };
}
