{ lib, ... }:
{
  disko.devices.disk = lib.genAttrs [ "a" "b" ] (name: {
    type = "disk";
    device = "/dev/vd${name}";
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
          size = "8G";
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
        type = "luks";
        name = "crypted";
        #settings.keyFile = "/tmp/secret.key";
        content = {
          type = "filesystem";
          format = "xfs";
          mountpoint = "/";
        };
      };
    };
  };
}
