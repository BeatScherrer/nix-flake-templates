{
  description = "NixOS hetzner flake template";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
      disko,
      ...
    }:
    {

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./nix/default/configuration.nix
        ];
      };

      deploy.nodes.default = {
        hostname = "n8n.shetec.ch"; # change this to your server IP or FQDN
        sshUser = "root";
        sshOpts = [
          "-4"
          "-i"
          "/home/beat/.ssh/shetec"
        ];

        profiles.system = {
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.default;
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
