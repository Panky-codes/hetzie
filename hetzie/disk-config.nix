{ lib, ... }:
{
  disko.devices.disk = lib.genAttrs [ "0" "1" ] (name: {
    type = "disk";
    device = "/dev/nvme${name}n1";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          type = "EF02"; # for grub MBR
        };
        ESP = {
          size = "4G";
          type = "EF00";
          content = {
            type = "mdraid";
            name = "boot";
          };
        };
        swap = {
          size = "4G";
          content = {
            type = "mdraid";
            name = "swap";
          };
        };
        mdadm = {
          size = "100%";
          content = {
            type = "mdraid";
            name = "raid1";
          };
        };
      };
    };
  });
  disko.devices.mdadm = {
    boot = {
      type = "mdadm";
      level = 1;
      metadata = "1.0";
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
      };
    };
    swap = {
      type = "mdadm";
      level = 1;
      metadata = "1.0";
      content = {
        type = "swap";
      };
    };
    raid1 = {
      type = "mdadm";
      level = 1;
      content = {
        type = "filesystem";
        format = "xfs";
        mountpoint = "/";
      };
    };
  };
}
