{
  description = "flakes";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    agenix.url = "github:ryantm/agenix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      agenix,
      disko,
      vscode-server,
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
	    vscode-server.nixosModules.default
	    ({ config, pkgs, ... }: {
		    services.vscode-server.enable = true;
	    })
          ];
        };
      };
    };
}
