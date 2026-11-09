{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.displayManager.noctalia-greeter.enable {
    services.displayManager.noctalia-greeter = {
      settings = {
        user.default = "samuel";
        session.default = "Hyprland (uwsm-managed)";

        keyboard.layout = "pt";
        idle.timeout = 300;
        output.use_synced_settings = true;

        appearance.hide_logo = true;
      };

      passwordlessSyncUsers = ["samuel"];
    };
  };
}
