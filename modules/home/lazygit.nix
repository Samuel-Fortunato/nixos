{ config, lib, ... }: {
  options.my.modules.lazygit.enable = lib.mkEnableOption "Lazygit";

  config = lib.mkIf config.my.modules.lazygit.enable {
    programs.lazygit = {
      enable = true;

      enableZshIntegration = true;
      shellWrapperName = "lazygit";

      settings = {
        gui.nerdFontsVersion = "3";

        git.diffRenderers = [
          {
            command = ''
              delta --{{colorScheme}} --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"
            '';
          }
        ];

        customCommands = [
          {
            key = "C";
            context = "files";
            description = "Create new conventional commit";
            prompts = [
              {
                type = "menu";
                key = "Type";
                title = "Type of change";
                options = [
                  {
                    name = "build";
                    description = "Changes that affect the build system or external dependencies";
                    value = "build";
                  }
                  {
                    name = "feat";
                    description = "A new feature";
                    value = "feat";
                  }
                  {
                    name = "fix";
                    description = "A bug fix";
                    value = "fix";
                  }
                  {
                    name = "chore";
                    description = "Other changes that don't modify src or test files";
                    value = "chore";
                  }
                  {
                    name = "ci";
                    description = "Changes to CI configuration files and scripts";
                    value = "ci";
                  }
                  {
                    name = "docs";
                    description = "Documentation only changes";
                    value = "docs";
                  }
                  {
                    name = "perf";
                    description = "A code change that improves performance";
                    value = "perf";
                  }
                  {
                    name = "refactor";
                    description = "A code change that neither fixes a bug nor adds a feature";
                    value = "refactor";
                  }
                  {
                    name = "revert";
                    description = "Reverts a previous commit";
                    value = "revert";
                  }
                  {
                    name = "style";
                    description = "Changes that do not affect the meaning of the code";
                    value = "style";
                  }
                  {
                    name = "test";
                    description = "Adding missing tests or correcting existing tests";
                    value = "test";
                  }
                ];
              }

              {
                type = "input";
                title = "Scope";
                key = "Scope";
                initialValue = "";
              }

              {
                type = "menu";
                key = "Breaking";
                title = "Breaking change";
                options = [
                  {
                    name = "no";
                    value = "";
                  }
                  {
                    name = "yes";
                    value = "!";
                  }
                ];
              }
              {
                type = "input";
                title = "message";
                key = "Message";
                initialValue = "";
              }
              {
                type = "confirm";
                key = "Confirm";
                title = "Commit";
                body = "Are you sure you want to commit?";
              }
            ];
            command = ''git commit -m {{printf "%s%s%s: %s" .Form.Type (and .Form.Scope (printf "(%s)" .Form.Scope)) .Form.Breaking .Form.Message | quote}}'';
            loadingText = "Creating conventional commit...";
          }
        ];
      };
    };
  };
}
