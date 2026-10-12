{ ... }:
{
  xdg.desktopEntries.matlab-r2026b = {
    name = "MATLAB R2026b";
    comment = "MATLAB inside Debian Distrobox";
    exec = "distrobox enter matlab -- /home/samuel/.matlab/R2026b/bin/matlab -desktop";
    terminal = false;
    type = "Application";
    categories = [ "Science" ];
  };

  home.file.".local/bin/matlab-distrobox" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec distrobox enter matlab -- \
        /home/samuel/.matlab/R2026b/bin/matlab "$@"
    '';
  };
}
