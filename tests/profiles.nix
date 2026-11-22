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

  cliOnly = (mkHome {my.profiles.cli.enable = true;}).config;

  desktop =
    (mkHome {
      my.profiles.desktop.enable = true;
      my.modules.chrome.enable = false;
      my.modules.calculator.enable = false;
    }).config;

  laptop = (mkHome ../hosts/laptop/home.nix).config;
  vm = (mkHome ../hosts/vm/home.nix).config;

  withoutGit = builtins.tryEval (mkHome {
    my.profiles.development.enable = true;
    my.modules.git.enable = false;
  }).activationPackage.drvPath;
  withoutHyprland = builtins.tryEval (mkHome {
    my.profiles.desktop.enable = true;
    my.profiles.media.enable = true;
    my.modules.hyprland.enable = false;
  }).activationPackage.drvPath;
  withoutNoctalia = builtins.tryEval (mkHome {
    my.profiles.desktop.enable = true;
    my.profiles.media.enable = true;
    my.modules.noctalia.enable = false;
  }).activationPackage.drvPath;

  # Features enabled by the original daily-desktop profile on both hosts.
  sharedFeatures = [
    "btop" "calculator" "chrome" "cursor" "evtest" "fastfetch" "gh" "git"
    "gtk" "hyprland" "kitty" "lazygit" "litemdview" "loupe" "neovim"
    "noctalia" "proton-pass" "ripgrep" "seahorse" "showtime" "spotify"
    "starship" "thunar" "tmux" "trash" "udiskie" "xdg" "yazi" "zathura" "zsh"
  ];
  laptopFeatures = [
    "codex" "fonts" "kicad" "latex" "matlab" "mega-sync" "onlyoffice" "razer"
  ];
  enabled = config: names: lib.all (name: config.my.modules.${name}.enable) names;

  assertionsPass = config: lib.all (assertion: assertion.assertion) config.assertions;
in
  assert cli.my.modules.zsh.enable;
  assert cli.my.modules.git.enable;
  assert cli.my.modules.neovim.enable;
  assert !cli.my.modules.fastfetch.enable;
  assert !cli.my.modules.hyprland.enable;
  assert !cli.my.modules.noctalia.enable;
  assert assertionsPass cli;
  assert cliOnly.my.modules.zsh.enable;
  assert !cliOnly.my.modules.neovim.enable;
  assert !cliOnly.my.modules.hyprland.enable;
  assert !cliOnly.my.modules.noctalia.enable;
  assert assertionsPass cliOnly;
  assert desktop.my.modules.hyprland.enable;
  assert desktop.my.modules.noctalia.enable;
  assert !desktop.my.modules.chrome.enable;
  assert !desktop.my.modules.calculator.enable;
  assert assertionsPass desktop;
  assert enabled laptop (sharedFeatures ++ laptopFeatures);
  assert enabled vm sharedFeatures;
  assert laptop.my.modules.noctalia.musicWallpaper.enable;
  assert vm.my.modules.noctalia.musicWallpaper.enable;
  assert !withoutGit.success;
  assert !withoutHyprland.success;
  assert !withoutNoctalia.success;
    pkgs.runCommand "profile-evaluation-check" {} ''
      touch "$out"
    ''
