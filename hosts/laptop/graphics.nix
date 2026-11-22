{pkgs, ...}: {
  # Intel GPU video acceleration
  hardware.graphics.extraPackages = [pkgs.intel-media-driver];

  # NVIDIA GPU
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
    moduleParams.nvidia.NVreg_UseKernelSuspendNotifiers = 1;
  };
}
