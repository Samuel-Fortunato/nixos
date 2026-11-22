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
  developmentOnly = (mkHome {my.profiles.development.enable = true;}).config;
  mediaOnly = (mkHome {my.profiles.media.enable = true;}).config;
  mediaDesktop = (mkHome {my.profiles.media.enable = true; my.profiles.desktop.enable = true;}).config;
  overrides = (mkHome {
    my.profiles.cli.enable = true;
    my.profiles.media.enable = true;
    my.profiles.desktop.enable = true;
    my.modules.neovim.enable = false;
    my.modules.spotify.enable = false;
    my.modules.noctalia.musicWallpaper.enable = false;
    my.modules.noctalia.exporter.enable = false;
  }).config;

  desktop =
    (mkHome {
      my.profiles.desktop.enable = true;
      my.modules.chrome.enable = false;
      my.modules.calculator.enable = false;
    }).config;

  laptop = (mkHome ../hosts/laptop/home.nix).config;
  vm = (mkHome ../hosts/vm/home.nix).config;
  wsl = (mkHome ../hosts/wsl/home.nix).config;
  yaziOnly = (mkHome {my.modules.yazi.enable = true;}).config;
  alternateCheckout = (mkHome {my.repositoryPath = "/tmp/nixos-checkout";}).config;

  withoutGit = builtins.tryEval (mkHome {
    my.profiles.development.enable = true;
    my.modules.git.enable = false;
  }).activationPackage.drvPath;
  withoutHyprland = builtins.tryEval (mkHome {
    my.profiles.desktop.enable = true;
    my.profiles.media.enable = true;
    my.modules.hyprland.enable = false;
    my.modules.noctalia.musicWallpaper.enable = true;
  }).activationPackage.drvPath;
  withoutNoctalia = builtins.tryEval (mkHome {
    my.profiles.desktop.enable = true;
    my.profiles.media.enable = true;
    my.modules.noctalia.enable = false;
    my.modules.noctalia.musicWallpaper.enable = true;
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
  assert cliOnly.my.modules.neovim.enable;
  assert !developmentOnly.my.modules.neovim.enable;
  assert enabled mediaOnly ["spotify" "showtime"];
  assert !mediaOnly.my.modules.noctalia.musicWallpaper.enable;
  assert assertionsPass mediaOnly;
  assert mediaDesktop.my.modules.noctalia.musicWallpaper.enable;
  assert assertionsPass mediaDesktop;
  assert !overrides.my.modules.neovim.enable;
  assert !overrides.my.modules.spotify.enable;
  assert !overrides.my.modules.noctalia.musicWallpaper.enable;
  assert !overrides.my.modules.noctalia.exporter.enable;
  assert !(overrides.systemd.user.services ? noctalia-settings-export);
  assert assertionsPass overrides;
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
  assert vm.my.profiles.cli.enable;
  assert !vm.my.profiles.development.enable;
  assert vm.my.modules.neovim.enable;
  assert laptop.my.modules.noctalia.musicWallpaper.enable;
  assert vm.my.modules.noctalia.musicWallpaper.enable;
  assert laptop.my.modules.noctalia.exporter.enable;
  assert vm.my.modules.noctalia.exporter.enable;
  assert laptop.systemd.user.services ? noctalia-settings-export;
  assert vm.systemd.user.services ? noctalia-settings-export;
  assert alternateCheckout.my.modules.noctalia.exporter.repoPath == "/tmp/nixos-checkout";
  assert wsl.my.profiles.academic.enable;
  assert enabled wsl ["onlyoffice" "latex" "zsh" "starship" "git" "neovim" "lazygit" "ripgrep" "yazi"];
  assert !(wsl.systemd.user.services ? noctalia-settings-export);
  assert !wsl.my.modules.fastfetch.enable;
  assert !wsl.my.modules.btop.enable;
  assert !wsl.my.modules.tmux.enable;
  assert !wsl.my.modules.gh.enable;
  assert !wsl.my.modules.hyprland.enable;
  assert !wsl.my.modules.noctalia.enable;
  assert builtins.length wsl.programs.yazi.settings.opener.edit == 1;
  assert !(wsl.programs.yazi.settings.opener ? desktop-link);
  assert !(yaziOnly.programs.yazi.settings.opener ? edit);
  assert builtins.length laptop.programs.yazi.settings.opener.edit == 2;
  assert !withoutGit.success;
  assert !withoutHyprland.success;
  assert !withoutNoctalia.success;
    pkgs.runCommand "profile-evaluation-check" {} ''
      touch "$out"
    ''
