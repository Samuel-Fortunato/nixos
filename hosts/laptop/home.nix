{ ... }:
{
  imports = [
    ../../profiles/home/daily-desktop.nix
  ];

  my.modules = {
    # Fonts
    fonts.enable = true;

    # Productivity
    onlyoffice.enable = true;
    latex.enable = true;

    # Development tools
    matlab.enable = true;
    codex.enable = true;

    # Cloud synchronization
    proton-drive.enable = false;
	 mega-sync.enable = true;
  };
}
