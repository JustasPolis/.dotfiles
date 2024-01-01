{ config, pkgs, lib, inputs, outputs, ... }:
let
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

in
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = { justin = import ./home.nix; };
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  environment.pathsToLink = [ "/libexec" ];
  programs.fish.enable = true;
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" -eq 1
       exec "Hyprland" > /dev/null
    end
  '';
  users.users.justin.shell = pkgs.fish; programs.fish.interactiveShellInit = '' set fish_greeting
  '';
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  networking.hostName = "nixos"; # Define your hostname.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.hyprland.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vilnius";

  i18n.defaultLocale = "en_US.UTF-8";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.justin = {
    isNormalUser = true;
    description = "Justin";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ 
  git
  dbus
  fzf
  fishPlugins.fzf-fish
  starship
  fd
  bat
  brightnessctl
  pamixer
  socat
  killall
  configure-gtk
  glib
  rose-pine-gtk-theme
  xdg-utils
  ];

 services.dbus.enable = true;
 xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  roboto
  ];

  networking.firewall.enable = true;

  security.pam.services.swaylock = { };

  services.upower.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
  '';

  services.acpid = {
    enable = true;
    lidEventCommands = "systemctl suspend";
  };
  system.stateVersion = "23.11";

  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];
}
