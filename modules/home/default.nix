{ config, lib, ... }:
let
  entries = builtins.readDir ./.;

  modules = lib.concatMap (
    name:
    let
      path = ./. + "/${name}";
      type = entries.${name};
    in
    if name == "default.nix" then
      [ ]
    else if type == "regular" && lib.hasSuffix ".nix" name then
      [ path ]
    else if type == "directory" && builtins.pathExists (path + "/default.nix") then
      [ path ]
    else
      [ ]
  ) (builtins.attrNames entries);
in
{
  imports = modules;

  # Keep the rest of your existing configuration here
  xdg.configFile."home-manager".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos";

  home = {
    username = "samuel";
    homeDirectory = "/home/samuel";
    backupFileExtension = "bak";
    stateVersion = "26.05";
  };
}
