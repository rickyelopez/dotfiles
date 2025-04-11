{ config, pkgs, inputs, lib, ... }:
let pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # hack to get hwmon device ordering to be somewhat consistent
  boot.kernelModules = [ "coretemp" ];

  hardware.fancontrol = {
    enable = true;
    config = ''
      DEVPATH=hwmon6=devices/platform/dell_smm_hwmon hwmon2=devices/platform/coretemp.0

      DEVNAME=hwmon6=dell_smm hwmon2=coretemp

      FCTEMPS=hwmon6/pwm1=hwmon2/temp1_input hwmon6/pwm2=hwmon2/temp1_input

      FCFANS=hwmon6/pwm1=hwmon6/fan1_input hwmon6/pwm2=hwmon6/fan2_input

      INTERVAL=1
      AVERAGE=hwmon6/pwm2=15 hwmon6/pwm1=10

      # the following values are in degC
      # MINTEMP: The temperature below which the fan gets switched to minimum speed
      # MAXTEMP: The temperature over which the fan gets switched to maximum speed
      MINTEMP=hwmon6/pwm2=60 hwmon6/pwm1=60
      MAXTEMP=hwmon6/pwm2=70 hwmon6/pwm1=70

      # the following values are in PWM (0-255)
      # MINSTART: sets the minimum speed at which the fan begins spinning. You should use a safe value to be sure
      #    it works, even when the fan gets old
      # MINSTOP: The minimum speed at which the fan still spins. Use a safe value here too
      # MINPWM: The PWM value to use when the temperature is below MINTEMP. Typically, this will be either 0 if it
      #     is OK for the fan to plain stop, or the same value as MINSTOP if you don't want the fan to ever stop.
      #     If this value isn't defined, it defaults to 0 (stopped fan)
      MINSTART=hwmon6/pwm2=64 hwmon6/pwm1=64
      MINSTOP=hwmon6/pwm2=64 hwmon6/pwm1=64
      MINPWM=hwmon6/pwm2=64 hwmon6/pwm1=64
      MAXPWM=hwmon6/pwm2=192 hwmon6/pwm1=192
    '';
  };

  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings.General.Experimental = true; # enable bluetooth device battery display
  };

  hardware.graphics = {
    enable = true;
    package = pkgs-unstable.mesa.drivers;
    enable32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];


  fileSystems."/mnt/arch" =
    {
      device = "/dev/disk/by-uuid/e68379cc-f041-4d77-9548-e0b9e1d1566a";
      fsType = "ext4";
    };

  networking.hostName = config.hostSpec.hostname; # Define your hostname.
  networking.hosts = {
    "10.19.21.31" = [ "sathub" "sathub.forestroot.elexpedition.com" ];
    "10.19.21.30" = [ "fob" "fob.forestroot.elexpedition.com" ];
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  madness.enable = true;

  nixpkgs = {
    overlays = [ inputs.hyprpanel.overlay ];
  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = lib.mkForce true;
    config = {
      common = {
        default = [ "hyprland;gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
    xdgOpenUsePortal = true;
  };

  xdg.mime = {
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    feh
    ffmpegthumbnailer
    gdb
    gedit
    gpustat
    grim
    inputs.hyprpolkitagent.packages.${pkgs.system}.default
    killall
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    mesa-demos
    nextcloud-client
    nodejs_23
    pamixer
    pavucontrol
    pipx
    pkg-config
    qalculate-gtk
    rustdesk
    slurp
    swappy
    usbutils
  ];

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
    xfconf.enable = true;

    zsh.enable = true;
    steam.enable = true;
  };

  services.blueman.enable = true;
  services.dbus.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.logind.lidSwitch = "ignore"; # disable lid switch, we handle it in hyprland
  # services.power-profiles-daemon.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      # CPU_SCALING_GOVERNOR_ON_AC = "performance";
      # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MIN_FREQ_ON_BAT = 500;

      CPU_MIN_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 70;

      #Optional helps save long term battery health (currently handling this in bios)
      #START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      #STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };
  services.tumbler.enable = true;
  services.upower.enable = true;

  services.fprintd = {
    enable = true;
    package = pkgs.fprintd.override { libfprint = inputs.nixpkgs-local.legacyPackages.x86_64-linux.pkgs.libfprint-goodix; };
    # tod.enable = true;
    # tod.driver = inputs.nixpkgs-local.legacyPackages.x86_64-linux.pkgs.libfprint-goodix;
  };
  systemd.services.fprintd.environment = {
    G_MESSAGES_DEBUG = "all";
  };



  # Select locale properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "ricclopez" ]; # Allows all users by default. Can be [ "user1" "user2" ]
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22 # ssh
    8080 # calibre
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
