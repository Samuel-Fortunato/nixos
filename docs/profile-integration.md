# Profiles and future WSL integration

Home Manager remains standalone. Host home files import `profiles/home` and select
`my.profiles.*.enable`; individual `my.modules.*.enable` settings override the
profile defaults. The NixOS graphical profile is separate and must be selected
in a system host explicitly. The `media` profile selects music wallpaper, which
requires Hyprland and Noctalia; enable the desktop profile or disable that module.

To add a host, add its system and home files and an explicit entry in the `hosts`
table in `flake.nix`. Set its platform, directory and monitor, and add any
host-specific NixOS modules to `extraModules`. The constructors expose separate
NixOS and standalone Home Manager outputs. Monitor names select Noctalia's
monitor-specific settings.

The WSL host uses the NixOS-WSL module and selects the CLI and development
profiles with overrides preserving the feature branch's module selection.
Neovim falls back to a writable state directory for its socket and to a built-in
theme when matugen is unavailable. Evaluate both WSL outputs and test them in
WSL before activation. The development profile is not yet a guarantee of a
fully portable runtime.

## Dependency observations

- LazyGit asserts that Git is enabled; music wallpaper asserts that Hyprland and
  Noctalia are enabled. XDG associations already follow selected applications.
- Hyprland launchers refer to specific applications. Disabling those
  applications can leave individual launchers unavailable even when evaluation
  succeeds. Yazi's Neovim, Kitty and desktop shortcut openers follow the
  corresponding module selections.
- Neovim bootstraps plugins through Git. Its MATLAB, ESP32 and Zathura
  integrations check for their tools at startup; the MATLAB language server
  also needs its expected server file and Distrobox environment. Test these
  integrations in their target environments.
- The Zsh clipboard helper requires `wl-copy` and reports when it is absent.
  The Noctalia exporter is enabled explicitly on the laptop; its configurable
  checkout path defaults to `my.repositoryPath` (`/etc/nixos` by default) and
  must be writable when used. The Home Manager configuration symlink uses the
  same `my.repositoryPath`, which hosts can override.
- The CLI profile enables Zsh without Neovim. Its `ncf` alias invokes `nvim`,
  so that alias needs Neovim even though the rest of the shell does not. The
  `homMan` helper invokes the standalone `home-manager` command and activates
  the configuration when called.

These are runtime assumptions or existing assertions, not new dependencies added
by the profiles. They are recorded here for follow-up without changing working
application configuration in this phase.

The system-wide Zsh and Neovim provide the login shell and a system editor;
standalone Home Manager configures the user's shell and editor. The MEGA module
runs MEGAcmd, not the graphical client, and does not create sync pairs. The
disabled Proton Drive module is experimental: it runs an unattended rclone
bisync timer and requires a separately initialized remote and careful testing.
The unconditional `tree` and Noto font packages remain part of the home
baseline; enabling the fonts module additionally configures Fontconfig.
