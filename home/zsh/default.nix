{ ... }: {
  programs.zsh = {
    enable = true;

    shellAliases = {
      ncf = "nvim ~/.config/nvim/";
      launch = ''setsid "$@" >/dev/null 2>&1'';
      op = ''launch xdg-open "$@"'';
      bth = "bluetoothctl";
    };

    initContent = ''
          # Prompt
          autoload -Uz vcs_info
          precmd() { vcs_info }

          zstyle ':vcs_info:git:*' formats '%F{magenta}%b%f'
          zstyle ':vcs_info:git:*' actionformats '%F{magenta}%b|%a%f'

          setopt PROMPT_SUBST
          PROMPT='%F{cyan}%~%f $vcs_info_msg_0_
      %F{blue}❯%f '

          # Yazi
          function y() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
              builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
          }
    '';
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
