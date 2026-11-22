{ config, lib, ... }: {
  options.my.profiles.development.enable = lib.mkEnableOption "Development tools";

  config = lib.mkIf config.my.profiles.development.enable {
    my.modules = {
      git.enable = lib.mkDefault true;
      lazygit.enable = lib.mkDefault true;
      gh.enable = lib.mkDefault true;
    };
  };
}
