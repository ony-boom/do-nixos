{
  modulesPath,
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

  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];

  users.users.root.openssh.authorizedKeys.keys = [
		# your public ssh key here
  ];

  system.stateVersion = "24.11";
}
