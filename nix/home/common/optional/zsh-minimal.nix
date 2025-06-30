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

      history = {
        append = true;
        save = 10000;
        size = 10000;
      };

      initContent = lib.mkMerge
        [
          (lib.mkOrder 500 /*bash*/
            ''
              # make ssh work in tmux across reconnections
              if [[ -n "$SSH_TTY" ]] && [[ -n "$SSH_AUTH_SOCK" ]]; then
                export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.$(hostname)
              fi
            '')

          (lib.mkOrder 1500 /*bash*/
            ''
              # source private files
              [ -f "$HOME/dotfiles_priv/.privrc" ] && source "$HOME/dotfiles_priv/.privrc"
              [ -f "$HOME/dotfiles_priv/.vars" ] && source "$HOME/dotfiles_priv/.vars"
              [ -f "$HOME/dotfiles_priv/.aliases" ] && source "$HOME/dotfiles_priv/.aliases"
            '')
        ];

      localVariables = {
        DISABLE_UPDATE_PROMPT = "true";
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

      zprof.enable = false;
    };
  };
}
