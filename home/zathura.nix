{ config, lib, ... }: {
  options.my.modules.zathura.enable = lib.mkEnableOption "Zathura PDF viewer";

  config = lib.mkIf config.my.modules.zathura.enable {
    programs.zathura = {
      enable = true;

      extraConfig = "include noctaliarc";

      options = {
        selection-clipboard = "clipboard";
        recolor = true;
        recolor-keephue = true;
        recolor-reverse-video = true;
      };
    };
  };
}
