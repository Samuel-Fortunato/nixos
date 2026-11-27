{
  config,
  lib,
  ...
}: {
  options.my.modules.onlyoffice.enable = lib.mkEnableOption "OnlyOffice";

  config = lib.mkIf config.my.modules.onlyoffice.enable {
    programs.onlyoffice.enable = true;

    xdg.mimeApps = {
      enable = true;

      defaultApplications = lib.genAttrs [
        # Microsoft Word
        "application/msword"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.ms-word.document.macroenabled.12"

        # Microsoft Excel
        "application/vnd.ms-excel"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.ms-excel.sheet.macroenabled.12"

        # Microsoft PowerPoint
        "application/vnd.ms-powerpoint"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/vnd.ms-powerpoint.presentation.macroenabled.12"

        # OpenDocument
        "application/vnd.oasis.opendocument.text"
        "application/vnd.oasis.opendocument.spreadsheet"
        "application/vnd.oasis.opendocument.presentation"

        # Other office formats
        "application/rtf"
        "text/rtf"
        "text/csv"
      ] (_: ["onlyoffice-desktopeditors.desktop"]);
    };
  };
}
