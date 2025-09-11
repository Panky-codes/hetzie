# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./monitoring.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Select kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_16;

  # https://nixos.wiki/wiki/Remote_disk_unlocking
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = [
      "r8169"
      "bnxt_en" # This server has broadcom network card.
    ];
    systemd.users.root.shell = "/bin/cryptsetup-askpass";
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7DQVc0xdPzziGOuFRSvgSRNDyYRn2+7s2K86YFmvq7 p.raghav@samsung.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDoXHJ/4j7kIHmMtLMmqSusvcJpTYUsRp8mZM6QV3HE4 aeh@aeh-pocket"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMImV6kLnytXQt6l1alTWOnOuu9+fvkTyjOyReVNcUx1 Daniel Gomez"
        ];
        hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" ];
        # Enable this while bootstraping the system before adding the
        # ssh_host_rsa_key while installation.
        #ignoreEmptyHostKeys = true;
      };
    };
  };

  networking.hostName = "hetzie";

  time.timeZone = "Europe/Amsterdam";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.trusted-users = [ "root" "@wheel" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # List services that you want to enable:

  virtualisation.libvirtd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 718 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin =
        "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "7d";
    ignoreIP = [
      "79.142.230.34" # Andreas
      "194.62.217.67" # SOHO
    ];
  };

  programs.mosh.enable = true;
  programs.zsh.enable = true;

  # Use nftables rather than iptables
  networking.nftables = {
    enable = true;
    flushRuleset = true;
  };

  # Rejections are flooding the logs
  networking.firewall.logRefusedConnections = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  security.sudo.wheelNeedsPassword = false;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
