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
        ] ++ lib.optional config.my.modules.xdg.enable
          # Website shortcuts
          {
            url = "*.desktop";
            use = ["desktop-link" "edit"];
          };

        opener = lib.optionalAttrs config.my.modules.neovim.enable {
          edit = [
            {
              run = "nvim %s";
              block = true;
              desc = "Neovim";
              for = "unix";
            }
          ] ++ lib.optional config.my.modules.kitty.enable {
              run = "kitty --directory \"$PWD\" nvim %s";
              orphan = true;
              desc = "Neovim (New Window)";
              for = "unix";
            };
        } // lib.optionalAttrs config.my.modules.xdg.enable {
          desktop-link = [
            {
              run = ''
                url=$(sed -n 's/^URL=//p' %s1 | head -n 1 | tr -d '\r')
                case "$url" in
                  http://*|https://*) ${pkgs.xdg-utils}/bin/xdg-open "$url" ;;
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
