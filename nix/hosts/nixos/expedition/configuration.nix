{ pkgs, inputs, ... }:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # hack to get hwmon device ordering to be somewhat consistent
  boot.kernelModules = [ "coretemp" ];

  hardware.fancontrol = {
    enable = true;
    config = /*bash*/ ''
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

  # the rest of the nvidia config is in ../../common/optional/nvidia.nix, but this is super host-specific
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  fileSystems."/mnt/arch" = {
    device = "/dev/disk/by-uuid/e68379cc-f041-4d77-9548-e0b9e1d1566a";
    fsType = "ext4";
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services = {
    dbus.enable = true;

    gnome.gnome-keyring.enable = true;

    logind.lidSwitch = "ignore"; # disable lid switch, we handle it in hyprland

    # services.power-profiles-daemon.enable = true;

    tlp = {
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

    upower.enable = true;

    fprintd = {
      enable = true;
      package = pkgs.fprintd.override { libfprint = pkgs.libfprint-goodix; };
      # tod.enable = true;
      # tod.driver = inputs.nixpkgs-local.legacyPackages.x86_64-linux.pkgs.libfprint-goodix;
    };

  };

  # enable fprintd debug
  systemd.services.fprintd.environment = {
    G_MESSAGES_DEBUG = "all";
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
    8080 # calibre
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
