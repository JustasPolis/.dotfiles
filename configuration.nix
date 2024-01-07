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
      gsettings set $gnome_schema gtk-theme 'rose-pine'
      gsettings set $gnome_schema font-antialiasing 'grayscale'
      gsettings set $gnome_schema font-hinting 'slight'
      gsettings set $gnome_schema font-name 'Roboto medium, 10'
      gsettings set $gnome_schema cursor-theme 'Bibata-Modern-Ice'
      gsettings set $gnome_schema cursor-size 24
      gsettings set $gnome_schema toolbar-icons-size 'small'
      gsettings set org.gnome.mutter auto-maximize 'false'
    '';
  };
  power-settings = pkgs.writeShellScriptBin "power-settings" ''
    sudo cpupower frequency-set --governor powersave
    echo "balance_power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
  '';
in {
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
    sudo systemctl stop bluetooth
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

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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
  services.mullvad-vpn.enable = true;

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
    configure-gtk
    glib
    rose-pine-gtk-theme
    bibata-cursors
    power-settings
    linuxKernel.packages.linux_xanmod_latest.cpupower
    mpv
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

  security.pam.loginLimits = [{
    domain = "@users";
    item = "rtprio";
    type = "-";
    value = 1;
  }];

  boot.kernelParams = [
    "quiet"
  ];

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl suspend";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/reboot";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/poweroff";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop bluetooth";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start bluetooth";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/cpupower";
          options = [ "NOPASSWD" ];
        }
        {
          command =
            "/run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference";
          options = [ "NOPASSWD" ];

        }
      ];
      groups = [ "wheel" ];
    }];
  };
}
