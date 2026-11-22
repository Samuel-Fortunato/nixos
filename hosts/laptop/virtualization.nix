{
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  programs.virt-manager.enable = true;
  users.users.samuel.extraGroups = ["libvirtd"];
}
