{ ... }: {
  programs.zathura = {
    enable = true;

    extraConfig = "include noctaliarc";
	 options = {
		selection-clipboard = "clipboard";
	   recolor = true;
		recolor-keephue = true;
		# recolor-reverse-video = true;
	 };
  };
}
