{ config, pkgs, ... }:
let
  wg_port = 51820;
  wg_privkey = config.sops.secrets."wireguard/${config.hostSpec.hostname}".path;
in
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # hack to get hwmon device ordering to be somewhat consistent
    kernelModules = [ "coretemp" ];
  };

  hardware.fancontrol = {
    enable = true;
    config = /* ini */ ''
      DEVPATH=hwmon3=devices/platform/dell_smm_hwmon hwmon2=devices/platform/coretemp.0

      DEVNAME=hwmon3=dell_smm hwmon2=coretemp

      FCTEMPS=hwmon3/pwm1=hwmon2/temp1_input hwmon3/pwm2=hwmon2/temp1_input

      FCFANS=hwmon3/pwm1=hwmon3/fan1_input hwmon3/pwm2=hwmon3/fan2_input

      INTERVAL=1
      AVERAGE=hwmon3/pwm2=15 hwmon3/pwm1=10

      # the following values are in degC
      # MINTEMP: The temperature below which the fan gets switched to minimum speed
      # MAXTEMP: The temperature over which the fan gets switched to maximum speed
      MINTEMP=hwmon3/pwm2=60 hwmon3/pwm1=60
      MAXTEMP=hwmon3/pwm2=70 hwmon3/pwm1=70

      # the following values are in PWM (0-255)
      # MINSTART: sets the minimum speed at which the fan begins spinning. You should use a safe value to be sure
      #    it works, even when the fan gets old
      # MINSTOP: The minimum speed at which the fan still spins. Use a safe value here too
      # MINPWM: The PWM value to use when the temperature is below MINTEMP. Typically, this will be either 0 if it
      #     is OK for the fan to plain stop, or the same value as MINSTOP if you don't want the fan to ever stop.
      #     If this value isn't defined, it defaults to 0 (stopped fan)
      MINSTART=hwmon3/pwm2=64 hwmon3/pwm1=64
      MINSTOP=hwmon3/pwm2=64 hwmon3/pwm1=64
      MINPWM=hwmon3/pwm2=64 hwmon3/pwm1=64
      MAXPWM=hwmon3/pwm2=192 hwmon3/pwm1=192
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

  networking.networkmanager.enable = true;

  services = {
    logind.settings.Login.HandleLidSwitch = "ignore"; # disable lid switch, we handle it in hyprland

    # services.power-profiles-daemon.enable = true;

    hardware.dell-bios-fan-control.enable = true;

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

  systemd = {
    sleep.extraConfig = ''
      SuspendState=mem
      MemorySleepMode=deep
    '';
    # enable fprintd debug
    services.fprintd.environment = {
      G_MESSAGES_DEBUG = "all";
    };
  };

  networking.firewall.allowedTCPPorts = [
    8080 # calibre
  ];

  sops.secrets = {
    "wireguard/${config.hostSpec.hostname}" = { };
  };

  networking.firewall = {
    allowedUDPPorts = [ wg_port ];
  };

  networking.wireguard.enable = false;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.255.254.10/24" ];
      listenPort = wg_port;
      privateKeyFile = wg_privkey;
      peers = [
        {
          publicKey = "xjQby/0vO5YKKi8k0xdybzsXt96nxotkx83GXeeERAw=";
          allowedIPs = [
            "10.255.254.0/24"
            "10.19.21.0/24"
            "10.7.51.0/24"
          ];
          endpoint = "elxpd.com:51821";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # add udev rules that will create symlinks to the appropriate card in /dev/dri for use with hyprland
  services.udev.extraRules = ''
    KERNEL=="card*", KERNELS=="0000:01:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/dgpu"
    KERNEL=="card*", KERNELS=="0000:00:02.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/igpu"
  '';
}
