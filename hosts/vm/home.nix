{ ... }: {
  imports = [ ../../profiles/home ];

  my.profiles = {
    cli.enable = true;
    development.enable = true;
    desktop.enable = true;
    media.enable = true;
  };
}
