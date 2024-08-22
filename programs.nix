{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = map lib.lowPrio (with pkgs; [
    curl
    htop
    tailscale
    gitMinimal
  ]);

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
