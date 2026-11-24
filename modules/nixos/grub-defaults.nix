{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.boot.loader.grub.enable {
    boot.loader = {
      timeout = 0;
      grub = {
        timeoutStyle = "hidden";

        minegrub-theme.enable = true;
      };
    };
  };
}
