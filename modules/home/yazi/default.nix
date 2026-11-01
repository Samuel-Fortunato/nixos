{ config, lib, ... }: {
  options.my.modules.yazi.enable = lib.mkEnableOption "Yazi file manager";
  config = lib.mkIf config.my.modules.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = config.my.modules.zsh.enable;
    };
    xdg.configFile."yazi" = {
      source = ./config;
    };
  };
}
