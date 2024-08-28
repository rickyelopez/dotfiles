{ self, pkgs, home, ... }: {
  services = {
    nix-daemon.enable = true;
    activate-system.enable = true;
  };

  users.users."ricky.lopez" = {
    home = home;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
  ];

  programs.zsh.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "derailed/k9s"
      "homebrew/services"
      "koekeishiya/formulae"
      "mutagen-io/mutagen"
      "cmacrae/formulae"
    ];

    brews = [
      # "bazelisk"
      # "ffmpeg"
      "gdal"
      # "git-lfs"
      # "htop"
      "iproute2mac"
      # "k9s"
      "libgit2"
      "opencv"
      "openjdk"
      "portaudio"
      # "rsync"
      "pam-reattach"
      "skhd"
      # "socat"
      # "cmacrae/formulae/spacebar"
      "tcl-tk"
      # "util-linux"
      # "watch"
      # "wget"
      "zlib"
    ];

    casks = [
      "bluesnooze"
      "karabiner-elements"
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

  nix = {
    package = pkgs.nix;
    useDaemon = true;
    settings = {
      trusted-users = [ "ricky.lopez" ];
      cores = 8;
    };
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
      NSGlobalDomain = {
        # AppleKeyboardUIMode = 3;
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        # NSAutomaticWindowAnimationsEnabled = false;
        # NSNavPanelExpandedStateForSaveMode = true;
        # NSNavPanelExpandedStateForSaveMode2 = true;
        # "com.apple.keyboard.fnState" = true;
        # _HIHideMenuBar = true;
        # "com.apple.mouse.tapBehavior" = 1;
        # "com.apple.sound.beep.volume" = 0.0;
        # "com.apple.sound.beep.feedback" = 0;
        # ApplePressAndHoldEnabled = false;
      };

      CustomUserPreferences = {
        "com.apple.finder" = {
          # ShowExternalHardDrivesOnDesktop = false;
          # ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          # _FXSortFoldersFirst = true;
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
          AppleShowAllExtensions = true;
          ShowPathbar = true;
          FXEnableExtensionChangeWarning = false;
        };

        # keyboard = {
        #   enableKeyMapping = true;
        #   remapCapsLockToControl = true;
        # };
      };
    };
  };
}
