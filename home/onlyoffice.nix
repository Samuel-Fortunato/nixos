{ config, lib, ... }: {
  options.my.modules.onlyoffice.enable = lib.mkEnableOption "OnlyOffice";

  config = lib.mkIf config.my.modules.onlyoffice.enable {
    programs.onlyoffice.enable = true;
  };
}
