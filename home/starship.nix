{ config, lib, ... }:

{
  options.my.modules.starship.enable = lib.mkEnableOption "Starship prompt";

  config = lib.mkIf config.my.modules.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
