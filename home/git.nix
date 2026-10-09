{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      user.name = "Samuel-Fortunato";
      user.email = "samff2006@gmail.com";
    };
  };
}
