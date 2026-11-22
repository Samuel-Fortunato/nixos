{ config, lib, ... }: {
  options.my.profiles.cli.enable = lib.mkEnableOption "Core command-line environment";

  config = lib.mkIf config.my.profiles.cli.enable {
    my.modules = {
      zsh.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
      ripgrep.enable = lib.mkDefault true;
      btop.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
    };
  };
}
