{ config, lib, ... }: {
  options.my.modules.git.enable = lib.mkEnableOption "Git configuration";

  config = lib.mkIf config.my.modules.git.enable {
    programs.git = {
      enable = true;

      settings = {
        user.name = "Samuel-Fortunato";
        user.email = "samff2006@gmail.com";
      };
    };
  };
}
