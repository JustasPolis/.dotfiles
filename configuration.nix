{ config, pkgs, lib, inputs, outputs, ... }:

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

  environment.pathsToLink = [ "/libexec" ];
  programs.auto-cpufreq.enable = true;
  programs.fish.enable = true;
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" -eq 1
       exec "Hyprland" > /dev/null
    end
  '';
  users.users.justin.shell = pkgs.fish;
  programs.fish.interactiveShellInit = ''
      set fish_greeting
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
  fzf
  fishPlugins.fzf-fish
  starship
  fd
  bat
  brightnessctl
  pamixer
  ];

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

}
