{ ... }: {
  programs.zsh = {
    enable = true;

    autocd = true;
    cdpath = [ "." ];
    defaultKeymap = "viins";
    syntaxHighlighting.enable = true;
    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      findNoDups = true;
      saveNoDups = true;
    };

    shellAliases = {
      ncf = "nvim ~/.config/nvim/";
		cd = "z";
		rebuild = "sudo nixos-rebuild switch && hyprctl reload && noctalia msg config-reload && noctalia msg notification-show 'NixOS rebuilt \!' 'Hyprland & Noctalia reloaded'";
    };

    initContent = ''
      setopt PROMPT_SUBST

      PROMPT='%F{blue}%~%f %F{yellow}%(!.#.❯)%f '
    '';

    siteFunctions = {
      y = ''
        		  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
                yazi "$@" --cwd-file="$tmp"
                if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                  builtin cd -- "$cwd"
                fi
                rm -f -- "$tmp"
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
