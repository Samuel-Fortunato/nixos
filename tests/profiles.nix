{
  lib,
  pkgs,
  home-manager,
}: let
  mkHome = settings:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../modules/home
        ../profiles/home
        settings
        {programs.home-manager.enable = true;}
      ];
      extraSpecialArgs.monitorName = "test";
    };

  cli =
    (mkHome {
      my.profiles.cli.enable = true;
      my.profiles.development.enable = true;
      my.modules.fastfetch.enable = false;
    }).config;

  desktop =
    (mkHome {
      my.profiles.desktop.enable = true;
      my.modules.chrome.enable = false;
      my.modules.calculator.enable = false;
    }).config;

  assertionsPass = config: lib.all (assertion: assertion.assertion) config.assertions;
in
  assert cli.my.modules.zsh.enable;
  assert cli.my.modules.git.enable;
  assert cli.my.modules.neovim.enable;
  assert !cli.my.modules.fastfetch.enable;
  assert !cli.my.modules.hyprland.enable;
  assert !cli.my.modules.noctalia.enable;
  assert assertionsPass cli;
  assert desktop.my.modules.hyprland.enable;
  assert desktop.my.modules.noctalia.enable;
  assert !desktop.my.modules.chrome.enable;
  assert !desktop.my.modules.calculator.enable;
  assert assertionsPass desktop;
    pkgs.runCommand "profile-evaluation-check" {} ''
      touch "$out"
    ''
