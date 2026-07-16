disk: {
  type = "disk";
  device = disk.device;
  content = {
    type = "gpt";
    partitions = {
      ESP = {
        priority = 1;
        name = "ESP";
        size = "512M";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "defaults" ];
        };
      };
      luks = {
        size = "100%";
        content = {
          type = "luks";
          name = "encrypted-nixos";
          # passwordFile = config.sops.secrets."passwords/${config.hostSpec.username}".path;
          askPassword = true;
          settings = {
            allowDiscards = true;
          };
          # Subvolumes must set a mountpoint in order to be mounted,
          # unless their parent is mounted
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # force overwrite
            subvolumes = {
              "@root" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@swap" = (
                if disk.withSwap then
                  {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "${toString disk.swapSizeGigabytes}G";
                  }
                else
                  { }
              );
            };
          };
        };
      };
    };
  };
}
