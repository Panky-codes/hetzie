{ pkgs, ... }:
{
  users.users.panky = {
    isNormalUser = true;
    home = "/home/panky";
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    description = "Pankaj";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwblMdqnsyQSWs75WM+zd7pVuxS7jKbE0XyIZCkAHdJ p.raghav@samsung.com"
    ];
    hashedPassword = "$y$j9T$6ZmrGfiJ4YiqKG19C9cOh1$wSFZkYz1AyW/wNlaUcfphh/W9RUCvECJminXOmtI0xC";
  };

  users.users.andreas = {
    isNormalUser = true;
    home = "/home/andreas";
    description = "Andreas";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDoXHJ/4j7kIHmMtLMmqSusvcJpTYUsRp8mZM6QV3HE4 aeh@aeh-pocket"
    ];
    hashedPassword = "$y$j9T$6ZmrGfiJ4YiqKG19C9cOh1$wSFZkYz1AyW/wNlaUcfphh/W9RUCvECJminXOmtI0xC";
  };
}
