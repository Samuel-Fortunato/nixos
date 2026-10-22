{ pkgs, ... }: {
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
      y = ''
        		  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
                yazi "$@" --cwd-file="$tmp"
                if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                  builtin cd -- "$cwd"
                fi
                rm -f -- "$tmp"
        		'';
      rebuild = ''
        		sudo nixos-rebuild switch && hyprctl reload && noctalia msg config-reload && noctalia msg notification-show "NixOS rebuilt \!" "Hyprland & Noctalia reloaded"
        		'';
      sync-desktop = ''
        if systemctl --user start proton-drive-bisync.service; then
          if [ "$(systemctl --user show proton-drive-bisync.service -p Result --value)" = "success" ]; then
            echo "Desktop synced successfully. Safe to shut down."
          else
            echo "Desktop sync failed. Do not switch PCs yet."
            return 1
          fi
        else
          echo "Desktop sync failed. Do not switch PCs yet."
          return 1
        fi
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
}
