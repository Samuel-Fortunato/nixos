{ ... }: {
  imports = [ ../../profiles/home ];

  my.profiles = {
    cli.enable = true;
    development.enable = true;
    desktop.enable = true;
    media.enable = true;
    academic.enable = true;
  };

  my.modules = {
    noctalia.exporter.enable = true;
    fonts.enable = true;
    matlab.enable = true;
    codex.enable = true;
    proton-drive.enable = false;
    mega-sync.enable = true;
    razer.enable = true;
    kicad.enable = true;
  };
}
