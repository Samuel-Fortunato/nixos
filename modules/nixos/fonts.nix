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
  options.my.modules.fonts.enable = lib.mkEnableOption "System-wide fonts and Fontconfig";

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        maple-mono.NF
        # maple-mono.NF-unhinted
		  noto-fonts
        noto-fonts-color-emoji
      ];

      fontconfig = {
        enable = true;

        defaultFonts = {
          monospace = [ "Maple Mono NF" ];
          # sansSerif = [ "DejaVu Sans" ];
          # serif = [ "DejaVu Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
