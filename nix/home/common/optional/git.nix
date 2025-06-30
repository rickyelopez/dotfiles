{ pkgs, lib, ... }: {
  home = {
    shellAliases = {
      # general
      gb = "git branch";
      gbc = "git branch --show-current";
      gbd = "confirm_branch \"delete branch \'%s\'\" && git branch -D || \"Cancelled\"";
      gbg = "git branch | grep -E";
      gbn = "git checkout -b";
      gcl = "git diff --name-only --diff-filter=U";
      gco = "git checkout";
      gdc = "git diff --check";
      gl = "git log";
      glo = "gl --oneline";
      gs = "git status";
      gsh = "git rev-parse --short HEAD";

      # rebasing;
      gir = "git rebase -i HEAD~";
      gra = "grb --abort";
      grb = "git rebase";
      grc = "grb --continue";

      # cherry-pick;
      gcp = "git cherry-pick";
      gcpa = "gcp --abort";
      gcpc = "gcp --continue";

      # committing;
      gca = "git commit --amend";
      gcan = "gca --no-edit";
      gcf = "git commit --fixup HEAD~";

      # pushing
      gp = "git push";
      gpf = "confirm_branch \"force-push to \'%s\'\" && git push -f || echo \"Cancelled\"";
      gpu = "confirm_branch \"push branch \'%s\' to origin\" && git push -u origin \"$(gbc)\" || echo \"Cancelled\"";
      gpuf = "confirm_branch \"force push branch \'%s\' to origin\" && git push -u origin \"$(gbc)\" -f || echo \"Cancelled\"";
    };
  };

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
    zsh.initContent = lib.mkOrder 1000
      /*bash*/ ''
      # Request confirmation for an action before proceeding
      # Expects a format string as an argument. '%s' in the format string will be
      # replaced with the branch name
      confirm_branch() {
          local branch
          local confirm

          if ! branch="$(gbc)"; then
              return 1
          fi

          local msg
          msg=$(printf "$1" "$branch")

          if [ -n "$ZSH_VERSION" ]; then
              read "?You are about to $msg. Continue? (y/n) " confirm
          else
              read -p "You are about to $msg. Continue? (y/n) " confirm
          fi

          if [[ $confirm =~ ^[yY]$ ]] || [[ $confirm =~ ^[yY][eE][sS]$ ]]; then
              return 0
          fi

          return 1
      }

      # delete branch(es??) matching grepped pattern
      gbdg() { gbd "$(gbg "$@")"; }

      # fetch branch from origin
      gfo() {
          branch=$1
          shift
          git fetch --prune origin "$branch":"$branch" "$@"
      }

      # checkout branch matching grepped pattern
      gcog() {
          local branch=$1
          shift
          gco $(gbg "$branch") "$@"
      }

      # fetch and checkout branch
      gfco() { gfo "$1" && gco "$1"; }
    '';
  };
}
