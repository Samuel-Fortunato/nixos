{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
		size = 11;
    };
    extraConfig = ''
      globinclude themes/noctalia.conf
      	'';
  };
}
