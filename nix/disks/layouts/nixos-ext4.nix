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
      root = {
        size = "100%";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
          mountOptions = [
            "noatime"
          ];
        };
      };
      swap = (
        if disk.withSwap then
          {
            size = "${toString disk.swapSizeGigabytes}G";
            content = {
              type = "swap";
              discardPolicy = "both";
            };
          }
        else
          { }
      );
    };
  };
}
