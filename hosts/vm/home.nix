{ ... }: {
  imports = [ ../../profiles/home ];

  my.profiles = {
    cli.enable = true;
    desktop.enable = true;
    media.enable = true;
  };

  my.modules = {
    git.enable = true;
    lazygit.enable = true;
    gh.enable = true;
  };
}
