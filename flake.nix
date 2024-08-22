{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  inputs.nix-presentation.url = "github:ony-boom/nix-presentations";

  outputs = {
    nixpkgs,
    disko,
    deploy-rs,
    self,
    nix-presentation,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages.${system};
    system = "x86_64-linux";
  in {
    apps.${system}.deploy = {
      type = "app";
      program = "${pkgs.deploy-rs}/bin/deploy";
    };
    nixosConfigurations.do-nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        disko.nixosModules.disko
        {disko.devices.disk.disk1.device = "/dev/vda";}
        {
          # do not use DHCP, as DigitalOcean provisions IPs using cloud-init
          networking.useDHCP = nixpkgs.lib.mkForce false;

          services.cloud-init = {
            enable = true;
            network.enable = true;

            # not strictly needed, just for good measure
            # datasource_list = ["DigitalOcean"];
            # datasource.DigitalOcean = {};
          };
        }
        nix-presentation.nixosModules.default
        {
          presentation.enable = true;
        }
        ./configuration.nix
      ];
    };
    deploy.nodes.do-nixos = {
      hostname = "167.99.73.105";
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.do-nixos;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
