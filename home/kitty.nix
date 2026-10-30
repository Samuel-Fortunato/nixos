{ config, lib, pkgs, ... }:
let
  cfg = config.my.modules.kitty;
in
{
  options.my.modules.kitty.enable = lib.mkEnableOption "Kitty terminal";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

    programs.kitty = {
      enable = true;

      font = {
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };

      settings = {
        background_opacity = "0.85";
        cursor_trail = 3;
        cursor_trail_start_threshold = 0;

		  disable_ligatures = "always";
      };

      extraConfig = "globinclude themes/noctalia.conf";
    };
  };
}
