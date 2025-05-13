{ lib, ... }: {
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = /*bash*/lib.concatStrings [
          "[](fg:#a3aed2)"
          "$os"
          "[](bg:#769ff0 fg:#a3aed2)"
          "$directory"
          "[](fg:#769ff0 bg:#394260)"
          "$git_branch"
          "$git_state"
          "[](fg:#394260 bg:#212736)"
          "$c"
          "$cpp"
          "$docker_context"
          "$nodejs"
          "$python"
          "$rust"
          "[](fg:#212736 bg:#1d2230)"
          "$time"
          "[ ](fg:#1d2230)"
          "$line_break$character"
        ];

        palettes.gruvbox_dark = {
          color_green = "#98971a";
          color_red = "#cc241d";
        };

        os = {
          disabled = false;
          style = "bg:#a3aed2 fg:#090c0c";
          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            Macos = "󰀵";
            Linux = "󰌽";
            Fedora = "󰣛";
            Arch = "󰣇";
            CentOS = "";
            Debian = "󰣚";
            NixOS = "󱄅";
          };
        };


        directory = {
          style = "fg:#e3e5e5 bg:#769ff0";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            Documents = "󰈙 ";
            Downloads = " ";
            Music = " ";
            Pictures = " ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:#394260";
          format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
        };

        git_state = {
          style = "bg:#394260";
          format = "[$state( [$progress_current/$progress_total])]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:#212736";
          format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
        };

        # just implemented a few days ago, hasn't made it into nixpkgs yet
        # cpp = {
        #   symbol = " ";
        #   style = "bg:#212736";
        #   format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
        #   disabled = false;
        # };

        python = {
          symbol = " ";
          style = "bg:#212736";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        docker_context = {
          symbol = " ";
          style = "bg:#212736";
          format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
        };


        nix_shell = {
          disabled = true;
          symbol = "󱄅 ";
          style = "bg:#212736";
          format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
          impure_msg = "[impure](bold red)";
          pure_msg = "[pure](bold green)";
          unknown_msg = "[unknown](bold yellow)";
        };

        nodejs = {
          symbol = " ";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };

        rust = {
          symbol = " ";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };

        zig = {
          symbol = " ";
          style = "bg:#212736";
          format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#1d2230";
          format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
        };

        line_break = {
          disabled = false;
        };

        character = {
          disabled = false;
          # success_symbol = "[](bold fg:color_green)";
          # error_symbol = "[](bold fg:color_red)";
        };
      };
    };
  };
}
