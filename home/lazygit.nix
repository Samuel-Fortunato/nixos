{ config, lib, ... }: {
  options.my.modules.lazygit.enable = lib.mkEnableOption "Lazygit";

  config = lib.mkIf config.my.modules.lazygit.enable {
    programs.lazygit = {
      enable = true;

		enableZshIntegration = true;
		shellWrapperName = "lazygit";
    };
  };
}
