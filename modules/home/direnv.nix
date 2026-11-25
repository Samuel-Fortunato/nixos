{
  config,
  lib,
  ...
}: {
  options.my.modules.direnv.enable =
    lib.mkEnableOption "Automatic development environments";

  config = lib.mkIf config.my.modules.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

	 home.sessionVariables.DIRENV_LOG_FORMAT = "";
  };
}
