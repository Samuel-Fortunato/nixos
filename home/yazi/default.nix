{ config, lib, ... }: {
  options.my.modules.yazi.enable = lib.mkEnableOption "Yazi configuration";

  config = lib.mkIf config.my.modules.yazi.enable {
    xdg.configFile."yazi" = {
      source = ./config;
    };
  };
}
