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
            zipcdb = "ninja -C out all_apps -t compdb | jq \'[ .[] | select(.command | contains(\"bad_toolchain\")|not) ]\' > compile_commands.json";
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

            (lib.mkOrder 1500 /* bash */ ''
              # source private files
              [ -f "$HOME/dotfiles_priv/.privrc" ] && source "$HOME/dotfiles_priv/.privrc"
              [ -f "$HOME/dotfiles_priv/.vars" ] && source "$HOME/dotfiles_priv/.vars"
              [ -f "$HOME/dotfiles_priv/.aliases" ] && source "$HOME/dotfiles_priv/.aliases"
            '')
          ];

          # initExtraBeforeCompInit = /*bash*/'' '';

          # initExtraFirst = /*bash*/ '' '';

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

            (lib.mkOrder 1000 (
              /* bash */ ''
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

                # source private files
                [ -f "$HOME/dotfiles_priv/.privrc" ] && source "$HOME/dotfiles_priv/.privrc"
                [ -f "$HOME/dotfiles_priv/.vars" ] && source "$HOME/dotfiles_priv/.vars"
                [ -f "$HOME/dotfiles_priv/.aliases" ] && source "$HOME/dotfiles_priv/.aliases"
              ''
              + lib.optionalString (!hostSpec.isDarwin) "load_nvm"
            ))
          ];

          sessionVariables = {
            UNCRUSTIFY_CONFIG = "${home}/.config/uncrustify.cfg";
          };

          oh-my-zsh = {
            enable = true;
            extraConfig = /* bash */ '''';
            plugins = [ "rust" ];
          };
        };
      })
    ]
  );
}
