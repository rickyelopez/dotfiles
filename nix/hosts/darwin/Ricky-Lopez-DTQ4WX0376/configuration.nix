{ self, pkgs, config, ... }:
let
  home = config.hostSpec.home;
  user = config.hostSpec.username;
in
{
  nix.enable = true;

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
      "portaudio"
      "readline"
      # "skhd"
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
      "ksnip"
      "pants"
      "vlc"
      "wireshark"
    ];

    masApps = { };
  };

  security.pam.services.sudo_local = {
    # unfortunately we can't use the following options because we want `ignore_ssh` at the end of the `pam_reattach` entry
    # https://github.com/LnL7/nix-darwin/pull/1344#issuecomment-2738164190
    # touchIdAuth = true;
    # reattach = true;
    text = ''
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';
  };

  system = {
    primaryUser = user;
    configurationRevision = self.rev or self.dirtyRev or null;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postActivation.text = ''
      # activateSettings -u will reload the settings from the database and
      # apply them to the current session, so we do not need to logout and
      # login again to make the changes take effect.
      sudo -u ${user} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      # Incomplete list of macOS `defaults` commands :
      #   https://github.com/yannbertrand/macos-defaults

      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };

        "com.apple.CloudSubscriptionFeatures.optIn" = {
          "545129924" = false; # disable apple intelligence
        };
      };

      ".GlobalPreferences" = {
        # "com.apple.mouse.scaling" = ;
        # "com.apple.sound.beep.sound" = ;
      };
      ActivityMonitor = {
        # IconType = ;
        # OpenMainWindow = ;
        # ShowCategory = ;
        # SortColumn = ;
        # SortDirection = ;
      };
      # LaunchServices.LSQuarantine = ;
      NSGlobalDomain = {
        # AppleEnableMouseSwipeNavigateWithScrolls = ;
        # AppleEnableSwipeNavigateWithScrolls = ;
        # AppleFontSmoothing = ;
        # AppleICUForce24HourTime = ;
        AppleInterfaceStyle = "Dark";
        # AppleInterfaceStyleSwitchesAutomatically = ;
        AppleKeyboardUIMode = 3;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = false;
        AppleScrollerPagingBehavior = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleShowScrollBars = "Automatic";
        AppleSpacesSwitchOnActivate = false;
        AppleTemperatureUnit = "Celsius";
        # AppleWindowTabbingMode = ;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDisableAutomaticTermination = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSScrollAnimationEnabled = true;
        NSTableViewDefaultSizeMode = 2;
        NSTextShowsControlCharacters = false;
        NSUseAnimatedFocusRing = true;
        NSWindowResizeTime = 0.2;
        NSWindowShouldDragOnGesture = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
        _HIHideMenuBar = false;
        "com.apple.keyboard.fnState" = false; # enable fn keys behaving as normal fn keys (instead of apple stuff)
        "com.apple.mouse.tapBehavior" = 1; # enable tap to click
        "com.apple.sound.beep.feedback" = 1;
        # "com.apple.sound.beep.volume" = 0.0;
        # "com.apple.springing.delay" = ;
        # "com.apple.springing.enabled" = ;
        "com.apple.swipescrolldirection" = false;
        "com.apple.trackpad.enableSecondaryClick" = true;
        "com.apple.trackpad.forceClick" = true;
        "com.apple.trackpad.scaling" = 1.8;
        "com.apple.trackpad.trackpadCornerClickBehavior" = null; # 1 enables right click
      };
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
      WindowManager = {
        AppWindowGroupingBehavior = false;
        AutoHide = false;
        EnableStandardClickToShowDesktop = true;
        # EnableTiledWindowMargins = ;
        # GloballyEnabled = ;
        # HideDesktop = ;
        # StageManagerHideWidgets = ;
        # StandardHideDesktopIcons = ;
        # StandardHideWidgets = ;
      };
      alf = {
        # allowdownloadsignedenabled = ;
        # allowsignedenabled = ;
        # globalstate = ;
        # loggingenabled = ;
        # stealthenabled = ;
      };
      controlcenter = {
        # AirDrop = ;
        BatteryShowPercentage = true;
        Bluetooth = true;
        Display = true;
        # FocusModes = ;
        NowPlaying = true;
        Sound = true;
      };
      dock = {
        # enable-spring-load-actions-on-all-items = ;
        # appswitcher-all-displays = ;
        autohide = true;
        # autohide-delay = ;
        # autohide-time-modifier = ;
        # dashboard-in-overlay = ;
        # expose-animation-duration = ;
        # expose-group-apps = ;
        # largesize = ;
        launchanim = false;
        # magnification = ;
        # mineffect = ;
        # minimize-to-application = ;
        # mouse-over-hilite-stack = ;
        mru-spaces = false;
        # orientation = ;
        # persistent-apps = ;
        # persistent-others = ;
        # scroll-to-open = ;
        show-process-indicators = true;
        show-recents = false;
        # showhidden = ;
        # slow-motion-allowed = ;
        # static-only = ;
        # tilesize = ;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        # CreateDesktop = ;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        FXRemoveOldTrashItems = false;
        NewWindowTarget = "Home";
        # NewWindowTargetPath = ;
        QuitMenuItem = false;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
        _FXSortFoldersFirstOnDesktop = false;
      };
      hitoolbox.AppleFnUsageType = "Do Nothing";
      loginwindow = {
        DisableConsoleAccess = false;
        GuestEnabled = false;
        # LoginwindowText = ;
        # PowerOffDisabledWhileLoggedIn = ;
        # RestartDisabled = ;
        # RestartDisabledWhileLoggedIn = ;
        # SHOWFULLNAME = ;
        # ShutDownDisabled = ;
        # ShutDownDisabledWhileLoggedIn = ;
        # SleepDisabled = ;
        # autoLoginUser = ;
      };
      magicmouse.MouseButtonMode = "TwoButton";
      menuExtraClock = {
        FlashDateSeparators = false;
        IsAnalog = false;
        Show24Hour = false;
        ShowAMPM = true;
        ShowDate = 1;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
        ShowSeconds = true;
      };
      screencapture = {
        # disable-shadow = ;
        # include-date = ;
        location = "~/Desktop/screenshots";
        # show-thumbnail = ;
        # target = ;
        type = "png";
      };
      screensaver = {
        # askForPassword = ;
        # askForPasswordDelay = ;
      };
      smb = {
        # NetBIOSName = ;
        # ServerDescription = ;
      };
      spaces.spans-displays = true;
      trackpad = {
        ActuationStrength = 1;
        Clicking = true;
        # Dragging = ;
        FirstClickThreshold = 1;
        SecondClickThreshold = 2;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        TrackpadThreeFingerTapGesture = 0;
      };
      # universalaccess = {
      #   # closeViewScrollWheelToggle = ;
      #   # closeViewZoomFollowsFocus = ;
      #   # mouseDriverCursorSize = ;
      #   reduceMotion = true;
      #   # reduceTransparency = ;
      # };
    };
  };
  imports = [
    ../../common/optional/aerospace.nix
  ];
}

