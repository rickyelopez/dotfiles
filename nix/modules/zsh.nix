{ ... }: {
  programs = {
    zsh = {
      enable = true;
      oh-my-zsh =
        { enable = true; };
    };
  };
  # environment.pathsToLink = [ "/share/zsh" ];
}

