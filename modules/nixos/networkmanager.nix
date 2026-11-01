{ config, lib, ... }:
{
  config = lib.mkIf config.networking.networkmanager.enable {
    users.users.samuel.extraGroups = [ "networkmanager" ];
  };
}
