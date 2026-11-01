{ ... }:
{
  imports = [
    ../common/home.nix
  ];

  my.modules = {
    fonts.enable = true;
    onlyoffice.enable = true;
    latex.enable = true;
    proton-drive.enable = true;
    matlab.enable = true;
    codex.enable = true;
  };
}
