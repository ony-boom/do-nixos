{
  modulesPath,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix

    ./programs.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  services.tailscale.enable = true;

  environment.systemPackages = map lib.lowPrio (with pkgs; [
    curl
		htop
    tailscale
    gitMinimal
  ]);

  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFk4ydn78plOeWDhjNZbQSJbKr6mLciXme4XmYmzYnXy onyrakoto27@gmail.com"
  ];

  system.stateVersion = "24.11";
}
