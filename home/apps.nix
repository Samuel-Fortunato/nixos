{
  config,
  lib,
  pkgs,
  ...
}:
let
  apps = {
    thunar = pkgs.thunar;
    gh = pkgs.gh;
    btop = pkgs.btop;
    chrome = pkgs.google-chrome;
    lazygit = pkgs.lazygit;
    spotify = pkgs.spotify;
    tmux = pkgs.tmux;
    distrobox = pkgs.distrobox;
    trash = pkgs.trash-cli;
    loupe = pkgs.loupe;
    udiskie = pkgs.udiskie;
    calculator = pkgs.gnome-calculator;
    showtime = pkgs.showtime;
    codex = pkgs.codex;
    evtest = pkgs.evtest;
  };
in
{
  options.my.modules = lib.mapAttrs (name: _: {
    enable = lib.mkEnableOption name;
  }) apps;

  config.home.packages = lib.concatLists (
    lib.mapAttrsToList (name: pkg: lib.optional config.my.modules.${name}.enable pkg) apps
  );
}
