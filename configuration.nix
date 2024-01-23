{ config, pkgs, lib, inputs, outputs, unstable, fork, ... }: {
  imports = [
    ./scripts
    ./programs
    ./boot
    ./services
    ./systemd
    ./security
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = { justin = import ./home.nix; };
  };

  environment.pathsToLink = [ "/libexec" ];

  users.users.justin.shell = pkgs.fish;
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  networking.hostName = "nixos"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.pulseaudio.enable = true;

  users.users.justin = {
    isNormalUser = true;
    description = "Justin";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };

  nixpkgs.config.allowUnfree = true;
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    git
    fzf
    fishPlugins.fzf-fish
    starship
    fd
    bat
    brightnessctl
    pamixer
    socat
    killall
    glib
    rose-pine-gtk-theme
    bibata-cursors
    jc
    linuxKernel.packages.linux_xanmod_latest.cpupower
    mpv
    unstable.hyprshot
    hyprshade
    fork.ddcutil
    unstable.swaylock-effects
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    roboto
    material-icons
  ];

  networking.firewall.enable = true;
  system.stateVersion = "23.11";
}
