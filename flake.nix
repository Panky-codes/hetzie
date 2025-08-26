{
  description = "flakes";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    agenix.url = "github:ryantm/agenix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      agenix,
      disko,
      ...
    }:
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {

        hetzie = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            disko.nixosModules.disko
            ./hetzie/disk-config.nix
            ./hetzie/configuration.nix
            ./hetzie/age.nix
            ./hetzie/users.nix
            { environment.systemPackages = [ agenix.packages.x86_64-linux.default ]; }
          ];
        };
      };
    };
}
