{ lib, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  imports = [
    ./starship.nix
    ./zsh-minimal.nix
  ];

  home = {
    sessionPath = [
      "$HOME/.cargo/bin"
    ] ++ lib.optionals (hostSpec.isDarwin) [
      "$(/opt/homebrew/bin/brew --prefix)/opt/util-linux/bin"
      "$(/opt/homebrew/bin/brew --prefix)/opt/util-linux/sbin"
    ];

    shellAliases = {
      lg = "lazygit";
      zipcdb = "ninja -C out all_apps -t compdb | jq \'[ .[] | select(.command | contains(\"bad_toolchain\")|not) ]\' > compile_commands.json";
    };
  };

  programs = {
    zsh = {
      antidote = {
        enable = true;
        plugins = [
          "tinted-theming/tinted-shell"
        ];
      };

      autosuggestion.enable = true;

      initExtra = /*bash*/ ''
        [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

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
      '' + lib.optionalString (!hostSpec.isDarwin) "load_nvm";

      # initExtraBeforeCompInit = /*bash*/'' '';

      # initExtraFirst = /*bash*/ '' '';

      # localVariables = { };

      sessionVariables = {
        UNCRUSTIFY_CONFIG = "${home}/.config/uncrustify.cfg";
      };

      # shellAliases = {};
      # shellGlobalAliases = { };

      oh-my-zsh = {
        enable = true;
        extraConfig = /*bash*/ '' '';
        plugins = [ "rust" ];
      };
    };
  };
}
