{...}: {
  imports = [../../profiles/home];

  my.profiles.cli.enable = true;
  my.profiles.development.enable = true;
  my.profiles.academic.enable = true;

  # Preserve the feature branch's existing module selection.
  my.modules = {
    fastfetch.enable = false;
    btop.enable = false;
    tmux.enable = false;
    gh.enable = false;
    yazi.enable = true;
  };
}
