{ config, pkgs, lib, inputs, outputs, unstable, fork, local, ... }: {
  imports = [
    ./scripts
    ./programs
    ./boot
    ./services
    ./systemd
    ./security
    ./hardware
    ./environment
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.hello.nixosModules.default
    inputs.nordvpn.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = { justin = import ./home.nix; };
  };

  services.hello.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  networking.firewall = { enable = true; };

  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.justin = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Justin";
    extraGroups = [ "networkmanager" "wheel" "audio" "nordvpn" ];
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    roboto
    material-icons
  ];

  system.stateVersion = "23.11";
}
