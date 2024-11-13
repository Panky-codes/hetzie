# Hetzie

## How to change the base configuration from your local laptop:
If you are running nixos on your local laptop, then we could use
the remote rebuild option as follows:

```
nixos-rebuild  --flake .#hetzie --use-remote-sudo --target-host <ssh-host> switch
```

This is possible because all the member of group `@wheel` are a part of
the `truster-users`.

Or just the usual without `--use-remote-sudo` `--target-host` on the
server if you are not running nixos.

## How to recreate this server (when shit hits the fan):
Unfortunately, it was not very trivial to bootstrap hetzie from
nixos-anywhere due to remote disk unlocking feature. 
`initrd` ssh required separate ssh host keys, which was tricky automate
with nixos-anywhere. So the installation was a bit manual but `disko`
takes care of all the tedious partitioning.

- Go to hetzner robot console and install the ubuntu so that we get ssh
  access to the server. This will destroy all the contents.
- Add you ssh host key to the server.
- Run the nixos installer with [kexec](https://nixos.wiki/wiki/Install_NixOS_on_a_Server_With_a_Different_Filesystem) .
- Run the following commands from the nixos installer:
```
$ nix-channel --update
$ nix-shell -p gitMinimal vim
$ git clone git@github.com:SamsungDS/nix-config-hetzner
# Check if the disks are represented properly
$ nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko hetzie/disk-config.nix
$ mkdir -p /mnt/etc/secrets/initrd
$ ssh-keygen -t rsa -N "" -f /mnt/etc/secrets/initrd/ssh_host_rsa_key
$ nixos-generate-config --show-hardware-config --no-filesystems > hetzie/hardware-configuration.nix
$ nixos-install --flake .#hetzie
```
- Reboot

## How to decrypt the secrets:
```
$ #Encrypt
$ agenix -e priv_pass.age
$ #Decrypt
$ agenix -d priv_pass.age -i <your-ssh-key-used-for-login>
```
