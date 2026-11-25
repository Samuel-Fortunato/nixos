{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.modules.codex.enable =
    lib.mkEnableOption "Codex coding agent";

  config = lib.mkIf config.my.modules.codex.enable {
    programs.codex = {
      enable = true;
      mutableSettings = true;

      settings = {
        sandbox_mode = "workspace-write";
        approval_policy = "on-request";
        approvals_reviewer = "auto_review";
      };
    };

    home.packages = with pkgs; [
      bubblewrap

      # Utilities for agent-assisted development
      python3
      jq
      ripgrep
      fd
    ];
  };
}
