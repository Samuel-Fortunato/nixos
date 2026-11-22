# NixOS Configuration — Architecture Review & Refactoring Handoff

**Prepared:** 2026-11-22 (Europe/Lisbon)  
**Repository:** <https://github.com/Samuel-Fortunato/nixos>  
**Purpose:** Preserve the analysis, decisions/recommendations, assumptions, risks, and actionable next steps from the configuration review, so it can be continued in a future ChatGPT conversation without relying on this conversation's context.

> **Status / decision boundary:** This is a **review and proposed migration plan**, not a record of changes already applied. No repository files were modified during the review. The user has not yet explicitly approved every recommendation. Verify the current branch and working-tree changes before making edits. All conclusions below refer to the reviewed GitHub snapshots, not necessarily the user's uncommitted local configuration.

## 1. User goals, preferences, and constraints

The user wants a portable, maintainable, declarative NixOS + **standalone Home Manager** configuration with:

- **Modularity and fine-grained control:** continue to enable/disable individual features through `my.modules.<name>.enable`.
- **Convenient new-host setup:** stop copying dozens of individual `enable = true` settings into each `hosts/<host>/home.nix`.
- **Meaningful feature groups:** profiles such as `cli`, `development`, `desktop`, `media`, and possibly `academic` should enable sensible sets of modules.
- **Minimal unnecessary complexity:** a `profiles/home/daily-desktop.nix` directory with only one file is not useful as-is. Keep `profiles/` only if it serves genuinely reusable groups, including NixOS-level profiles where appropriate.
- **Visible dependencies and portable fallbacks:** avoid configurations that evaluate but have broken runtime features because the corresponding program is not installed (e.g., Hyprland launchers, Yazi openers, Neovim plugins). Differentiate hard dependencies from optional integrations.
- **Working cross-environment setups:** preserve current laptop and VM behaviour and support the existing NixOS-WSL branch.
- **Safe, incremental migration:** minimize unrelated changes in the same commit; preserve behaviour first, then improve dependencies/specialized modules, and validate each stage.

The user did not request implementation in the original review; this document preserves the plan.

## 2. Repository snapshot and branches inspected

GitHub repository was inspected via the connected GitHub interface, including recursive file trees and selected contents across **all three branches** reported at the time.

| Branch | Reviewed commit | Observation |
|---|---|---|
| `main` | `cbb47c49f8296e169ed58195216f9834d5c85e48` | Primary configuration; use as refactoring base. |
| `feat/nixos-wsl` | `ea68659ee732390452b2d571aa109a0175299818` | Adds WSL system and HM configurations and Neovim portability fixes. At review time, 2 commits ahead / 11 behind `main` (diverged). |
| `hm-modular-migration` | `839b0d9f80145eb2b2400bafb4962f787ef38401` | Older modularization history, now substantially overtaken by `main`; not a suitable branch to wholesale merge. At review time, 36 commits ahead / 142 behind `main` (diverged). |

**Important limitation:** Repository inspection was **static**. We did not run `nix eval`, `nix build`, or actual service/application tests against these commits. Some runtime issues are hypotheses/risks, not verified failures. An exact in-chat diff was not applied to the repo.

### Current `main` structure, summarized

```text
flake.nix                       # Repeated host-specific NixOS and HM declarations
configuration.nix               # Shared NixOS basics and automatic module imports
hosts/
  laptop/{default.nix,home.nix,hardware-configuration.nix}
  vm/{default.nix,home.nix,hardware-configuration.nix}
modules/
  home/                         # Feature modules, including complex application configs
    default.nix                 # Auto-discovery and shared HM identity/basics
    apps.nix                    # Small togglable packages
    git.nix, lazygit.nix, zsh.nix, starship.nix, ...
    neovim/, hyprland/, noctalia/, yazi/, music-wallpaper/, ...
  nixos/                        # Shared NixOS feature/extension modules
profiles/
  home/daily-desktop.nix        # One large preset mixing CLI, development, desktop, media
```

The current `modules/home/default.nix` auto-discovers top-level `.nix` files and subdirectories containing `default.nix`, and sets HM identity for `samuel`, home `/home/samuel`, `stateVersion = "26.05"`, a backup extension, and an out-of-store `/etc/nixos` symlink. `configuration.nix` uses `lib.filesystem.listFilesRecursive ./modules/nixos` for system module imports.

The current `daily-desktop.nix` enables Zsh, Kitty, Starship, Fastfetch, Ripgrep; Git, Neovim, LazyGit, GitHub CLI; Hyprland, Noctalia and music wallpaper; desktop themes, XDG, file managers; Chrome, Spotify, Zathura, Loupe, Showtime, calculator, LiteMDview; Proton Pass, Btop, Tmux, Evtest. The laptop adds things like fonts, OnlyOffice, LaTeX, MATLAB, Codex, MEGA sync, Razer, KiCad. The VM imports the same big desktop profile. WSL currently has a hand-picked smaller list on its branch.

## 3. High-level diagnosis

**Individual modules are already modular, but machine composition is not.** Today, hosts choose modules in bulk via a single giant desktop preset plus many manual booleans. A portable CLI/WSL environment cannot meaningfully reuse that preset, while the NixOS laptop and VM repeat several system services. Some feature modules assume other programs exist without asserting or handling the dependency.

**Recommendation:** Preserve the existing per-feature modules and `my.modules.*.enable` control; build a small layer of meaningful **profiles** above them and preserve host files only for identity, hardware and exceptions.

Conceptual hierarchy:

```text
Host: what is different about this machine?
  + Profiles: what environment/feature groups does it need?
    + Modules: how is each individual feature implemented?
```

Profiles are **selections**, not new places to duplicate application configuration.

## 4. Proposed target structure

```text
nixos/
├── flake.nix
├── flake.lock
├── configuration.nix
├── hosts/
│   ├── laptop/
│   │   ├── default.nix
│   │   ├── home.nix
│   │   └── hardware-configuration.nix
│   ├── vm/
│   │   ├── default.nix
│   │   ├── home.nix
│   │   └── hardware-configuration.nix
│   └── wsl/
│       ├── default.nix
│       └── home.nix
├── profiles/
│   ├── home/
│   │   ├── cli.nix
│   │   ├── development.nix
│   │   ├── desktop.nix
│   │   ├── media.nix
│   │   └── academic.nix
│   └── nixos/
│       └── graphical.nix
├── modules/
│   ├── home/                 # Existing individual features, intact initially
│   └── nixos/                # Existing system modules, intact initially
└── tests/                    # Optional: evaluation/combination checks
```

Names and exact memberships are **proposals**. Don't create profiles simply for directory symmetry. A single `profiles/nixos/graphical.nix` is already worthwhile if it meaningfully removes laptop/VM duplication; do not invent empty system-level `cli`, `media`, etc.

### Suggested Home Manager profile memberships

| Profile | Proposed features | Caveats |
|---|---|---|
| `cli` | Zsh, Starship, Fastfetch, Ripgrep, Tmux, Btop | Consider Yazi core here after separating GUI integrations. |
| `development` | Git, GitHub CLI (`gh`), LazyGit, Neovim | Neovim itself needs portable fallbacks and optional language-tool integrations. |
| `desktop` | Hyprland, Noctalia, Kitty, GTK, cursor, XDG, Seahorse, Thunar, Yazi, Trash, Udiskie, Loupe, calculator | Need sensible launcher/openers contracts; possible Chrome in desktop or app override depending user preference. |
| `media` | Spotify, Showtime, music wallpaper integration | Wallpaper requires Hyprland + Noctalia; either assert these or structure it as a desktop-specific optional module. |
| `academic` | LaTeX, OnlyOffice, Zathura, LiteMDview, potentially KiCad | MATLAB could remain host-specific given Distrobox environment/path. |

Chrome, Proton Pass, Evtest and various utilities should be assigned deliberately; exact groups need a final selection so modules aren't silently omitted. `academic` might be called `study`/`engineering` if that better matches future machines.

### Suggested NixOS profile

`profiles/nixos/graphical.nix`: share Hyprland, PipeWire, graphics, Polkit, AccountsService, UDisks2, relevant common desktop packages, and optionally other common desktop integration currently repeated in laptop and VM.

Keep **host-specific**: NVIDIA vs virtual graphics, bootloader/partition configuration, Bluetooth and USB devices, LabJack udev rule, laptop power management, dual-boot Windows mount, virtual-machine guest support, greeter choice, monitor-specific configuration, system state version. Do not automatically move every overlapping line into a profile if it may genuinely vary by machine.

## 5. Profile mechanism: recommended option-based profiles

Two workable forms were considered:

1. Plain `imports = [ ../../profiles/home/cli.nix ... ];`: simple, but direct `true` settings can conflict with per-host explicit `false` overrides.
2. **Recommended:** `my.profiles.<name>.enable` options that set individual `my.modules.*.enable` using `lib.mkDefault true`. Easy discovery and fine-grained overrides, with slightly more scaffolding.

Example implementation:

```nix
# profiles/home/development.nix
{ config, lib, ... }:
{
  options.my.profiles.development.enable =
    lib.mkEnableOption "Development environment";

  config = lib.mkIf config.my.profiles.development.enable {
    my.modules = {
      git.enable = lib.mkDefault true;
      gh.enable = lib.mkDefault true;
      lazygit.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
    };
  };
}
```

`lib.mkDefault` establishes **overridable defaults**, not unconditionally forced installations. The host can explicitly set `my.modules.someFeature.enable = false`, although a hard dependency assertion may then reject an invalid combination.

Illustrative laptop composition (not yet applied):

```nix
# hosts/laptop/home.nix
{ ... }:
{
  my.profiles = {
    cli.enable = true;
    development.enable = true;
    desktop.enable = true;
    media.enable = true;
    academic.enable = true;
  };

  my.modules = {
    matlab.enable = true;
    codex.enable = true;
    razer.enable = true;
    mega-sync.enable = true;
    kicad.enable = true;
    proton-drive.enable = false;
  };
}
```

Illustrative WSL selection:

```nix
# hosts/wsl/home.nix
{ ... }:
{
  my.profiles = {
    cli.enable = true;
    development.enable = true;
  };

  my.modules.fastfetch.enable = false;
}
```

**Import requirement:** these profile modules must actually be imported into the Home Manager module graph (explicit import aggregator or existing discovery logic adapted to `profiles/home`). `my.profiles.*` cannot be set until the relevant modules and their options are loaded. Keep this clear when implementing.

**Avoid accidental overengineering:** no elaborate role-inheritance framework is necessary. Begin with only the profile options that serve existing hosts.

## 6. Dependencies: model three kinds

- **Hard dependencies:** a feature can't work as designed without another. Either make the dependency a default and assert it, or assert directly.
- **Optional integrations:** a feature works independently, but integrates with another if available. Gate integration on the underlying program/option; do **not** create fake hard dependencies.
- **Runtime assumptions:** an external executable, desktop entry, session, or path is embedded in a Lua/script setting. Validate availability, make configurable, or degrade gracefully.

| Feature | Existing state (main) | Recommendation |
|---|---|---|
| LazyGit → Git (+ Delta integration) | `modules/home/lazygit.nix` already asserts `my.modules.git.enable` | Keep assertion; optionally set Git `lib.mkDefault true` when LazyGit enabled, retaining assertion if user explicitly disables Git. Git module also sets up Delta. |
| Starship ↔ Zsh | Zsh integration is unconditionally enabled | Not a true hard dependency: set `enableZshIntegration = config.programs.zsh.enable;` so Starship works with other shells. |
| Neovim → Git | lazy.nvim bootstrap executes `git clone` | Make bootstrap requirements available/documented, with optional portable fallback. |
| Neovim theme → matugen | `require("matugen").setup()` unconditionally in `main` | Reuse WSL branch's `pcall` and fallback theme. |
| Neovim MATLAB → Distrobox, Node, MATLAB files | Language server command is defined even on environments without MATLAB tooling | Conditional plugin/LSP enablement or a separate Neovim MATLAB feature toggle. |
| Neovim ESP32 → ESP-IDF tooling | ESP32 plugin is always part of Lua plugin specs | Optional integration or check for `idf.py`; don't require it on WSL/VM. |
| VimTeX → Zathura, TeX suite | `zathura_simple` viewer is fixed | Make viewer choice conditional; avoid breaking portable Neovim. |
| Hyprland launchers → Kitty, Yazi, Thunar, Chrome, calculator, Noctalia | Hard-coded commands in `programs.lua` | Define desktop profile requirements and/or generate command names from enabled module choices. Don't make minor optional apps hard build blockers. |
| Yazi openers → Neovim, Kitty, xdg-open | Unconditional opener commands | Split CLI vs GUI openers or conditionalize based on enabled modules. |
| XDG associations → Zathura, Loupe, Yazi | Already conditional on enabled modules | **Keep** as a good example of dependency-aware integration. |
| Music wallpaper → Noctalia + Hyprland | Existing assertion checks both | **Keep** assertion; review location/profile membership. |
| Zsh clipboard helper → wl-copy | Function unconditionally uses `wl-copy` | Add runtime availability check or conditional installation; clipboard-specific helper may not apply in headless/WSL. |
| Noctalia watcher → writable checkout + monitor | Tied to `/etc/nixos` and monitor name `eDP-1` | Make exporter enable and checkout path configurable independently of monitor identity. |

Suggested Starship change:

```nix
programs.starship = {
  enable = true;
  enableZshIntegration = config.programs.zsh.enable;
};
```

Suggested *optional* LazyGit auto-selection (preserving existing assertion):

```nix
config = lib.mkIf config.my.modules.lazygit.enable {
  my.modules.git.enable = lib.mkDefault true;
  assertions = [{
    assertion = config.my.modules.git.enable;
    message = "LazyGit requires Git to be enabled.";
  }];
  # Existing programs.lazygit configuration ...
};
```

Note the original existing assertion is already valid; don't imply this whole change is mandatory.

### Neovim-specific observations

- `modules/home/neovim/default.nix` installs LSPs and tools including clang-tools, basedpyright, texlab, lua-language-server, nixd, gcc, cargo, rustc, ripgrep, fd, etc. A portable baseline may be heavier than necessary, but preserve dev functionality while first restructuring.
- `config/lua/core/lazy.lua` bootstraps lazy.nvim via Git and stores plugin lockfile in state (`lazy-lock.json`) rather than a tracked reproducible project lockfile. Consider pinning plugin versions / reproducibility separately.
- `config/lua/lsp_config/servers.lua` defines MATLAB language server via Distrobox and ESP32-specific clangd configuration. `config/lua/plugins/tools/esp32-nvim.lua` and MATLAB plugin are loaded via general plugin import.
- Main's `config/lua/plugins/ui/base16.lua` calls `require("matugen").setup()` without a guard. WSL branch adds `pcall(require, "matugen")` with `habamax` fallback; this is worth carrying forward.
- Main's Neovim server-start logic only checks if the runtime directory exists; WSL branch adds writability detection and a fallback under `stdpath("state")`. Preserve the WSL improvement.
- Test combinations for Lua/Neovim in headless, GUI, WSL; avoid rewriting the whole plugin manager in Nix as part of this migration.

### Hyprland-specific observations

- `modules/home/hyprland/config/config-sections/programs.lua` includes `kitty`, `kitty --class yazi -e yazi`, `thunar`, `google-chrome-stable`, `gnome-calculator` as fixed commands.
- `keybindings.lua` also invokes Noctalia actions and assumes the desktop stack. Prefer desktop profile and eventually generated command mapping, but keep current bindings behaviour until verified.
- Current Home Manager Hyprland integration sets `package = null`, `portalPackage = null`, `systemd.enable = false`, while NixOS enables `programs.hyprland.withUWSM = true`: avoid casually breaking the current UWSM model.
- Monitor config includes physical and VM monitor entries and a global/default scale; consider host-specific monitor metadata later, but preserve functional behaviour first.

## 7. Full-repository improvement findings, prioritised

### High: Host portability and composition

**`flake.nix` repeats NixOS and standalone Home Manager definitions.** Laptop/VM HM blocks are nearly identical except host file and monitor. WSL branch adds a third repeated block. Prefer a small declarative host spec table plus `mkNixosHost` / `mkHomeHost` helper functions and `lib.mapAttrs` / `lib.mapAttrs'`.

Illustrative **shape only**, not drop-in code:

```nix
hostSpecs = {
  nixos-laptop = {
    dir = "laptop";
    system = "x86_64-linux";
    monitor = "eDP-1";
    extraModules = [ umbriel.nixosModules.default ];
  };
  nixos-vm = {
    dir = "vm";
    system = "x86_64-linux";
    monitor = "Virtual-1";
    extraModules = [];
  };
  nixos-wsl = {
    dir = "wsl";
    system = "x86_64-linux";
    monitor = "WSL";
    extraModules = [ nixos-wsl.nixosModules.default ];
  };
};
```

Use host specs to generate both NixOS and HM outputs. Still require an explicit one-line host entry so exceptional modules remain visible. **Don't** initially implement magical host directory auto-discovery.

**Laptop and VM repeat system services** such as NetworkManager, graphics, Hyprland, PipeWire, AccountsService, UDisks2, Polkit and some packages. Extract true common features to `profiles/nixos/graphical.nix`; retain host-specific graphics, hardware, boot, and session display manager specifics.

**Hard-coded user/path references** exist in `modules/home/default.nix`, Noctalia, MATLAB and Proton Drive modules. User identity can remain `samuel` if intentional, but derive application paths from `config.home.homeDirectory` and make checkout locations configurable when appropriate.

### Medium: Import mechanism

`configuration.nix` currently:

```nix
imports = lib.filesystem.listFilesRecursive ./modules/nixos;
```

This recursively imports **every file**, not just `.nix`. Currently harmless because directory contains Nix module files, but future READMEs or assets may break evaluation. Filter `.nix`, or use a controlled import aggregator.

The HM `modules/home/default.nix` auto-discovers `.nix` and directories with `default.nix`, which is more selective. Document that module files are **loaded** but most do not take effect until enabled.

### Medium: MEGA sync implementation

`modules/home/mega-sync.nix` installs `pkgs.megacmd` and runs `mega-cmd-server`, not the graphical **MEGAsync** client. It does not by itself create a synchronization pair. Choose intentionally between CLI and GUI; consider renaming to `megacmd.nix`, or using the appropriate Home Manager MEGAsync service where available. Verify current package/module options on your nixpkgs/HM revisions before changing.

### Medium: Noctalia exporter and non-declarative boundaries

- `modules/home/noctalia/watcher.nix` enables the export watcher only when `monitorName == "eDP-1"` and Noctalia is enabled.
- Export writes to `/etc/nixos/modules/home/noctalia/config.generated.nix`; `accept-settings.sh` defaults to `/etc/nixos` too. This assumes a writable checkout at a fixed path.
- `modules/home/noctalia/config.nix` has monitor placeholders and user-specific absolute paths for avatar/wallpapers; some commands reference the user profile and local scripts.
- The exporter, `config.nix` snapshot, GUI-to-Nix flow and restore logic are fairly complex and worth preserving and testing. **Do not rewrite them in the first profile migration**.
- Later introduce explicit `my.modules.noctalia.exporter.enable` or similar and a configurable `repoPath`, independent of monitor identity; make paths derivable.

### Medium: Unconditional packages and separate system/HM roles

`modules/home/packages.nix` unconditionally adds `tree` and `noto-fonts`. Decide if these are minimal baseline packages or should be selected by a profile. `modules/home/fonts.nix` also installs Noto fonts when enabled, creating potential duplication.

NixOS globally enables `programs.zsh` / `programs.neovim` while Home Manager also enables/configures them. This can be intentional: system provides login shell/emergency editor, HM provides user configuration. Document roles and avoid ambiguity.

**Standalone HM** means enabling a Home Manager desktop profile does not magically enable NixOS services, nor vice versa; system and HM profiles are separate activations.

### Medium: Tests and branch integration

- Add explicit evaluation commands for all `nixosConfigurations` and `homeConfigurations`.
- Test **minimal CLI without desktop** and **desktop with selected optional applications disabled** to catch hidden dependencies.
- Integrate the WSL branch's host files and two Neovim portability changes, resolving branch divergence carefully. Don't wholesale merge the much older `hm-modular-migration` branch.
- Potential CI: GitHub Actions evaluates configurations on pull requests (optionally builds later).

### Lower-priority / safety and maintainability

- Laptop `users.users.samuel.extraGroups` includes `input` for Bongo Cat. This may provide broad input-device access; assess a narrower udev/device rule if possible.
- Windows NTFS mount uses `umask=022`; consider stricter access policy if required.
- Laptop `/boot/efi` refers to `/dev/nvme0n1p1`, while using a stable filesystem UUID would be safer against enumeration changes. **Verify the actual UUID on-device before modifying.**
- Laptop uses `pkgs.linuxPackages_latest` and NVIDIA; understand tradeoff between newest kernel features and stability. No requirement to change immediately.
- Hidden zero-second GRUB timeout with Windows dual-boot can complicate recovery; document how to reach GRUB or consider a small timeout.
- Old `proton-drive.nix` defines an unattended 5-minute `rclone bisync` timer, currently disabled. Archive/mark experimental so it is not enabled by accident; this previously had conflict risks.
- `modules/home/music-wallpaper/flake.nix` and `flake.lock` define a nested development shell. This is valid, but could eventually become a root-flake devShell to reduce independent lockfile maintenance.
- Specialized scripts and helpers need runtime tools and tests (`wl-copy`, `noctalia`, `hyprctl`, `systemd-inhibit`). Watch for PATH differences inside systemd user services.
- Don't over-refactor complex Lua/Noctalia systems before the profile and host composition layer is verified.

## 8. WSL branch — specific migration notes

On `feat/nixos-wsl`:

- Root flake adds `nixos-wsl` input (`github:nix-community/NixOS-WSL/main`) following root nixpkgs, plus `nixosConfigurations.nixos-wsl` and `homeConfigurations."samuel@nixos-wsl"`.
- `hosts/wsl/default.nix` enables WSL, sets `defaultUser = "samuel"`, hostname `nixos-wsl` and `system.stateVersion = "26.05"`.
- `hosts/wsl/home.nix` currently manually enables Zsh, Starship, Git, Neovim, LazyGit, Ripgrep and Yazi.
- Main and WSL branch differ in several newer desktop updates; don't simply switch to WSL branch as the restructuring baseline.
- Preserve WSL Neovim fixes: fallback to writable state directory for Neovim server socket; protected `matugen` require with fallback colorscheme.
- A `cli` + `development` profile would replace most of the WSL hand-selection, with custom exceptions (e.g. Yazi, optional Fastfetch).
- Be mindful that WSL needs Linux/NixOS-specific system exceptions and cannot run standard Hyprland/Noctalia desktop assumptions by default.

## 9. Option discoverability

The Nix module system registers custom `my.modules.*` options even if they are disabled. A complete inventory can be **derived** rather than hand-maintained.

For the current laptop HM config:

```bash
nix eval --json \
  '.#homeConfigurations."samuel@nixos-laptop".options.my.modules' \
  --apply builtins.attrNames
```

This attempts to print **top-level registered module names**; nested flags such as `noctalia.musicWallpaper.enable` need recursive traversal. Confirm the exact `nix eval` behaviour against the installed Nix version. For the enabled *values*, inspect `.config.my.modules` or individual option paths as needed.

Possible later helper `nix-config-options`: list feature names, enabled state, descriptions and optionally selected profile. Showing *which profile caused an enable* requires added metadata or conventions; don't assume Nix produces that human-readable provenance automatically.

## 10. Validation commands

Run at repo root after making relevant changes. These commands are evaluation checks; they are **not evidence that the currently reviewed repo has passed**.

```bash
# Basic flake structure and declared checks (not a full replacement for evaluating all hosts)
nix flake check --no-build

# NixOS outputs
nix eval --raw \
  .#nixosConfigurations.nixos-laptop.config.system.build.toplevel.drvPath
nix eval --raw \
  .#nixosConfigurations.nixos-vm.config.system.build.toplevel.drvPath

# Standalone Home Manager outputs
nix eval --raw \
  '.#homeConfigurations."samuel@nixos-laptop".activationPackage.drvPath'
nix eval --raw \
  '.#homeConfigurations."samuel@nixos-vm".activationPackage.drvPath'
```

After WSL integration:

```bash
nix eval --raw \
  .#nixosConfigurations.nixos-wsl.config.system.build.toplevel.drvPath
nix eval --raw \
  '.#homeConfigurations."samuel@nixos-wsl".activationPackage.drvPath'
```

Suggested additional checks:

1. Minimal CLI-only HM evaluation should have no hard Noctalia, Hyprland, display server, or mandatory GUI dependencies.
2. `development` without `desktop` should launch Neovim without `matugen`/MATLAB errors.
3. Desktop profile with optional viewer/calculator absent should still evaluate and have sensible remaining keybindings.
4. Existing laptop and VM HM derivations should be compared before/after migration for unintended changes (exact derivation paths may change from harmless refactors; test behaviour and important settings, not only string equality).
5. For the laptop, perform appropriate build/activation/recovery checks after evaluation; avoid changing bootloader and disk settings as part of unrelated refactors.
6. Verify no essential module is missing from the new profiles compared to `daily-desktop.nix` plus the laptop's individual additions.

## 11. Proposed migration steps and commit boundaries

### Phase 0 — establish baseline (before edits)

- [ ] Record `git status`, local active branch, uncommitted work, and root `flake.lock`.
- [ ] Confirm main and feature branch commits have not changed since the reviewed snapshots.
- [ ] Save current successful `nix eval` output for laptop/VM NixOS and HM when feasible.
- [ ] Inventory every active module in `daily-desktop.nix`, laptop/home, vm/home and WSL/home so no application is lost.

### Phase 1 — introduce meaningful profiles (behavior-preserving)

- [ ] Create `profiles/home/{cli,development,desktop,media,academic}.nix` with `my.profiles.*.enable` options.
- [ ] Ensure these profile modules are imported into HM evaluations.
- [ ] Implement selections using `lib.mkDefault true` to preserve individual overrides.
- [ ] Replace `daily-desktop.nix` imports with profile selections in laptop and VM.
- [ ] Create `profiles/nixos/graphical.nix` for true shared system functionality; move only genuine overlap from laptop and VM.
- [ ] Verify identical important enabled features and evaluate both existing hosts.
- [ ] Retire `daily-desktop.nix` only after parity checks.

### Phase 2 — simplify host constructors

- [ ] Create small host metadata table in `flake.nix`.
- [ ] Generate NixOS and standalone HM outputs with shared helper functions.
- [ ] Preserve input modules specific to each host (Umbriel for laptop; NixOS-WSL for WSL).
- [ ] Keep monitor and platform metadata explicit.
- [ ] Evaluate both host outputs again. Avoid reorganizing unrelated modules here.

### Phase 3 — integrate WSL

- [ ] Bring in WSL flake input and host files from `feat/nixos-wsl` via selective commits/cherry-picks or carefully reconciled patches.
- [ ] Preserve WSL's Neovim socket and theme fallback changes.
- [ ] Apply new `cli` + `development` profile selections with WSL-specific exceptions.
- [ ] Evaluate and test WSL without GUI assumptions.

### Phase 4 — hard/soft dependency cleanup

- [ ] Conditional Starship/Zsh integration.
- [ ] Preserve (or optionally enhance) LazyGit/Git dependency assertion.
- [ ] Split/gate Neovim desktop theming, MATLAB, ESP32, VimTeX integrations.
- [ ] Make Yazi openers conditional or split portable and graphical variants.
- [ ] Make Hyprland application launch commands configurable/consistent with profile choices; don't hard-require all applications.
- [ ] Keep current conditional MIME associations and music-wallpaper assertion.
- [ ] Validate CLI-only, dev-only, and desktop combinations.

### Phase 5 — specialized cleanup (separate PRs/commits)

- [ ] Decide MEGAcmd daemon vs graphical MEGAsync.
- [ ] Decouple Noctalia watcher from `eDP-1` and fixed `/etc/nixos` checkout path.
- [ ] Replace justified absolute home paths with HM-derived values.
- [ ] Decide baseline packages, fonts overlap, system/HM shell/editor responsibilities.
- [ ] Filter NixOS auto-import to `.nix` files or explicit imported modules.
- [ ] Review old Proton Drive timer, device permissions, dual-boot recovery and nested flake.

### Phase 6 — long-term validation and docs

- [ ] Add explicit checks for every NixOS/HM output (including WSL).
- [ ] Add CLI-only and desktop-minus-optional-module regression tests.
- [ ] Optional GitHub Actions for evaluation on pull requests.
- [ ] Document adding a host, choosing profiles and listing module options.

**Commit discipline:** Keep profile introduction, flake consolidation, WSL integration, dependency fixes, and app-specific cleanups separated. Avoid combining all changes in one unreviewable refactor.

## 12. Final recommendations and open decisions

### Recommendations from the review (not yet necessarily user-approved)

1. **Keep `modules/home` and `modules/nixos`**, preserving `my.modules.*.enable`.
2. **Keep and expand `profiles`** into functional feature groups, with an actual `profiles/nixos/graphical.nix` only if it provides shared value.
3. Prefer **option-based profiles** (`my.profiles.<group>.enable`) selecting modules via `lib.mkDefault true`.
4. Keep **host files** for physical/virtual hardware, identity, monitors, greeters and optional overrides.
5. Simplify `flake.nix` using a small explicit host spec table and two reusable constructors.
6. Preserve **standalone Home Manager** rather than moving it into the NixOS module system during this refactor.
7. Integrate WSL from the feature branch carefully after structural refactor; do not wholesale merge the historical HM migration branch.
8. Handle **hard dependencies with assertions/defaults**, **optional integrations conditionally**, and **runtime paths explicitly**.
9. Prioritize preserving behaviour and evaluation of each host before app-specific improvements.

### Decisions to confirm when work resumes

- Exactly which modules belong in `cli`, `development`, `desktop`, `media`, and `academic` (particularly Yazi, Chrome, Proton Pass, Evtest, Codex, KiCad).
- Whether `media` and `academic` are used by enough hosts to justify each as profiles immediately.
- Whether the desired MEGA workflow is GUI `megasync` or headless `megacmd`.
- Whether to keep an intentionally global minimal shell/editor installed at NixOS system level.
- Whether to keep automatic file discovery for modules or use explicit import aggregators.
- Whether to make profile-related module names generic or retain `my.modules` as the only individual toggle namespace (recommend retaining existing names).
- Whether to introduce host generation functions now or after profile parity has been verified (recommend after).

## 13. Starting instructions for a future ChatGPT conversation

> We reviewed the GitHub repo `Samuel-Fortunato/nixos` on 2026-11-22. This document is our handoff. Our agreed goal is a portable, modular NixOS + standalone Home Manager configuration with reusable CLI/development/desktop/media/academic profiles and `my.modules.*.enable` overrides, preserving the laptop/VM setup and integrating the `feat/nixos-wsl` branch. The profile/host-factory/dependency plan is **proposed but not yet implemented**. Please first check the live repository/branches and uncommitted changes, then start with a behaviour-preserving, small-commit profile refactor. Do not rewrite Noctalia or Neovim wholesale during initial migration. Validate all host outputs and don't remove existing enabled features.

### Relevant repository links

- [Repository](https://github.com/Samuel-Fortunato/nixos)
- [Main flake](https://github.com/Samuel-Fortunato/nixos/blob/main/flake.nix)
- [NixOS shared configuration](https://github.com/Samuel-Fortunato/nixos/blob/main/configuration.nix)
- [Current one-file daily desktop profile](https://github.com/Samuel-Fortunato/nixos/blob/main/profiles/home/daily-desktop.nix)
- [Laptop HM configuration](https://github.com/Samuel-Fortunato/nixos/blob/main/hosts/laptop/home.nix)
- [VM HM configuration](https://github.com/Samuel-Fortunato/nixos/blob/main/hosts/vm/home.nix)
- [Automatic HM module loader](https://github.com/Samuel-Fortunato/nixos/blob/main/modules/home/default.nix)
- [LazyGit dependency assertion](https://github.com/Samuel-Fortunato/nixos/blob/main/modules/home/lazygit.nix)
- [Starship module](https://github.com/Samuel-Fortunato/nixos/blob/main/modules/home/starship.nix)
- [Neovim module](https://github.com/Samuel-Fortunato/nixos/blob/main/modules/home/neovim/default.nix)
- [Hyprland application launchers](https://github.com/Samuel-Fortunato/nixos/blob/main/modules/home/hyprland/config/config-sections/programs.lua)
- [Noctalia exporter/watcher](https://github.com/Samuel-Fortunato/nixos/blob/main/modules/home/noctalia/watcher.nix)
- [MEGA module](https://github.com/Samuel-Fortunato/nixos/blob/main/modules/home/mega-sync.nix)
- [WSL feature branch](https://github.com/Samuel-Fortunato/nixos/tree/feat/nixos-wsl)
- [Older HM modularization branch](https://github.com/Samuel-Fortunato/nixos/tree/hm-modular-migration)

---

*This handoff is intentionally self-contained and can be committed to the repository (for example under `docs/architecture-review-2026-11-22.md`) or uploaded to a future ChatGPT conversation as context.*
