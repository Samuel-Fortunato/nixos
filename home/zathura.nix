{ ... }: {
  programs.zathura = {
    enable = true;

    extraConfig = "include noctaliarc";
	 options = {
	   recolor = true;
	 };
  };
}
