# Profiles and future WSL integration

Home Manager remains standalone. Host home files import `profiles/home` and select
`my.profiles.*.enable`; individual `my.modules.*.enable` settings override the
profile defaults. The NixOS graphical profile is separate and must be selected
in a system host explicitly. The `media` profile selects music wallpaper, which
requires Hyprland and Noctalia; enable the desktop profile or disable that module.

To add a host, add its system and home files and an explicit entry in the `hosts`
table in `flake.nix`. Set its platform, directory and monitor, and add any
host-specific NixOS modules to `extraModules`. The constructors expose separate
NixOS and standalone Home Manager outputs. Monitor names currently also control
Noctalia's settings exporter, so choosing one has runtime consequences.

The existing `origin/feat/nixos-wsl` branch adds a NixOS-WSL input and module,
WSL host files, and two Neovim portability fixes. Integrating it remains a
separate change: reconcile its lock file, add the WSL module to its host entry,
select CLI and development profiles with explicit exceptions, and preserve the
writable socket directory and missing-matugen fallbacks. Evaluate both WSL
outputs and test them in WSL before activation. The development profile is not
yet a guarantee of a fully portable runtime.

## Dependency observations

- LazyGit asserts that Git is enabled; music wallpaper asserts that Hyprland and
  Noctalia are enabled. XDG associations already follow selected applications.
- Hyprland launchers refer to specific applications, and Yazi openers refer to
  Neovim, Kitty and desktop utilities. Disabling those applications can leave
  individual launchers or openers unavailable even when evaluation succeeds.
- Neovim bootstraps plugins through Git and its configuration assumes matugen
  and includes MATLAB, ESP32 and Zathura integrations. These require separate
  portability work and runtime testing, especially for WSL.
- The Zsh clipboard helper assumes `wl-copy`; the Noctalia exporter assumes a
  writable checkout at `/etc/nixos` and is tied to the `eDP-1` monitor.
- The CLI profile enables Zsh without Neovim. Its `ncf` alias invokes `nvim`,
  so that alias needs Neovim even though the rest of the shell does not. The
  `homMan` helper invokes the standalone `home-manager` command and activates
  the configuration when called.

These are runtime assumptions or existing assertions, not new dependencies added
by the profiles. They are recorded here for follow-up without changing working
application configuration in this phase.
