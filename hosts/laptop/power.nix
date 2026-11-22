{config, ...}: {
  # Hibernation
  swapDevices = [
    {
      device = "/swapfile";
      size = 40 * 1024; # MiB
    }
  ];

  boot = {
    resumeDevice = config.fileSystems."/".device;
    # Recalculate if /swapfile is recreated or moved
    kernelParams = ["resume_offset=598016"];
  };

  services = {
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };

    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "ignore";
    };
  };
}
