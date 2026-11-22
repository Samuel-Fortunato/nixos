{...}: {
  networking.hostName = "nixos-wsl";

  wsl = {
    enable = true;
    defaultUser = "samuel";
  };

  system.stateVersion = "26.05";
}
