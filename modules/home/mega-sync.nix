{ config, lib, ... }: {
  options.my.modules.mega-sync.enable = lib.mkEnableOption "MEGA Synchronization";

  config = lib.mkIf config.my.modules.mega-sync.enable {
    services.megasync.enable = true;
  };
}
