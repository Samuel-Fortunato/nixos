{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.fonts;
in
{
  options.my.modules.fonts.enable = lib.mkEnableOption "User fonts and Fontconfig";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      maple-mono.NF
      # maple-mono.NF-unhinted
      noto-fonts
      noto-fonts-color-emoji
    ];

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [ "Maple Mono NF" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
