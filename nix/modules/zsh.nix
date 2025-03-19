{ pkgs, user, home, ... }: {

  home = {
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ] ++ pkgs.lib.lists.optionals (pkgs.stdenv.isDarwin) [
      "$(/opt/homebrew/bin/brew --prefix)/opt/util-linux/bin"
      "$(/opt/homebrew/bin/brew --prefix)/opt/util-linux/sbin"
    ];

    shellAliases = {
      lg = "lazygit";
      zcdb = "ninja -C out all_apps -t compdb | jq \'[ .[] | select(.command | contains(\"bad_toolchain\")|not) ]\' > compile_commands.json";
    };
  };

  programs = {
    zsh = {
      enable = true;

      antidote = {
        enable = true;
        plugins = [
          "chriskempson/base16-shell"
          "romkatv/powerlevel10k"
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
        [ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
        [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

        # make ssh work in tmux across reconnections
        if [[ -n "$SSH_TTY" ]] && [[ -n "$SSH_AUTH_SOCK" ]]; then
          export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.$(hostname)
        fi

        # load base16 theme
        BASE16_SHELL="$HOME/.config/base16-shell/"
        if [ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && [ "$SHLVL" -le 2 ]; then
            source "$BASE16_SHELL/profile_helper.sh"
        fi

        NVM_DIR="$HOME/.nvm"
        function load_nvm() {
            if [ -d "$NVM_DIR" ]; then
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
                export NVM_DIR
            fi
        }

        ## activate python env from path or in current directory if no path given
        activate() {
            if [ "$#" -eq 0 ]; then
                if [ -f ./env/bin/activate ]; then
                    source ./env/bin/activate || echo "'./env/bin/activate' does not exist"
                    return 0
                elif [ -f ./.venv/bin/activate ]; then
                    source ./.venv/bin/activate || echo "'./env/bin/activate' does not exist"
                    return 0
                fi
            else
                [ -f "$1"/bin/activate ] && source "$1"/bin/activate || echo "'$1/bin/activate' does not exist"
            fi
        }

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

      '' + pkgs.lib.optionalString (!pkgs.stdenv.isDarwin) "load_nvm";

      # initExtraBeforeCompInit = '' '';

      initExtraFirst = /*bash*/ ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${user}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${user}.zsh"
        fi
      '';

      localVariables = {
        DISABLE_UPDATE_PROMPT = "true";
        COMPLETION_WAITING_DOTS = "true";
        DISABLE_UNTRACKED_FILES_DIRTY = "true";
      };

      sessionVariables = {
        XDF_CONFIG_HOME = "${home}/.config";
        UNCRUSTIFY_CONFIG = "${home}/.config/uncrustify.cfg";
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

      oh-my-zsh =
        {
          enable = true;
          extraConfig = /*bash*/ ''
            zstyle ':omz:plugins:git' aliases no
          '';
          plugins = [ "git" "sudo" ];
        };
    };
  };
}
