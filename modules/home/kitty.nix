{
  config,
  lib,
  ...
}: let
  cfg = config.my.modules.kitty;
in {
  options.my.modules.kitty.enable = lib.mkEnableOption "Kitty terminal";

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      settings = {
        background_opacity = "0.85";
        cursor_trail = 3;
        cursor_trail_start_threshold = 0;

        disable_ligatures = "always";
        copy_on_select = "clipboard";
      };

      mouseBindings = {
        # Right-click pastes from system clipboard
        "right press ungrabbed" = "paste_from_clipboard";
      };

      extraConfig = "globinclude themes/noctalia.conf";
    };
  };
}
