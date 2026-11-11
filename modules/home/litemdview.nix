{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.modules.litemdview.enable =
    lib.mkEnableOption "LiteMDview Markdown viewer";

  config = lib.mkIf config.my.modules.litemdview.enable {
    home.packages = [pkgs.litemdview];

    # XDG default Markdown viewer
    xdg = lib.mkIf config.my.modules.xdg.enable {
      desktopEntries.litemdview-viewer = {
        name = "LiteMDview";
        exec = "${lib.getExe pkgs.litemdview} %f";
        mimeType = [
          "text/markdown"
          "text/x-markdown"
        ];
        categories = ["Utility"];
        noDisplay = true;
      };

      mimeApps.defaultApplications = {
        "text/markdown" = "litemdview-viewer.desktop";
        "text/x-markdown" = "litemdview-viewer.desktop";
      };
    };

    # Yazi: view Markdown by default, with editing as an alternative
    programs.yazi.settings.open.prepend_rules = lib.mkIf config.my.modules.yazi.enable [
      {
        url = "*.{md,markdown}";
        use = [
          "open"
          "edit"
        ];
      }
    ];
  };
}
