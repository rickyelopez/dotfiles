{ pkgs, user, home, ... }: {
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

      initExtra = ''
        [[ -f $HOME/dotfiles_priv/.privrc ]] && source $HOME/dotfiles_priv/.privrc ]]
        [[ -f $HOME/dotfiles/.vars ]] && source $HOME/dotfiles/.vars
        [[ -f $HOME/dotfiles/.aliases ]] && source $HOME/dotfiles/.aliases

        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

        # load base16 theme
        BASE16_SHELL="$HOME/.config/base16-shell/"
        if [ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && [ "$SHLVL" -le 2 ]; then
            source "$BASE16_SHELL/profile_helper.sh"
        fi

        # Tell Maven to use brew java instead of mac one
        if [ -f /usr/libexec/java_home ]; then
            export JAVA_HOME=$(/usr/libexec/java_home -v 1.8 2>/dev/null)
        fi

        NVM_DIR="$HOME/.nvm"
        function load_nvm() {
            if [ -d "$NVM_DIR" ]; then
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
                export NVM_DIR
            fi
        }
      '' + pkgs.lib.optionalString (!pkgs.stdenv.isDarwin) "load_nvm";

      # initExtraBeforeCompInit = '' '';

      initExtraFirst = ''
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
        UNCRUSTIFY_CONFIG = "${home}/.config/uncrustify.cfg";
      };

      # shellAliases = {};
      # shellGlobalAliases = {};

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
          extraConfig = ''
            zstyle ':omz:plugins:git' aliases no
          '';
          plugins = [ "git" "sudo" ];
        };
    };
  };
}

