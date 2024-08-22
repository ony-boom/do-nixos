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

    nix-presentation = {
      enable = true;
      # port = 8080; # Optional
    };
  };
}
