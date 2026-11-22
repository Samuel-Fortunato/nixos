{ config, lib, ... }: {
  options.my.profiles.academic.enable = lib.mkEnableOption "Office and LaTeX tools";

  config = lib.mkIf config.my.profiles.academic.enable {
    my.modules = {
      onlyoffice.enable = lib.mkDefault true;
      latex.enable = lib.mkDefault true;
    };
  };
}
