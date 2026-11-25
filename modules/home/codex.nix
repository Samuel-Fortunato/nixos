{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.modules.codex.enable =
    lib.mkEnableOption "Codex coding agent";

  config = lib.mkIf config.my.modules.codex.enable {
    home.packages = with pkgs; [
      codex

      # Utilities for agent-assisted development
      python3
      jq
      ripgrep
      fd
    ];
  };
}
