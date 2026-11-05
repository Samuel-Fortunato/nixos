{
  config,
  lib,
  ...
}: {
  options.my.modules.ripgrep.enable =
    lib.mkEnableOption "Ripgrep (rg)";

  config = lib.mkIf config.my.modules.ripgrep.enable {
    programs.ripgrep.enable = true;
  };
}
