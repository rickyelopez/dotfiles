{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.git;
in
{
  options.my.git = {
    enable = lib.mkEnableOption "home git module.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      shellAliases = {
        # general
        gb = "git branch";
        gbc = "git branch --show-current";
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

        settings = {
          user = {
            name = "Ricky Lopez";
            email = "31072564+rickyelopez@users.noreply.github.com";
          };

          core = {
            fsmonitor = true;
            untrackedCache = true;
          };

          diff.colorMoved = "default";

          init.defaultBranch = "main";

          merge.conflictstyle = "diff3";

          pager = {
            branch = "cat";
            tag = "cat";
            blame = "delta";
          };

          push.autoSetupRemote = true;

          pull.rebase = true;

          signing.format = "openpgp";
        };

      };

      delta = {
        enable = true;
        options = {
          dark = true;
          features = "line-numbers zebra-dark"; # "side-by-side"
          hyperlinks = true;
          map-styles = "bold purple => syntax magenta, bold cyan => syntax blue";
          navigate = true;
        };
      };

      zsh.siteFunctions = {
        # Request confirmation for an action before proceeding
        # Expects a format string as an argument. '%s' in the format string will be
        # replaced with the branch name
        confirm_branch = /* bash */ ''
          local msg=$1
          local branch=''${2:-}

          if [ -n "$branch" ]; then
            msg=$(printf "$msg" "$branch")
          fi

          if [ -n "$ZSH_VERSION" ]; then
            read "?You are about to $msg. Continue? (y/n) " response
          else
            read -p "You are about to $msg. Continue? (y/n) " response
          fi

          if [[ $response =~ ^[yY]$ ]] || [[ $response =~ ^[yY][eE][sS]$ ]]; then
            return 0
          fi

          return 1
        '';

        # git push force
        gpf = /* bash */ ''
          local branch="''${1:-$(gbc)}"
          if ! confirm_branch "force-push to $branch"; then
            echo "Cancelled" && return 1
          fi
          git push -f $branch
        '';

        # git push origin
        gpu = /* bash */ ''
          local branch="''${1:-$(gbc)}"
          if ! confirm_branch "push branch $branch to origin"; then
            echo "Cancelled" && return 1
          fi
          git push -u origin $branch
        '';

        # git push origin force
        gpuf = /* bash */ ''
          local branch="''${1:-$(gbc)}"
          if ! confirm_branch "force push branch $branch to origin"; then
            echo "Cancelled" && return 1
          fi
          git push -f -u origin $branch
        '';

        # git branch delete
        gbd = /* bash */ ''
          local branch="''${1:-$(gbc)}"
          if ! confirm_branch "delete branch $branch"; then
            echo "Cancelled!" && return 1
          fi
          git branch -D $branch
        '';

        # delete branch matching grepped pattern
        gbdg = /* bash */ ''
          local branch
          local results

          if ! branch="$(gbg "$@")"; then
            echo "Failed to grep for branch"
            return 1
          fi

          if ! results=$(cat "$branch" | wc -l); then
            echo "Failed to count number of matched branches"
            return 1
          fi

          if [[ "$results" != 1 ]]; then
            printf "More than one branch matched!\n%s\n" "$branch"
            return 1
          fi

          gbd "$branch";
        '';

        # fetch branch from origin
        gfo = /* bash */ ''
          branch=$1
          shift
          git fetch --prune origin "$branch":"$branch" "$@"
        '';

        # checkout branch matching grepped pattern
        gcog = /* bash */ ''
          local branch=$1
          shift
          gco $(gbg "$branch") "$@"
        '';

        # fetch and checkout branch
        gfco = /* bash */ ''
          gfo "$1" && gco "$1";
        '';
      };
    };
  };
}
