{ lib, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  home = {
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  programs = {
    zsh = {
      enable = true;

      antidote = {
        enable = true;
        plugins = [
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
        ];
      };

      autosuggestion.enable = true;

      history = {
        append = true;
        save = 10000;
        size = 10000;
      };

      initExtra = /*bash*/ ''
        # make ssh work in tmux across reconnections
        if [[ -n "$SSH_TTY" ]] && [[ -n "$SSH_AUTH_SOCK" ]]; then
          export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.$(hostname)
        fi

        # use this cmd to open yazi and cd into whatever directory it is in when it exits
        # taken from https://yazi-rs.github.io/docs/quick-start/
        if command -v yazi &>/dev/null; then
            ycd() {
                local tmp
                tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

                yazi "$@" --cwd-file="$tmp"

                if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                    builtin cd -- "$cwd" || return 1
                fi

                rm -f -- "$tmp"
            }
        fi

        # source private files
        [ -f "$HOME/dotfiles_priv/.privrc" ] && source "$HOME/dotfiles_priv/.privrc"
        [ -f "$HOME/dotfiles_priv/.vars" ] && source "$HOME/dotfiles_priv/.vars"
        [ -f "$HOME/dotfiles_priv/.aliases" ] && source "$HOME/dotfiles_priv/.aliases"

      '';

      localVariables = {
        DISABLE_UPDATE_PROMPT = "true";
        COMPLETION_WAITING_DOTS = "true";
        DISABLE_UNTRACKED_FILES_DIRTY = "true";
      };

      sessionVariables = {
        XDG_CONFIG_HOME = "${home}/.config";
      };

      # shellAliases = {};
      shellGlobalAliases = {
        G = "| grep";
      };

      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          # "cursor"
        ];
      };
    };
  };
}
