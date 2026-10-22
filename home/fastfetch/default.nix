{ pkgs, ... }:
let
  # ───────── things you'll tweak ─────────
  logoChoice = "image"; # "nixos_small" | "none" | "image"
  imagePath = ./NixOS.png; # put your PNG next to this file as logo.png
  # ───────────────────────────────────────

  hyprlandVersion = pkgs.hyprland.version;

  logos = {
    nixos_small = {
      type = "builtin";
      source = "nixos_small";
    };
    none = {
      type = "none";
    };
    image = {
      type = "kitty-direct";
      source = "${imagePath}";
      width = 20;
      height = 10;
      preserveAspectRatio = true;
    };
  };

  logo = logos.${logoChoice} // {
    padding = {
      top = 1;
      left = 1;
      right = 3;
    };
  };

  # ───────── box drawing helpers ─────────
  dim = "{#90}";
  blue = "{#34}";
  mag = "{#35}";

  key = col: label: "${dim}│ ${col}${label}";
  top = col: title: "${dim}╭─ ${col}${title} ${dim}─────────────────────";
  divide = col: title: "${dim}├─ ${col}${title} ${dim}─────────────────────";
  bottom = "${dim}╰──────────────────────────────";

  boxed = {
    inherit logo;
    display.separator = "  ";
    modules = [
      {
        type = "custom";
        format = top blue "system";
      }
      {
        type = "os";
        key = key blue "os     ";
      }
      {
        type = "kernel";
        key = key blue "kernel ";
      }
      # { type = "wm";       key = key blue "wm     "; }
      {
        type = "custom";
        key = key blue "wm     ";
        format = "Hyprland ${hyprlandVersion} (Wayland)";
      }
      {
        type = "shell";
        key = key blue "shell  ";
      }
      {
        type = "terminal";
        key = key blue "term   ";
      }
      # {
      #   type = "packages";
      #   key = key blue "pkgs   ";
      #   format = "{nix-system} (system), {nix-user} (user)";
      # }
      {
        type = "custom";
        format = divide mag "hardware";
      }
      {
        type = "cpu";
        key = key mag "cpu    ";
        format = "{name:-50}";
      }
      {
        type = "gpu";
        key = key mag "gpu    ";
        hideType = "integrated";
        format = "{name:-50}";
      }
      {
        type = "memory";
        key = key mag "mem    ";
      }
      {
        type = "disk";
        key = key mag "disk   ";
        folders = "/";
        format = "{size-used} / {size-total} ({size-percentage})";
      }
      {
        type = "uptime";
        key = key mag "uptime ";
      }
      {
        type = "custom";
        format = bottom;
      }
      {
        type = "colors";
        symbol = "circle";
        paddingLeft = 2;
      }
    ];
  };
in
{
  programs.fastfetch = {
    enable = true;
    settings = boxed;
  };

  # Instant switching, no rebuild: flags override the config's logo
  home.shellAliases = {
    ffs = "fastfetch --logo-type builtin -l nixos_small --logo-padding-top 1 --logo-padding-right 3";
    ffn = "fastfetch -l none";
    ffi = "fastfetch --logo-type kitty-direct -l ${imagePath} --logo-width 20 --logo-height 10 --logo-padding-top 1 --logo-padding-right 3";
  };
}
