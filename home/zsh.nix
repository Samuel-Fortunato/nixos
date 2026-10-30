{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.modules.zsh.enable = lib.mkEnableOption "Zsh configuration";

  config = lib.mkIf config.my.modules.zsh.enable {
    programs.zsh = {
      enable = true;

      autocd = true;
      defaultKeymap = "viins";

      syntaxHighlighting.enable = true;
      autosuggestion = {
        enable = true;
        strategy = [
          "completion"
          "history"
        ];
      };
      history = {
        append = true;
        expireDuplicatesFirst = true;
        extended = true;
        findNoDups = true;
        saveNoDups = true;
      };

      # zprof.enable = true;
      initContent = ''
        	 setopt interactivecomments

                    if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
                      fastfetch
                    fi

              		bindkey -M viins 'jk' vi-cmd-mode
                    	'';

      shellAliases = {
        ncf = "nvim ~/.config/nvim/";
        cd = "z";
      };

      siteFunctions = {
        rebuild = ''
          		sudo nixos-rebuild switch && hyprctl reload && noctalia msg config-reload && noctalia msg notification-show "NixOS rebuilt \!" "Hyprland & Noctalia reloaded"
          		'';
      };
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
