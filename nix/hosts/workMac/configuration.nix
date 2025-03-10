{ self, pkgs, lib, home, user, ... }: {
  services = {
    nix-daemon.enable = true;
  };

  nix = {
    useDaemon = true;

    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    # Disable auto-optimise-store because of this issue:
    #   https://github.com/NixOS/nix/issues/7273
    # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = false;
      warn-dirty = false;
    };
  };

  users.users."${user}" = {
    home = home;
  };

  # I think this will link in stuff like terminfo. Should this be added globally?
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = [ ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/services"
      "pantsbuild/tap"
    ];

    brews = [
      "ccache"
      "cmake"
      "gdal"
      "iproute2mac"
      "libgit2"
      "opencv"
      "openjdk"
      "openssl"
      "pam-reattach"
      "portaudio"
      "readline"
      "skhd"
      "sqlite3"
      "tcl-tk@8"
      "xz"
      "zlib"
    ];

    casks = [
      "bitwarden"
      "bluesnooze"
      "caffeine"
      "foxitreader"
      "gcc-arm-embedded"
      "ghostty"
      "hammerspoon"
      "karabiner-elements"
      "pants"
      "vlc"
      "wireshark"
    ];

    masApps = { };
  };


  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowInsecure = false;
      allowUnsupportedSystem = false;

      permittedInsecurePackages = [ ];
    };
    hostPlatform = "aarch64-darwin";
  };

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    stateVersion = 4;
    configurationRevision = self.rev or self.dirtyRev or null;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and
      # apply them to the current session, so we do not need to logout and
      # login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      # customize settings that not supported by nix-darwin directly
      # Incomplete list of macOS `defaults` commands :
      #   https://github.com/yannbertrand/macos-defaults
      NSGlobalDomain = {
        # _HIHideMenuBar = true;
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;

        AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
        ApplePressAndHoldEnabled = true; # enable press and hold
        # sets how long it takes before held key starts repeating.
        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        KeyRepeat = 2; # minimum is 2 (30 ms), maximum is 120 (1800 ms)

        "com.apple.swipescrolldirection" = false; # natural scrolling (default: true)
        # "com.apple.keyboard.fnState" = true;
        # "com.apple.mouse.tapBehavior" = 1;
        # "com.apple.sound.beep.volume" = 0.0;
        # "com.apple.sound.beep.feedback" = 0;
        # "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key

        NSAutomaticCapitalizationEnabled = false; # disable auto capitalization
        NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution
        NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution
        NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution
        NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction
        NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowShouldDragOnGesture = true; # move window by dragging while holding Ctrl + Cmd
      };

      CustomUserPreferences = {
        ".GlobalPreferences" = {
          # automatically switch to a new space when switching to the application
          AppleSpacesSwitchOnActivate = true;
        };

        "com.apple.finder" = {
          # ShowExternalHardDrivesOnDesktop = false;
          # ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
        };

        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.spaces" = {
          "spans-displays" = 0; # Display have seperate spaces
        };

        "com.apple.screencapture" = {
          location = "~/Desktop/screenshots";
          type = "png";
        };

        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };

        dock = {
          autohide = true;
          # orientation = "right";
          launchanim = false;
          show-process-indicators = true;
          show-recents = false;
          # static-only = true;
          mru-spaces = false;
        };

        finder = {
          _FXShowPosixPathInTitle = true;
          AppleShowAllExtensions = true;
          FXEnableExtensionChangeWarning = false;
          ShowPathbar = true;
          ShowStatusBar = true;
        };

        # keyboard = {
        #   enableKeyMapping = true;
        #   remapCapsLockToControl = true;
        # };
      };
    };
  };
  imports = [
    ../../modules/nix-darwin/aerospace.nix
  ];
}

