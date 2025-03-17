{ pkgs, ... }: {
  programs = {
    gh = {
      enable = true;
      gitCredentialHelper.enable = false;
      extensions = [
        pkgs.gh-dash
      ];
    };
    git = {
      enable = true;
      lfs.enable = true;

      userName = "Ricky Lopez";
      userEmail = "31072564+rickyelopez@users.noreply.github.com";

      extraConfig = {
        diff = {
          colorMoved = "default";
        };
        merge = {
          conflictstyle = "diff3";
        };
        pager = {
          branch = "cat";
          tag = "cat";
        };
      };

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };

      delta = {
        enable = true;
        options = {
          features = "side-by-side";
          navigate = true;
        };
      };
    };
  };
}
