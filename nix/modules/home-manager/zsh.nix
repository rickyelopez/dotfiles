{
  config,
  lib,
  hostSpec,
  ...
}:
let
  cfg = config.my.zsh;
  home = hostSpec.home;
in
{
  options.my.zsh = {
    enable = lib.mkEnableOption "home zsh module.";
    minimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Only enable a subset of zsh features. Ideal for servers";
    };
    starship = lib.mkOption {
      type = lib.types.bool;
      default = (!cfg.minimal);
      description = "Whether or not to use Starship";
    };
    zprof = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zprofiling";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # this first attrset applies to both minimal and full
      {
        assertions = [
          {
            assertion = !(cfg.minimal && cfg.starship);
            message = "Cannot enable Starship with minimal! Either set my.zsh.starship or my.zsh.minimal to false";
          }
        ];

        home = {
          sessionPath = [ "$HOME/.local/bin" ];

          shellAliases = lib.mkIf (!cfg.minimal) {
            lg = "lazygit";
          };
        };

        my.starship.enable = cfg.starship;

        programs.zsh = {
          enable = true;

          history = {
            append = true;
            save = 10000;
            size = 10000;
          };

          initContent = lib.mkMerge [
            (lib.mkOrder 500 /* bash */ ''
              # make ssh work in tmux across reconnections
              if [[ -n "$SSH_TTY" ]] && [[ -n "$SSH_AUTH_SOCK" ]]; then
                export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.$(hostname)
              fi
            '')

            (lib.mkIf cfg.zprof (lib.mkOrder 505 /* bash */ ''
              zmodload zsh/datetime
              typeset -gA __zsh_profile_start_times

              function __zsh_profile_start() {
                __zsh_profile_start_times[$1]=$EPOCHREALTIME
              }

              function __zsh_profile_end() {
                local start=$__zsh_profile_start_times[$1]
                [[ -z "$start" ]] && return
                printf 'zsh startup: %6.2f ms  %s\n' $(( (EPOCHREALTIME - start) * 1000 )) "$1" >&2
                unset "__zsh_profile_start_times[$1]"
              }
            ''))

            (lib.mkOrder 525 /* bash */ ''
              # Home Manager adds each profile's stock zsh functions tree to
              # fpath. On systems with layered Nix profiles, those are duplicate
              # aliases of zsh's own functions and make compinit scan extra files.
              zsh_functions_dir="/share/zsh/$ZSH_VERSION/functions"
              zsh_store_functions_dir=""

              for dir in $fpath; do
                if [[ "$dir" == /nix/store/*"$zsh_functions_dir" && -d "$dir" ]]; then
                  zsh_store_functions_dir="$dir"
                  break
                fi
              done

              if [[ -n "$zsh_store_functions_dir" ]]; then
                fpath=(
                  ''${^fpath:#*/share/zsh/$ZSH_VERSION/functions}
                  "$zsh_store_functions_dir"
                )
              fi

              unset dir zsh_functions_dir zsh_store_functions_dir
            '')

            (lib.mkOrder 1500 /* bash */ ''
              # source private files
              [ -f "$HOME/dotfiles_priv/.privrc" ] && source "$HOME/dotfiles_priv/.privrc"
              [ -f "$HOME/dotfiles_priv/.vars" ] && source "$HOME/dotfiles_priv/.vars"
              [ -f "$HOME/dotfiles_priv/.aliases" ] && source "$HOME/dotfiles_priv/.aliases"
            '')
          ];

          localVariables = {
            DISABLE_UPDATE_PROMPT = "true";
            ZSH_DISABLE_COMPFIX = "true";
          };

          sessionVariables = {
            XDG_CONFIG_HOME = "${home}/.config";
          };

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

          zprof.enable = cfg.zprof;
        };
      }
      # this second attrset only applies to full
      (lib.mkIf (!cfg.minimal) {
        home.sessionPath = [
          "$HOME/.cargo/bin"
        ]
        ++ lib.optionals (hostSpec.isDarwin) [
          "$(/opt/homebrew/bin/brew --prefix)/opt/util-linux/bin"
          "$(/opt/homebrew/bin/brew --prefix)/opt/util-linux/sbin"
        ];

        programs.zsh = {
          antidote = {
            enable = true;
            plugins = [
              "tinted-theming/tinted-shell"
            ];
          };

          autosuggestion.enable = true;

          initContent = lib.mkMerge [
            (lib.mkOrder 500 /* bash */ ''
              [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
            '')

            (lib.mkOrder 1000 /* bash */ ''
              NVM_DIR="$HOME/.nvm"
              function load_nvm() {
                if [ -d "$NVM_DIR" ]; then
                  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
                  export NVM_DIR
                fi
              }

              ## activate python env from typical directories or from the given path
              function activate() {
                if [ "$#" -eq 0 ]; then
                  if [ -f ./env/bin/activate ]; then
                    source ./env/bin/activate
                  elif [ -f ./.venv/bin/activate ]; then
                    source ./.venv/bin/activate
                  else
                    echo "No venv detected"
                  fi
                else
                  if [ -f "$1"/bin/activate ]; then
                    source "$1"/bin/activate
                  else
                    echo "'$1/bin/activate' does not exist"
                  fi
                fi
              }

              # source private files
              [ -f "$HOME/dotfiles_priv/.privrc" ] && source "$HOME/dotfiles_priv/.privrc"
              [ -f "$HOME/dotfiles_priv/.vars" ] && source "$HOME/dotfiles_priv/.vars"
              [ -f "$HOME/dotfiles_priv/.aliases" ] && source "$HOME/dotfiles_priv/.aliases"

              # [ $(uname) = "Darwin" ] && load_nvm
            '')
          ];

          sessionVariables = {
            UNCRUSTIFY_CONFIG = "${home}/.config/uncrustify.cfg";
          };

          oh-my-zsh = {
            enable = true;
            extraConfig = /* bash */ "";
            plugins = [ "rust" ];
          };
        };
      })
    ]
  );
}
